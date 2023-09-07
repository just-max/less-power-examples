open OUnit2
open OUnitTest
open Test_lib

(* This file represents the typical setup for testing simple assignments.
   Properties are defined, which compare the student submission against
   the sample solution. Inputs are generated and shrunk using QCheck.
   The resulting tests are run using OUnit.
   
   The problem statement for this exercise is:

   What's the point?
   =================

    Using what you've learned about tuple types, implement functionality for
    computing with three-dimensional vectors.

    1. [Define three points]
      The points p1, p2 and p3 should all be different, but their exact values
      don't matter. Use them, along with other points, to test your functions.
    2. [string_of_vector3]
      Implement a function `string_of_vector3 : vector3 -> string` to convert
      a vector into a human-readable representation.
      For example, the string for the zero vector should be: (0.,0.,0.).
      (Hint: use string_of_float to convert components.)
    3. [vector3_add]
      Write a function `vector3_add : vector3 -> vector3 -> vector3` that
      adds two vectors component-wise.
    4. [vector3_max]
      Write a function `vector3_max : vector3 -> vector3 -> vector3` that
      returns the larger argument vector (the vector with the greater magnitude).
    5. [combine]
      Write a function `combine : vector3 -> vector3 -> vector3 -> string` that
      adds its first argument to the larger of the other two arguments
      and returns the result as a string.
*)


(* Properties: First, we specify properties that compare the student submission
   to the sample solution, and provide an error message with a side-by-side
   comparison if they differ. *)

(* Property for [Define three points] *)
let p123_differ_prop (p1, p2, p3) =
  List.length (List.sort_uniq compare [p1; p2; p3]) = 3

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


(* Tests: Now, we can create tests that check the
   student code against the properties. *)

(* TODO: move to lib *)
let make_test_single ?name ?print x prop =
  QCheck2.Test.make (QCheck2.Gen.pure x) prop ~count:1 ~max_gen:1 ?name ?print

let p123_differ_test =
  make_test_single ~name:"p1, p2, p3" Assignment.(p1, p2, p3) p123_differ_prop

let string_of_vector3_test =
  QCheck2.Test.make ~name:"string_of_vector3" ~count:1000
    ~print:Solution.string_of_vector3
    vector3_gen string_of_vector3_prop

let vector3_add_test =
  QCheck2.Test.make ~name:"vector3_add" ~count:1000
    ~print:(QCheck2.Print.pair Solution.string_of_vector3 Solution.string_of_vector3) (* TODO: printers *)
    vector3_pair_gen vector3_add_prop

let vector3_max_test =
  QCheck2.Test.make ~name:"vector3_max" ~count:1000
    ~print:(QCheck2.Print.pair Solution.string_of_vector3 Solution.string_of_vector3) (* TODO: printers *)
    vector3_pair_gen vector3_max_prop

let vector3_combine_test =
  QCheck2.Test.make ~name:"combine" ~count:1000
    ~print:(QCheck2.Print.triple Solution.string_of_vector3 Solution.string_of_vector3 Solution.string_of_vector3) (* TODO: printers *)
    vector3_triple_gen combine_prop

(* TODO: fixed tests, hidden tests *)

(* Finally, create a test tree, and run it. *)
let tests =
  let open OUnit_util in
  "vector3" >::: [
    p123_differ_test |> of_qcheck ;
    string_of_vector3_test |> of_qcheck ;
    vector3_add_test |> of_qcheck ;
    vector3_max_test |> of_qcheck ;
    vector3_combine_test |> of_qcheck ;
  ]

(* We only actually run tests when arguments are passed, to be able to check
   for top-level loops in student code by passing no arguments. *)
let _ =
  if Array.length Sys.argv > 1 then (
    run_test_tt_main ~exit:(Fun.const ()) tests;
    Grading.prettify_results Sys.argv.(2))
