open! Core
open! Owl_base
open! Crypto_src
open! Crypto_src.Types
open! Crypto_src.Simple_model
module Gp = Gnuplot

val init : (Crypto.t, ArimaModel.t) Base.Hashtbl.t -> unit

val get_coin_data
  :  (Crypto.t, ArimaModel.t) Base.Hashtbl.t
  -> string
  -> (string * float) list

val predict_all_prices
  :  (Crypto.t, ArimaModel.t) Base.Hashtbl.t
  -> string
  -> string
  -> (string * float) array