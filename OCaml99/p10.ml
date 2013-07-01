(* NOTE: 
- Use `aux acc l` helper function + `List.rev`
- a::(b::_ as t) trick
*)

(* 1 find last element in a list *)

let rec last l = match l with
    [] -> None
    |[e] -> Some e
    |h :: t -> last t;;

(* 2 find last two elements in a list *)

let rec last_two l = match l with
    [] | [_] -> None
    |[e1;e2] -> Some (e1,e2)
    |h :: t -> last_two t;;

(* 3 Find the kth element *)

let rec at k l = match l with
    [] -> None
    |h :: t -> if k = 1 then Some h else at (k-1) t;;

(* 4 length of list *)
let length l = 
    let rec length_n n l = match l with
        [] -> n
        |_ :: t -> length_n (n+1) t
    in
    length_n 0 l;;

(* 5 reverse list *)
let rev l = 
    let rec aux acc = function
        [] -> acc
        |h :: t -> aux (h::acc) t
    in
    aux [] l;;

(* 6 test palindrome *)
let is_palindrome l = 
    l = rev l;;

(* 7 flatten a nested node *)
type 'a node = 
|One of 'a 
|Many of 'a node list;;

let flatten nl = 
    let rec aux acc l = match l with
        [] -> acc
        |One e :: t -> aux (e::acc) t
        |Many l :: t -> aux (aux acc l) t
    in List.rev (aux [] nl)

(* 8. Eliminate consecutive duplicates *)

let rec compress l = match l with
h1 :: (h2 :: _ as t) -> if h1 = h2 then (compress t) else h1 :: (compress t)
|sl -> sl

(* 9 Pack consecutive duplicate items into a list *)

let pack nl = 
    let rec aux sg res l = match l with
        [] -> [] (* only reached with nl = [] *)
        |[x] -> (x::sg)::res
        |a::(b::_ as t) -> if a = b then aux (a::sg) res t else aux [] ((a::sg)::res) t
    in 
    List.rev(aux [] [] nl);;

(* 10 Run length encoding of a list *)
let encode nl = 
    let rec aux ct res l = match l with
        [] -> []
        |[x] -> (ct+1,x)::res
        |a::(b::_ as t) -> if a = b then aux (ct+1) res t else aux 0 ((ct+1,a)::res) t
    in
    List.rev(aux 0 [] nl);;
