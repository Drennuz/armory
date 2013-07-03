(* Problems 11-20 *)

(* 11 modified length coding *)
(* implement with sublist first *)

type 'a rle =   
    One of 'a
    |Many of (int * 'a)

let pack l = 
    let rec aux current acc = function
        [] -> acc
        |[e] -> (e::current)::acc
        |a::(b::_ as t) -> if a = b then aux (a::current) acc t
                           else aux [] ((a::current)::acc) t
    in List.rev(aux [] [] l)

let encode_sublist l = 
    let rec aux = function
        [] -> []
        |[] :: t -> aux t
        |[x] :: t -> One x :: aux t
        |(h::t) :: l -> Many (1+List.length t, h) :: aux l
    in
    aux (pack l)

(* 12 decode run-length *)

let decode l = 
    let rec many acc n x = if n = 0 then acc else many (x::acc) (n-1) x
    in
    let rec aux res = function
        [] -> res
        |One e :: t -> aux (e::res) t (* NOTE *)
        |Many (ct, e) :: t -> aux (many res ct e) t
    in
    List.rev(aux [] l)

(* 13 run-length encoding, direct solution, no sublist creation *)

let encode l = 
    let rec aux ct res = function
        [] -> res
        |[e] -> if ct = 0 then (One e)::res else (Many (ct+1,e))::res
        |a::(b::_ as t) -> if a = b then aux (ct+1) res t
                           else 
                                if ct = 0 then aux 0 ((One a)::res) t
                                else aux 0 ((Many (ct+1,a))::res) t
    in List.rev(aux 0 [] l)

(* 14 Duplicates elements of a list *)

let rec duplicate_notail l = match l with
    [] -> []
    |h::t -> h::(h::(duplicate_notail t))

let duplicate l = 
    let rec aux res = function
        [] -> []
        |[e] -> e::(e::res)
        |h::t -> aux (h::(h::res)) t
    in
    List.rev(aux [] l)

(* 15 Replicate for a given number of times *)
(* NOTE: watch out for fold_left patterns! *)

let replicate_15 l n = 
    let rec rep n acc x = if n = 1 then x::acc else x::(rep (n-1) acc x)
    in
    List.fold_left (rep n) [] (List.rev l)

(* 16 Drop every kth element from a list *)
let drop l k = 
    let rec aux i res = function
        [] -> res
        |h::t -> if i = k then aux 1 res t 
                 else aux (i+1) (h::res) t
    in
    List.rev(aux 1 [] l)

(* 17 split a list into two parts, length of first list known *)

let rec real_split l b e =  (* l[b:e] *)
    match l with
    [] -> []
    |h::t -> 
        let tail = if e = 1 then [] else real_split t (b-1) (e-1) in
        if b > 0 then tail else h::tail

let split l n = 
    let m = List.length l in
    if m < n then l, []
    else real_split l 0 n, real_split l (n+1) m

let split_2 l n = 
    let rec aux i acc = function
        [] -> List.rev acc, []
        |h::t as l -> if i = 0 then List.rev acc, l
                 else aux (i-1) (h::acc) t
    in aux n [] l

(* 18 extract a sublist *)
(* inclusive *)
let rec slice l b e = 
    match l with
    [] -> []
    |h::t -> 
        let tail = if e = 0 then [] else slice t (b-1) (e-1) in
        if b > 0 then tail else h::tail

(* 19 rotate N places to left *)

let rotate l n = 
    let m = List.length l in
    let rn = if n = 0 then 0 else (n mod m + m) mod m in
    let l1,l2 = split_2 l rn in
    l2 @ l1

(* 20 remove kth element *)
let remove_at k l = 
    let rec aux i res = function
        [] -> res
        |h::t -> if i = k then aux (i+1) res t else aux (i+1) (h::res) t
    in List.rev(aux 0 [] l)

(* non tail-recursive version *)
let rec remove_at_nt k l = 
    match l with
        [] -> []
        |h::t -> if k = 0 then t else h::(remove_at_nt (k-1) t)
