let _ =
  let output_junit_files = Array.to_list Sys.argv |> List.tl in
  Test_lib.Grading.process_files output_junit_files
