(* Students are still given an interface file, but it will be ignored.

   To be exact: the .mli files submitted by the student are always ignored,
   but usually the tests just check against the exact same interface
   (in tests/assignment/assignment.mli). *)

module type Stack = sig
  type 'a t

  val empty : 'a t
  val push : 'a -> 'a t -> 'a t
  val pop : 'a t -> ('a * 'a t) option
end

module type Queue = sig
  type 'a t

  val empty : 'a t
  val enqueue : 'a -> 'a t -> 'a t
  val dequeue : 'a t -> ('a * 'a t) option
end

module ListStack : Stack with type 'a t = 'a list

module MakeFunctionalQueue : functor (S : Stack) ->
  Queue with type 'a t = 'a S.t * 'a S.t
