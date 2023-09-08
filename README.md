# Less Power: Examples

Examples for the [Less Power](https://github.com/just-max/less-power) programming exercise framework for OCaml. Each example showcases how a program exercise can be set up for automatic testing with LP. These examples are intended to showcase the Less Power project, but may also be adapted to create new programming exercises.

For running real programming courses, programming exercises derived from the examples in this repository are best run with [Artemis](https://github.com/ls1intum/Artemis). Artemis is an interactive learning platform that handles student participation and provides CI-based automated testing.

## Layout

Each exercise is contained in a subdirectory of `examples/`. Each programming exercise contains three subdirectories: `template/`, `solution/`, and `tests/`.

- Upon starting an exercise, the student should be given a copy of `template/`. It contains the minimal project setup for the student to start working on the exercise.

- The `solution/` is both a sample solution that can be shown to the student after the deadline, but also an important part of automated tests. Most automated tests compare against the sample solution to check for correctness.

- The tests themselves are contained in `tests/`.

Typically, each would live in a separate repository.

## Running the examples

The examples depend on the Less Power framework being installed. LP is currently fixed to OCaml 5.0.0. Hence, from an OCaml 5.0.0. switch, LP can be installed using opam:

```bash
opam pin add less-power https://github.com/just-max/less-power.git#main
```

For trying out the examples and developing new exercises, the example exercises can be run locally:

0. Change into one of the `examples/nn-exercise/` directories.

1. The test framework expects to find `assignment/`, `solution/`, and `tests/` directories (but does not directly use the `template/` directory). Create a symlink called `assignment/` to point to the "submission" being tested. For example, to run the tests against the template:

    `ln --symbolic --no-target-directory --force template/ assignment`

2. Start the testing process by running `tests/run.sh`.

3. The results are printed to standard error, and saved to `test-reports/results.xml`. With `xmlstarlet` installed (debian: `apt install xmlstarlet`), the script `dump-test-reports.sh` pretty-prints the test results similar to how a student would see them.

During real courses, automated programming exercises are generally run with the help of a continuous integration service. With Artemis, the directory layout matches the one expected by the framework.

# License

The examples contained within this repository are licensed under the BSD Zero Clause License, which should make it easy to adapt and reuse them as you see fit.
