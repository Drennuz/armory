module Queue = struct
    type 'a t = 'a list * 'a list
    
    let empty = [], []

    let checkq q = match q with
    [], r -> List.rev r, []
    |_, _ -> q
    
    let enqueue q e = let (f,r) = q in checkq (f, e::r)

    let dequeue q = match q with
        [], _ -> failwith "empty queue"
        |h::t, r -> checkq(t,r)

    let peek q = match q with
        [], _ -> failwith "empty queue"
        |h::t, r -> h
end
