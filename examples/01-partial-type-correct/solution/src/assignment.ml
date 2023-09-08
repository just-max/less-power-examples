(** sample solution *)

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

module ListStack = struct
  type 'a t = 'a list

  let empty = []
  let push = List.cons
  let pop = function [] -> None | x :: xs -> Some (x, xs)
end

module MakeFunctionalQueue =
functor
  (S : Stack)
  ->
  struct
    type 'a t = 'a S.t * 'a S.t

    let rev s =
      let rec helper acc xs =
        match S.pop xs with
        | None -> acc
        | Some (x, xs') -> helper (S.push x acc) xs'
      in
      helper S.empty s

    let empty = (S.empty, S.empty)
    let enqueue x (xs, ys) = (xs, S.push x ys)

    let dequeue (xs, ys) =
      match S.pop xs with
      | Some (x, xs') -> Some (x, (xs', ys))
      | None -> (
          match S.pop (rev ys) with
          | Some (y, ys') -> Some (y, (ys', S.empty))
          | None -> None)
  end
