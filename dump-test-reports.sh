#!/usr/bin/env bash

xmlstarlet select --text --template \
  --output '----------------------------------------' --nl \
  --match '/testsuites/testsuite/testcase' \
    --output '[' --value-of '@name' --output ']' --nl \
    --match './error|./failure|./skipped' \
      --value-of '.' --nl \
    --break \
    --output '----------------------------------------' --nl \
    test-reports/results.xml
