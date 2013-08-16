(* Logic and Code *)

type bool_expr = 
    Var of string 
    |Not of bool_expr
    |And of bool_expr * bool_expr
    |Or of bool_expr * bool_expr

(* 40 truth table for 2 variables *)
let table2 a b exp =
    let rec aux a_bo b_bo e = match e with
    Var c -> if c = a then a_bo else if c = b then b_bo else failwith "invalid exp!"
    |Not e2 -> not (aux a_bo b_bo e2)
    |And (e2, e3) -> (aux a_bo b_bo e2) && (aux a_bo b_bo e3)
    |Or (e2, e3) -> (aux a_bo b_bo e2) || (aux a_bo b_bo e3) in
    let l1 = aux true true exp and
        l2 = aux true false exp and
        l3 = aux false true exp and
        l4 = aux false false exp in
    (true, true, l1) :: ((true, false, l2) :: ((false, true, l3) :: [(false, false, l4)]))

(* 41 truth table for multiple variables *)

(* l1 is list of list; l2 is [true;false] *)
let concat l1 l2 = 
    let rec aux res ll1 ll2 = match ll1, ll2 with
        [], _ -> res
        |h :: t, [] -> aux res t l2
        |h1 :: t1 as m, h2 :: t2 -> aux ((h2 :: h1) :: res) m t2
    in
    aux [] l1 l2

let rec permtf n = match n with
    1 -> [[true];[false]]
    |_ -> concat (permtf (n-1)) [true;false]

let table l exp = 
    let len = List.length l in
    let tflist = permtf len in
    let rec eval e var = match e with
        Var c -> List.assoc c var 
        |Not e2 -> not (eval e2 var)
        |And (e2, e3) -> (eval e2 var) && (eval e3 var)
        |Or (e2, e3) -> (eval e2 var) || (eval e3 var) in
    let rec aux res tfl = match tfl with
        [] -> res
        |h :: t -> (
            let assl = List.combine l h in
            aux ((assl, eval exp assl) :: res) t
        )
    in
    aux [] tflist

let vars = ["a";"b";"c"]
let a = Var "a" and b = Var "b" and c = Var "c"
let exp = Or(c, And(a,b))

(* 42 gray code *)

let rec gray n = 
    if n = 1 then ["0";"1"]
    else (
        let aux l = 
            let nl = l @ (List.rev l) in
            let len = List.length nl in
            let hl = len / 2 in
            List.mapi (fun n e -> if n < hl then "0" ^ e else "1" ^ e) nl
        in aux (gray (n-1))
    )

(* Binary tree *)

type 'a binary_tree = Leaf | Node of 'a * 'a binary_tree * 'a binary_tree

(* 44 complete balance tree *)

(* add to all with all left and right trees *)
let add_trees_with left right all = 
    let add_right_trees all l = 
    List.fold_left (fun a r -> Node ('x', l, r) :: a) all right in
    List.fold_left add_right_trees all left

let rec cbal n = 
    if n = 0 then [Leaf]
    else if n mod 2 = 1 then 
        let t = cbal (n/2) in add_trees_with t t []
    else 
        let t1 = cbal (n/2) in
        let t2 = cbal (n/2 - 1) in (* all possible trees from two sub trees *)
        add_trees_with t1 t2 (add_trees_with t2 t1 [])

(* 45 test symmetric *)

let rec is_mirror t1 t2 = match t1, t2 with
    Leaf, Leaf -> true
    |Node (e1, l1, r1), Node (e2, l2, r2) -> (is_mirror l1 r2) && (is_mirror l2 r1)
    |_ -> false
    
let is_symmetric t = match t with
    Leaf -> failwith "empty tree"
    |Node (_, l, r) -> is_mirror l r

(* 46 BST *)
let rec insert t e = match t with
    Leaf -> Node (e, Leaf, Leaf)
    |Node (root, l, r) -> if root = e then t 
        else if e < root then Node (root, insert l e, r)
        else Node (root, l, insert r e)

let construct l = List.fold_left insert Leaf l

(* 47 generate-and-test paradigm; symmetric balanced *)
let sym_cbal_trees n = 
    let trees = cbal n in
    List.filter is_symmetric trees

(* 48 construct height-balanced trees for a given height *)
let rec hbal_tree h = 
    if h = 0 then [Leaf]
    else if h = 1 then [Node ('x', Leaf, Leaf)]
    else let t1 = hbal_tree (h-1) and t2 = hbal_tree (h-2) in
    add_trees_with t1 t1 (add_trees_with t1 t2 (add_trees_with t2 t1 []))


(* 49 construct height-balanced trees for a given #nodes *)

(* 50 count leaves *)
let rec count_leaves t = match t with
    Leaf -> 0
    |Node (e, Leaf, Leaf) -> 1
    |Node (_, l, r) -> (count_leaves l) + (count_leaves r)

(* 51 collect leaves *)
let rec leaves t = match t with
        Leaf -> []
        |Node (e, Leaf, Leaf) -> [e]
        |Node (_, l, r) -> (leaves l) @ (leaves r)

(* 52 collect internals *)
let rec internals t = match t with
    Leaf | Node (_, Leaf, Leaf) -> []
    |Node (e, l, r) -> [e] @ (internals l) @ (internals r)

(* 53 collect nodes at a given level *)
let rec at_level t n = match t with
    Leaf -> []
    |Node (e, l, r) -> if n = 1 then [e] else (at_level l (n-1)) @ (at_level r (n-1))

