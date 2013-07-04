(* implement balanced red black tree *)
(* rb tree: balanced binary tree 
    each tree has same # black nodes
    no two adjacent red nodes
*)

type color = Red | Black

type 'a rbtree = Leaf | Node of color * 'a * 'a rbtree * 'a rbtree

let rec mem x = function
    Leaf -> false
    |Node (_, a, t1, t2) -> if a = x then true 
                       else if x < a then mem x t1
                       else mem x t2

(* only 4 cases with red parent *)

let balance = function
    Black, z, Node(Red, y, Node(Red, x, a,b),c),d
    |Black, z, Node(Red, x, a, Node(Red, y, b, c)),d
    |Black, x, a, Node(Red, z, Node(Red, y, b, c), d)
    |Black, x, a, Node(Red, y, b, Node(Red, z, c, d)) -> Node(Red, y, Node(Black, x, a,b), Node(Black,z,c,d))
    |a,b,c,d -> Node(a,b,c,d)

let insert x s = 
    let rec ins = function
    Leaf -> Node(Red, x, Leaf, Leaf)
    |Node(color, y, a,b) as s -> 
        if x < y then balance (color, y, ins a, b)
        else if x > y then balance(color, y, a, ins b)
        else s in
    match ins s with
    Node(_, x, a, b) -> Node(Black, x, a, b)
    |Leaf -> raise (Failure "returning leaf")

let empty = Leaf

let rec set_of_list l = match l with
    [] -> Leaf
    |h::t -> insert h (set_of_list t)
