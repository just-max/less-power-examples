
let skip_not_ok ok = if not ok then Some Scaffold.ud_typ_message else None
let skip_not_ok_reason ok _ _ = skip_not_ok ok

(* for automatic grading, use the Grading module *)
let grading =
  let open Test_lib.Grading in
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

let _ =
  let grading_junit_file, output_junit_files = match Array.to_list Sys.argv with
    | _ :: arg1 :: args -> arg1, args
    | _ -> failwith "usage: grade test-results/grading.xml test-results/output.xml"
  in
  Test_lib.Grading.(process_files output_junit_files
    ~grade:(grading_options ~grading_to:grading_junit_file grading))
