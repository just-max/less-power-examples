open Test_lib
open Test_lib.OUnit_util

let conditional_test_hidden ~hidden_message msg =
  conditional_test1
    (hidden_message ^ if Config.show_hidden then "\n\n" ^ msg else "")

let conditional_test_ud_typ what message =
  conditional_test_hidden message
    ~hidden_message:(Printf.sprintf "%s was %s" what Scaffold.ud_typ_message)

(** A real programming exercise would define real tests for each value.
    To showcase the partial signature checking here, we showcase how to write
    tests for one value (ListStack.push) but let all other tests pass as soon
    as the definition is type-correct. *)

let push_prop (x, xs) =
  QCheck_util.assert_equal'
    (fun () -> Solution.ListStack.push x xs)
    (fun () -> Scaffold.ListStack.push x xs)
    ~printer:QCheck2.Print.(list int)
  |> QCheck_util.report_result

let push_test =
  QCheck2.Test.make
    ~name:"ListStack.push" ~print:QCheck2.Print.(pair int (list int))
    QCheck2.Gen.(pair small_nat (small_list small_nat)) push_prop

(* all other tests just pass *)
let true_test = OUnit2.test_case (Fun.const ())

(* conditionally run tests based on whether the corresponding probe passed *)
let tests =
  let open OUnitTest in
  let open OUnit_util in
  TestList [
    "core" >::: [

      conditional_test_ud_typ "ListStack" LIST_MOD_MSG LIST_MOD_OK
      ("ListStack" >::: [

        conditional_test_ud_typ "ListStack.t" LIST_T_MSG LIST_T_OK
        ("t" >::: [ true_test; ]);

        conditional_test_ud_typ "ListStack.empty" LIST_EMPTY_MSG LIST_EMPTY_OK
        ("empty" >::: [ true_test; ]);

        conditional_test_ud_typ "ListStack.push" LIST_PUSH_MSG LIST_PUSH_OK
        ("push" >::: [ push_test |> OUnit_util.of_qcheck; ]);

        conditional_test_ud_typ "ListStack.pop" LIST_POP_MSG LIST_POP_OK
        ("pop" >::: [ true_test; ]);
      ]);

      conditional_test_ud_typ "MakeFunctionalQueue" FQUEUE_FUNCT_MSG FQUEUE_FUNCT_OK
      ("MakeFunctionalQueue" >::: [

        conditional_test_ud_typ "MakeFunctionalQueue(_).t" FQUEUE_T_MSG FQUEUE_T_OK
        ("t" >::: [ true_test; ]);

        conditional_test_ud_typ "MakeFunctionalQueue(_).empty" FQUEUE_EMPTY_MSG FQUEUE_EMPTY_OK
        ("empty" >::: [ true_test; ]);

        conditional_test_ud_typ "MakeFunctionalQueue(_).enqueue" FQUEUE_ENQUEUE_MSG FQUEUE_ENQUEUE_OK
        ("enqueue" >::: [ true_test; ]);

        conditional_test_ud_typ "MakeFunctionalQueue(_).dequeue" FQUEUE_DEQUEUE_MSG FQUEUE_DEQUEUE_OK
        ("dequeue" >::: [ true_test; ]);
      ]);
    ]
  ]

let skip_not_ok ok = if not ok then Some Scaffold.ud_typ_message else None
let skip_not_ok_reason ok _ _ = skip_not_ok ok

(* for automatic grading, use the Grading module *)
let grading =
  let open Grading in
  group "root" ~max_points:{ min = 0; max = 15 }
    [
      group "ListStack" ?skip:(skip_not_ok LIST_MOD_OK) ~max_points:{ min = 0; max = 6 }
        [
          points_p "type t" 1 "*:core:*:ListStack:*:t:"
            ~reason:(skip_not_ok_reason LIST_T_OK);
          points_p "empty" 1 "*:core:*:ListStack:*:empty:"
            ~reason:(skip_not_ok_reason LIST_EMPTY_OK);
          points_p "push" 2 "*:core:*:ListStack:*:push:"
            ~reason:(skip_not_ok_reason LIST_PUSH_OK);
          points_p "pop" 2 "*:core:*:ListStack:*:pop:"
            ~reason:(skip_not_ok_reason LIST_POP_OK);
        ];
      group "MakeFunctionalQueue" ?skip:(skip_not_ok FQUEUE_FUNCT_OK) ~max_points:{ min = 0; max = 9 }
        [
          points_p "type t" 2 "*:core:*:MakeFunctionalQueue:*:t:"
            ~reason:(skip_not_ok_reason FQUEUE_T_OK);
          points_p "empty" 1 "*:core:*:MakeFunctionalQueue:*:empty:"
            ~reason:(skip_not_ok_reason FQUEUE_EMPTY_OK);
          points_p "enqueue" 2 "*:core:*:MakeFunctionalQueue:*:enqueue:"
            ~reason:(skip_not_ok_reason FQUEUE_ENQUEUE_OK);
          points_p "dequeue" 4 "*:core:*:MakeFunctionalQueue:*:dequeue:"
            ~reason:(skip_not_ok_reason FQUEUE_DEQUEUE_OK);
        ];
    ]

(* We only actually run tests when arguments are passed, to be able to check
   for top-level loops in student code by passing no arguments. *)
let _ =
  if Array.length Sys.argv > 1 then (
    OUnit2.run_test_tt_main ~exit:(Fun.const ()) tests;
    Grading.prettify_results ~grading Sys.argv.(2))
