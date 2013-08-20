(* red-black tree *)
module type ORDERED = sig
    type t 
    val compare : t -> t -> int
end

module type ITF = sig
    type t (* binomial tree *)
    type elem
    type color
    val empty : t

    val mem: t -> elem -> bool
    val insert : t -> elem -> t
    val balance : color -> elem -> t -> t -> t
    val depth : t -> int
end

module RBT (M:ORDERED) : (ITF with type elem = M.t) = struct
    type elem = M.t
    type color = Red | Black
    type t = Leaf | Node of color * elem * t * t
    
    let rec depth t = match t with
        Leaf -> 0
        |Node(_, _, l, r) -> 1 + (max (depth l) (depth r))

    let rec mem t e = match t with
        Leaf -> false
        |Node(_, x, l, r) -> if M.compare e x < 0 then mem l e
            else if M.compare e x > 0 then mem r e
            else true
    
    let empty = Leaf

    let balance color e l r = match color,e,l,r with
        Black, x, Node(Red, y, Node(Red, z, a, b), c), d|
        Black, x, Node(Red, z, a, Node(Red, y, b, c)), d|
        Black, z, a, Node(Red, x, Node(Red, y, b, c), d)|
        Black, z, a, Node(Red, y, b, Node(Red, x, c, d)) -> 
            Node (Red, y, Node(Black, z, a, b), Node(Black, x, c, d))
        |_, _, _, _ -> Node(color, e, l, r)

    let insert t e = 
        let rec ins t e = match t with
            Leaf -> Node (Red, e, Leaf, Leaf) (* always color as red *)
            |Node (color, x, l, r) -> if M.compare e x < 0 then balance color x (ins l e) r (* balance propagate up *)
            else if M.compare e x > 0 then balance color x l (ins r e)
            else t
        in let (Node(_, x, l, r)) = ins t e in (* guaranteed non-leaf *)
        Node(Black, x, l, r) (* force root to be black *)
end


module MyInt = struct
    type t = int
    let compare = Int.compare
end

module IntRBT = RBT (MyInt)
