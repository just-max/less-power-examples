open Test_runner

let _ =
  let task cfg =
    Std_task.[
      std_setup;
      std_check;
      std_probe;
      std_build;
      std_test;
      std_process_results ~grading:true;
    ]
    |> List.map (fun t -> t cfg) |> Task.of_list |> Task.group ~label:"runner"
  in
  Entry_point.run_task_main task
