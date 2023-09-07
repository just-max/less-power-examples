#!/usr/bin/env bash

set -e

opam exec -- dune build --root tests/ --force runner/

opam exec -- dune exec --root tests/ --no-build -- runner/runner.exe \
  --exercise-start "$(date -d 'TZ="Europe/Berlin" 2023-09-01 00:00' +%s)" \
  --exercise-end "$(date -d 'TZ="Europe/Berlin" 2023-09-30 00:00' +%s)" \
  "$@" # pass '-s' (safe) flag from CI runner
