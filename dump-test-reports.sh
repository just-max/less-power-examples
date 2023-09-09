#!/usr/bin/env bash

line='--------------------------------------------------------------------------------'

xmlstarlet select --text --template \
  --output "$line" --nl \
  --match '/testsuites/testsuite/testcase[not(starts-with(@name, "points:"))]' \
    --output '[' --value-of '@name' --output ']' \
    --if 'boolean(./error|./failure|./skipped)' \
      --output '  ❌' --nl \
      --match './error|./failure|./skipped' \
        --value-of '.' --nl \
      --break \
    --else \
      --output '  ✅' --nl \
    --break \
    --output "$line" --nl \
    test-reports/*.xml
