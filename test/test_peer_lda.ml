(** [ Test LDA on P2P parallel ]  *)

open Owl
open Types

(* load stopwords, load data, build dict, tokenisation *)
let s = Dataset.load_stopwords ()
let x = Dataset.load_nips_train_data s
let v = Owl_topic_utils.build_vocabulary x
(* only choose 30% data to train
let x = Stats.choose x (Array.length x / 3) *)
let d = Owl_topic_utils.tokenisation v x
let t = 100

let _ =
  Logger.info "#doc:%i #top:%i #voc:%i" (Array.length d) t (Hashtbl.length v);
  Peer_lda.init t v d;
  Peer_lda.start Sys.argv.(1)