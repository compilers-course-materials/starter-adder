open Compile
open Runner
open Printf
open OUnit2

let t name program expected = name>::test_run program name expected;;
let te name program expected_err = name>::test_err program name expected_err;;

let suite =
"suite">:::
 [t "forty_one" "41" "41";

  ]
;;


let () =
  run_test_tt_main suite
;;
