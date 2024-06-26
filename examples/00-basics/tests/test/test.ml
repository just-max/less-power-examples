open OUnit2
open OUnitTest
open Test_lib

(* This file represents the typical setup for testing simple assignments.
   Properties are defined, which compare the student submission against
   the sample solution. Inputs are generated and shrunk using QCheck.
   The resulting tests are run using OUnit.
*)


(* Properties: First, we specify properties that compare the student submission
   to the sample solution, and provide an error message with a side-by-side
   comparison if they differ. *)

(* Property for [Define three points] *)
let p123_differ_prop (p1, p2, p3) =
  if List.length (List.sort_uniq compare [p1; p2; p3]) <> 3 then
    (* we prefer to explicitly fail the test, as to show a more detailed error message *)
    QCheck_util.fail_report_notrace
      "All three vectors (p1, p2, and p3) should be different.";
  true

(* Property for [string_of_vector3] *)
let string_of_vector3_prop v =
  QCheck_util.assert_equal' ~printer:QCheck2.Print.string
    (fun () -> Solution.string_of_vector3 v)
    (fun () -> Assignment.string_of_vector3 v)
  |> QCheck_util.report_result

let eq_vector3 (a, b, c) (d, e, f) =
  cmp_float a d && cmp_float b e && cmp_float c f

(* Property for [vector3_add] *)
let vector3_add_prop (v1, v2) =
  QCheck_util.assert_equal'
    ~printer:Solution.string_of_vector3
    ~eq:(QCheck_util.lift_eq eq_vector3)
    (fun () -> Solution.vector3_add v1 v2)
    (fun () -> Assignment.vector3_add v1 v2)
  |> QCheck_util.report_result

let eq_one_of eq_one xs x = List.exists (eq_one x) xs
let print_one_of print_one xs =
  match List.rev xs with
  | [] -> "nothing"
  | [x] -> print_one x
  | last :: xs ->
      String.concat ", " (List.rev_map print_one xs) ^ ", or " ^ print_one last

let vector3_len_sq (x, y, z) = x *. x +. y *. y +. z *. z

let vector3_maximums v1 v2 =
  if cmp_float (vector3_len_sq v1) (vector3_len_sq v2) then [v1; v2]
  else [Solution.vector3_max v1 v2]

(* Property for [vector3_max]. Here, we need to account for the case when [v1]
   and [v2] have the same length, or students might be perplexed. We use
   [assert_equal] to check for membership in a list to show how that function
   can be used; alternatively, we could have just filtered these cases with
   [QCheck2.assume]. *)
let vector3_max_prop (v1, v2) =
  QCheck_util.assert_equal
    ~printers:(print_one_of Solution.string_of_vector3, Solution.string_of_vector3)
    ~eq:(QCheck_util.lift_eq @@ eq_one_of eq_vector3)
    (fun () -> vector3_maximums v1 v2)
    (fun () -> Assignment.vector3_max v1 v2)
  |> QCheck_util.report_result

(* Property for [combine] *)
let combine_prop (v1, v2, v3) =
  QCheck_util.assert_equal
    ~printers:(print_one_of QCheck2.Print.string, QCheck2.Print.string)
    ~eq:(QCheck_util.lift_eq @@ eq_one_of (=))
    (fun () ->
        vector3_maximums v2 v3
        |> List.map Solution.(fun v23 -> vector3_add v1 v23 |> string_of_vector3))
    (fun () -> Assignment.combine v1 v2 v3)
  |> QCheck_util.report_result


(* Generators: Next, we need to specify how to generate inputs to student
   functions. It is generally a good idea to use 'small' versions of generators,
   or otherwise pay attention to the sizes of the inputs, as otherwise
   collisions may take longer to occur and student code will take longer to run.
   Here, we get lucky though and don't need to worry about input sizes. *)

let vector3_gen = QCheck2.Gen.(triple float float float)
let vector3_pair_gen = QCheck2.Gen.(pair vector3_gen vector3_gen)
let vector3_triple_gen = QCheck2.Gen.(triple vector3_gen vector3_gen vector3_gen)

let vector3_print = Solution.string_of_vector3
let vector3_pair_print = QCheck2.Print.pair vector3_print vector3_print
let vector3_triple_print = QCheck2.Print.triple vector3_print vector3_print vector3_print


(* Tests: Now, we can create tests that check the
   student code against the properties. *)

(* some tests only check a property against fixed input... *)
let p123_differ_test =
  QCheck_util.make_test_single ~name:"p1_p2_p3"
    ~print:vector3_triple_print
    Assignment.(p1, p2, p3) p123_differ_prop

(* ...while others use randomly generated inputs *)
let string_of_vector3_test =
  QCheck2.Test.make ~name:"string_of_vector3" ~count:1000
    ~print:vector3_print
    vector3_gen string_of_vector3_prop

let vector3_add_test =
  QCheck2.Test.make ~name:"vector3_add" ~count:1000
    ~print:vector3_pair_print
    vector3_pair_gen vector3_add_prop

let vector3_max_test =
  QCheck2.Test.make ~name:"vector3_max" ~count:1000
    ~print:vector3_pair_print
    vector3_pair_gen vector3_max_prop

let vector3_combine_test =
  QCheck2.Test.make ~name:"combine" ~count:1000
    ~print:vector3_triple_print
    vector3_triple_gen combine_prop

(* We check the value of Config.show_hidden to decide whether
   the output of some tests should be hidden. Config.show_hidden becomes true
   when running tests locally, or after the deadline has passed. *)
let hide_test' ?visibility t =
  if Config.show_hidden then t else OUnit_util.hide_test ?visibility t

(* Finally, create a test tree, and run it. *)
let tests =
  let open OUnit_util in
  "vector3" >::: [
    p123_differ_test |> of_qcheck ;
    string_of_vector3_test |> of_qcheck ;
    vector3_add_test |> of_qcheck ;

    (* we can mark some tests as hidden: with 'PassFail', only a pass/fail
       status will be shown to the student *)
    vector3_max_test |> of_qcheck |> hide_test' ~visibility:PassFail ;

    (* with 'None', the test won't be run at all *)
    vector3_combine_test |> of_qcheck |> hide_test' ~visibility:None ;
  ]

(* We only actually run tests when arguments are passed, to be able to check
   for top-level loops in student code by passing no arguments. *)
let _ =
  if Array.length Sys.argv > 1 then
    run_test_tt_main ~exit:(Fun.const ()) tests
