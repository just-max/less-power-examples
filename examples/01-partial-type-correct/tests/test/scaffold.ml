let ud_typ_message = "not defined or does not match the expected type or signature"
let fail_ud_typ _ = failwith ud_typ_message

module ListStack = struct
  type 'a t = 'a list

  let empty =
    #ifdef LIST_EMPTY_PROBE
      Assignment.ListStack.empty
    #else
      []
    #endif

  let push =
    #ifdef LIST_PUSH_PROBE
      Assignment.ListStack.push
    #else
      fail_ud_typ
    #endif

  let pop =
    #ifdef LIST_POP_PROBE
      Assignment.ListStack.pop
    #else
      fail_ud_typ
    #endif
end

module MakeFunctionalQueue = functor (S : Solution.Stack) -> struct

  #ifdef FQUEUE_FUNCT_PROBE
    type 'a t = ('a S.t * 'a S.t)

    module AssignmentFunctionalQueue = Assignment.MakeFunctionalQueue (S)

    let empty =
      #ifdef FQUEUE_EMPTY_PROBE
        AssignmentFunctionalQueue.empty
      #else
        (S.empty, S.empty)
      #endif

    let enqueue =
      #ifdef FQUEUE_ENQUEUE_PROBE
        AssignmentFunctionalQueue.enqueue
      #else
        fail_ud_typ
      #endif

    let dequeue =
      #ifdef FQUEUE_DEQUEUE_PROBE
        AssignmentFunctionalQueue.dequeue
      #else
        fail_ud_typ
      #endif

  #else
    include Solution.MakeFunctionalQueue (S)
  #endif

end
