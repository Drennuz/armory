
module type ORDERED = sig
    type t 
    val compare : t -> t -> int
end

module type ITF = sig
    type t (* binomial tree *)
    type elem
    type heap
    val link : t -> t -> t
end

module BNT (M:ORDERED) : (ITF with type elem = M.t) = struct
    type elem = M.t
    type t = Node of int * elem * t list (* list in decreasing rank order; elements in heap order *)
    type heap = t list (* increasing order of rank *)

    (* link trees of equal rank *)
    let link t1 t2 = let (Node (r, x1, c1), Node (_, x2, c2)) = (t1,t2) in
        if M.compare x1 x2 < 0 then Node (1+r, x1, t2::c1)
        else Node (1+r, x2, t1::c2)
    
    let rank t = let (Node (r, _, _)) = t in r

    let rec insTree t l = match l with
        [] -> [t]
        |t1::s -> if rank t < rank t1 then t :: l
            else if rank t = rank t1 then (link t t1) :: s
            else t1 :: (insTree t s)
end


module MyInt = struct
    type t = int
    let compare = Int.compare
end

module IntHeap = BNT (MyInt)
