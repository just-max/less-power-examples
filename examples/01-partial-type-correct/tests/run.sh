#!/usr/bin/env bash

set -e

opam exec -- dune build --root tests/ --force runner/

# use "$@" to pass '--safe', '--exercise-start' and '--exercise-end' flags from CI runner
opam exec -- dune exec --root tests/ --no-build -- runner/runner.exe "$@"

# exercise start/end can be hard-coded instead:
# --exercise-start "$(date -d 'TZ="Europe/Berlin" 2023-09-01 00:00' +%s)"
# --exercise-end "$(date -d 'TZ="Europe/Berlin" 2023-09-30 00:00' +%s)"
