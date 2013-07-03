(* intro to ocaml chap6- *)

(* ex 6.1 *)
type 'a mylist = Nil | Cons of 'a * 'a mylist

let map f ml = 
    let rec aux res f l = match l with
        Nil -> res
        |Cons (h, t) -> aux (Cons (f h, res)) f t
    in aux Nil f ml

(* TODO: tail-recursive version? *)
let rec append l1 l2 = match l1 with
    Nil -> l2
    |Cons(h,t) -> Cons(h, append t l2)

(* ex 6.2 *)
type unary_number = Z | S of unary_number

(* TODO: tail-recursive? *)
let rec add_unary m n = match n with
    Z -> m
    |S i -> S (add_unary m i)
    
let mult_unary m n = 
    let rec aux res i j = match j with
        Z -> Z
        |S Z -> add_unary res i
        |S k -> aux (add_unary res i) i k
    in aux Z m n

(* ex 6.3 *)
type small = Four | Three | Two | One

