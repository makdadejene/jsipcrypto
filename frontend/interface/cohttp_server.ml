open! Core
open! Jsonaf_kernel
open Async_kernel
open! Crypto_src.Types
module Server = Cohttp_async.Server

let crypto_table = Hashtbl.create (module Crypto)

let handler ~body:_ _sock req =
  let uri = Cohttp.Request.uri req in
  let request = Uri.path uri |> String.split ~on:'/' in
  match request with
  | [ _; coin; window ] ->
    let response =
      Crypto_interface.predict_all_prices crypto_table coin window
    in
    let dates, prices =
      ( Array.map response ~f:(fun data_tuple ->
          Jsonaf.of_string (fst data_tuple) |> Jsonaf.jsonaf_of_t)
      , Array.map response ~f:(fun data_tuple ->
          Jsonaf.of_string (Float.to_string (snd data_tuple))
          |> Jsonaf.jsonaf_of_t) )
    in
    let dates = `Array (dates |> Array.to_list) in
    let prices = `Array (prices |> Array.to_list) in
    let response =
      `Array [ dates; prices ] |> Jsonaf.jsonaf_of_t |> Jsonaf.to_string
    in
    Server.respond_string response
  | _ -> Server.respond_string ~status:`Not_found "Route not found"
;;

let start_server port () =
  Stdlib.Printf.eprintf "Listening for HTTP on\n   port %d\n" port;
  Stdlib.Printf.eprintf
    "Try 'curl\n   http://localhost:%d/test?hello=xyz'\n%!"
    port;
  let%bind _server =
    Server.create
      ~on_handler_error:`Raise
      (Async.Tcp.Where_to_listen.of_port port)
      handler
  in
  Crypto_interface.init crypto_table;
  Deferred.never ()
;;

let () =
  let module Command = Async_command in
  Command.async_spec
    ~summary:"Start a hello world Async server"
    Command.Spec.(
      empty
      +> flag
           "-p"
           (optional_with_default 8080 int)
           ~doc:"int Source port to listen on")
    start_server
  |> Command_unix.run
;;
