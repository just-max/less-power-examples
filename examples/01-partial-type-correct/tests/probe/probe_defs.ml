(** Each module in ALL_CAPS represents one check against the submission.
    Note: you should never [open Assignment], since the submission could
    poison the module namespace. *)

(** Assignment.ListStack exists and is not a functor *)
module LIST_MOD = struct
  module _ : sig end = Assignment.ListStack
end

(** ListStack.t exists and is the correct type *)
module LIST_T = struct
  module _ : sig
    type 'a t = 'a list
  end =
    Assignment.ListStack
end

(** ListStack.empty exists and has the correct type *)
module LIST_EMPTY = struct
  module _ : sig
    val empty : 'a list
  end =
    Assignment.ListStack
end

(** ListStack.push exists and has the correct type *)
module LIST_PUSH = struct
  module _ : sig
    val push : 'a -> 'a list -> 'a list
  end =
    Assignment.ListStack
end

(** ListStack.pop exists and has the correct type *)
module LIST_POP = struct
  module _ : sig
    val pop : 'a list -> ('a * 'a list) option
  end =
    Assignment.ListStack
end

(** MakeFunctionalQueue exists, and is a functor taking a Stack and returning a module *)
module FQUEUE_FUNCT = struct
  module _ : functor (_ : Probe_common.Stack) -> sig end =
    Assignment.MakeFunctionalQueue
end

(** Output of MakeFunctionalQueue has correct type t *)
module FQUEUE_T = struct
  module _ : functor (S : Probe_common.Stack) -> sig
    type 'a t = 'a S.t * 'a S.t
  end =
    Assignment.MakeFunctionalQueue
end

(** Output of MakeFunctionalQueue has correct type for empty *)
module FQUEUE_EMPTY = struct
  module _ : functor (S : Probe_common.Stack) -> sig
    val empty : 'a S.t * 'a S.t
  end =
    Assignment.MakeFunctionalQueue
end

(** Output of MakeFunctionalQueue has correct type for enqueue *)
module FQUEUE_ENQUEUE = struct
  module _ : functor (S : Probe_common.Stack) -> sig
    val enqueue : 'a -> 'a S.t * 'a S.t -> 'a S.t * 'a S.t
  end =
    Assignment.MakeFunctionalQueue
end

(** Output of MakeFunctionalQueue has correct type for dequeue *)
module FQUEUE_DEQUEUE = struct
  module _ : functor (S : Probe_common.Stack) -> sig
    val dequeue : 'a S.t * 'a S.t -> ('a * ('a S.t * 'a S.t)) option
  end =
    Assignment.MakeFunctionalQueue
end
