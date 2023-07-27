open! Core
open! Crypto_src
open! Crypto_src.Types.Crypto

let () = Command.unix.run Visualize_graph.visualize_command
let _bitcoin_data = Fetch_data.get_data Bitcoin
let _ethereum_data = Fetch_data.get_data Ethereum
let _xrp_data = Fetch_data.get_data XRP

(* print_s [%message (ethereum_data : Types.Total_Data.t)] *)
