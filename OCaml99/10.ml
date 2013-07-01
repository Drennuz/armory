(* 1 *)

let rec last l = match l with
    [] -> None
    |[e] -> Some e
    |h :: t -> last t;;

(* 2 *)

let rec last_two l = match l with
    [] | [e] -> None
    |[e1;e2] -> Some (e1,e2)
    |h :: t -> last_two t;;

(* 3 Find the kth element *)
