module type ORDERED = sig
    type t 
    val compare : t -> t -> int
end

module type ITF = sig
    type t
    type elem
    type heap
    val empty : heap
    val link : t -> t -> t
    val insert : elem -> heap -> heap
    val size : heap -> int
    val findMin : heap -> elem
    val deleteMin : heap -> heap
end

module BHeap (M:ORDERED) : (ITF with type elem = M.t) = struct
    type elem = M.t
    type t = Node of int * elem * t list (* decreasing rank order *)
    

    let link t1 t2 = match t1, t2 with
    Node (r, x1, c1), Node(_, x2, c2) -> if M.compare x1 x2 < 0 then Node (1+r, x1, t2::c1) else Node(1+r, x2, t1::c2)

    type heap = t list (*increasing rank order *)
    
    let empty:heap = []
    
    let size h = List.length h

    let rank t = match t with
        Node(r, _, _) -> r
    
    let root (Node(r,x,c)) = x 

    let rec insTree t l = match l with
        [] -> [t]
        |h::t' -> if rank t < rank h then t :: l else insTree (link t h) t'

    let insert x ts = insTree (Node(0, x, [])) ts

    let rec merge h1 h2 = match h1, h2 with
        _, [] -> h1
        |[], _ -> h2
        |t1::ts1, t2::ts2 -> if rank t1 < rank t2 then t1 :: (merge ts1 h2)
        else if rank t1 > rank t2 then t2 :: (merge ts2 h1)
        else insTree (link t1 t2) (merge ts1 ts2)
    
    let rec removeMinTree h = match h with
        [t] -> t, []
        |t :: ts -> let t', ts' = removeMinTree ts in
        if M.compare (root t) (root t') < 0 then t, ts else t', t::ts'

    let findMin t = 
        let t', _ = removeMinTree t in root t'

    let deleteMin ts = 
        let (Node (_, x, ts1), ts2) = removeMinTree ts in 
        merge (List.rev ts1) ts2
end


module MyInt = struct
    type t = int
    let compare = Int.compare
end

module IntBHeap = BHeap (MyInt)
