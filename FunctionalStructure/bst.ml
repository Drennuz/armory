module type ORDERED = sig
    type t 
    val compare : t -> t -> int
end

module type BSTI = sig
    type t
    type elem
    val empty : t

    val mem : t -> elem -> bool
    val insert : t -> elem -> t
    val depth : t -> int
end

module BST (M:ORDERED) : (BSTI with type elem = M.t) = struct
    type elem = M.t
    type t = Leaf | Node of elem * t * t
    
    let empty = Leaf
    
    let rec depth t = match t with
        Leaf -> 0
        |Node(_, l, r) -> 1 + (max (depth l) (depth r))

    let rec mem t e = match t with  
        Leaf -> false
        |Node (x, l, r) -> if M.compare e x < 0 then mem l e
            else if M.compare e x > 0 then mem r e
            else true

    let rec insert t e = match t with
        Leaf -> Node (e, Leaf, Leaf)
        |Node (x, l, r) -> if M.compare e x < 0 then Node (x, insert l e, r)
            else if M.compare e x > 0 then Node (x, l, insert r e)
            else t
end


module MyInt = struct
    type t = int
    let compare = Int.compare

end

module IntBST = BST (MyInt)
