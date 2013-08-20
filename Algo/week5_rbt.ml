(* red-black tree; balanced binary search tree *)
(* RB invariants 
    > Root is always black
    > No two red in a row
    > same #blacks for each K-null path

    height < 2log(n+1)
*)

module type ORDERED = sig
    type t
    val compare : t -> t -> int
    val print : t -> unit
end

module type Rbtree_intf = sig
    type elem
    type color
    type tree
    val insert : elem -> tree -> tree
    val print : tree -> unit
end

module Rbtree (Elem : ORDERED) : (Rbtree_intf with type elem = Elem.t) = struct
    type elem = Elem.t
    type color = Red | Black
    type tree = Leaf | Node of color * elem * tree * tree
    
    let balance t = match t with
        Node (Black, w, Node (Red, z, zl, zr), Node (Red, y, Node (Red, x, xl, xr), yr)) 
        
            -> Node (Red, w, Node (Black, z, zl, zr), Node (Black, y, Node (Red, x, xl, xr), yr))

    let insert e t = 
end

module Myint = struct
    type t = int
    let compare a b = if a = b then 0 else if a < b then -1 else 1
    let print a = Printf.printf "%d\t" d
end

module IntRB = Rbtree(Myint)
