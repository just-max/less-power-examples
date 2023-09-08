(* unlike with regular exercises, the student will get feedback even from
   an empty submission, so we don't provide any template code *)



module type Stack = sig
   type 'a t

   val empty : 'a t
   val push : 'a -> 'a t -> 'a t
   val pop : 'a t -> ('a * 'a t) option
end

(* TODO: ListStack *)



module type Queue = sig
   type 'a t

   val empty : 'a t
   val enqueue : 'a -> 'a t -> 'a t
   val dequeue : 'a t -> ('a * 'a t) option
end

(* TODO: MakeFunctionalQueue *)
