module type ORDERED = sig
    type t 
    val compare : t -> t -> int
end

module type ITF = sig
    type t
    type elem
    val empty : t
    
    val merge : t -> t -> t
    val insert : t -> elem -> t
    val findMin : t -> elem
    val deleteMin : t -> t
end

module Heap (M:ORDERED) : (ITF with type elem = M.t) = struct
    type elem = M.t
    type t = Leaf | Node of elem * int * t * t
    
    let empty = Leaf
    
    let rank h = match h with
        Leaf -> 0
        |Node (_, r, _, _) -> r

    let makeH x l r = let rl = rank l and rr = rank r in
        if rl > rr then Node (x, 1 + rr, l, r)
        else Node (x, 1 + rl, r, l)

    let rec merge h1 h2 = match h1, h2 with
        Leaf, _ -> h2
        |_, Leaf -> h1
        |Node (x, i, l1, r1), Node (y, j, l2, r2) -> 
            if M.compare x y < 0 then makeH x l1 (merge r1 h2)
            else makeH y l2 (merge h1 r2)
    
    let insert h e = merge h (Node (e, 1, Leaf, Leaf))

    let findMin h = match h with
        Leaf -> failwith "empty heap"
        |Node (x, _, _, _) -> x

    let deleteMin h = match h with
        Leaf -> failwith "empty heap"
        |Node (_, _, l, r) -> merge l r
end


module MyInt = struct
    type t = int
    let compare = Int.compare
end

module IntHeap = Heap (MyInt)
