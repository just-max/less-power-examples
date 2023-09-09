# Example 01: Partially (Type)-Correct Submissions

This exercise showcases a strategy for grading submissions that would otherwise not compile, because some values, types, or modules are left undefined by the student, or are defined but have the wrong type.

The implementation of partial signature checks requires Cppo, a C-like preprocessor. Install it with `opam install cppo`. The docker image already contains Cppo.

## Problem Statement

The problem statement for this exercise is as follows.

### Stack It Up, Queue It Out

Stacks and queues are two essential data structures in any programming language! Let's take a look at how to implement them in OCaml.

#### Part 1: Stacks

A stack is a data structure supporting a push and a pop operation. We will use the following signature to model purely functional stacks:

```ocaml
module type Stack = sig
  (** the type of stacks *)
  type 'a t

  (** an empty stack *)
  val empty : 'a t

  (** add value to the top of the stack,
      returning the new stack *)
  val push : 'a -> 'a t -> 'a t

  (** remove a value from the stop of the stack,
      returning the removed value and the remaining stack;
      if the stack was empty, return [None] *)
  val pop : 'a t -> ('a * 'a t) option
end
```

Implement the module `ListStack`, conforming to the signature `Stack`, where the type `'a t` is `'a list`. The empty list represents the empty stack, and the push and pop operations add or remove from the head of the list.

#### Part 2: Queues

A queue is a data structure that supports an enqueueing and dequeueing elements. We will use the following signature to model purely functional queues:

```ocaml
module type Queue = sig
  (** the type of queues *)
  type 'a t

  (** an empty queue *)
  val empty : 'a t

  (** add value to the end of the queue,
      returning the new queue *)
  val enqueue : 'a -> 'a t -> 'a t

  (** remove a value from the front of the queue,
      returning the removed value and the remaining queue;
      if the queue was empty, return [None] *)
  val dequeue : 'a t -> ('a * 'a t) option
end
```

Recall that a queue can be implemented in a purely functional manner by using two stacks. Implement the functor `MakeFunctionalQueue`, which takes a `Stack` as an argument, and returns a `Queue`. The type `'a t` in the returned module must be `('a Stack.t * 'a Stack.t)`, where `Stack` is the argument to the functor.

Use the standard two-stack implementation of a queue. The enqueue operation must always push to the second stack. The dequeue operation must always pop from the first stack, if it is not empty; otherwise, it must reverse the second stack and use it as the new first stack.
