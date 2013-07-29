(* 21-30 in OCaml 99 *)

(* 21 insert an element at a given position *)

let rec insert_at e pos l = 
    if pos = 0 then e :: l
    else match l with
        h :: t -> h :: (insert_at e (pos-1) t)
        |[] -> insert_at e (pos-1) l

(* 22 create a list containing all integers within a given range *)

(* this is the array solution
let range st ed = 
    let step = (if st > ed then -1 else 1) in
    let l = if st > ed then st-ed+1 else ed-st+1 in
    let a = Array.to_list (Array.make l st) in
    List.mapi (fun i e -> e + step * i) a;;
*)

let range st ed = 
    let step = if st > ed then -1 else 1 in
    let rec aux res c = 
        if c - step = ed then List.rev res
        else aux (c :: res) (c + step)
    in
    aux [] st

(* 23 extract a given number of randomly selected elements from a list *)

let rand_select l k = 
    let rec extract acc c rest = match rest with
        h :: t -> (if c = 0 then (h, acc @ t) else extract (h::acc) (c-1) t)
        |[] -> failwith "empty list"
    in
    let rand_extract l = extract [] (Random.int (List.length l)) l
    in
    let rec aux c acc rest = 
        if c = k then acc
        else (
            let e, t = rand_extract rest in
            aux (c+1) (e::acc) t
        )
    in
    aux 0 [] l

(* 24 draw N different random numbers from set 1...M *)
let lotto_select n m  = 
    let l = range 1 m in
    rand_select l n

(* 25 generate a random permutation of the elements of a list *)
let permutation l = 
    rand_select l (List.length l)

(* 26 generate the combinations of K distinct objects chosen from the N elements of a list *)

(* 27 *)

(* 28 *)

(* ARITHMATIC *)

(* 29 determine whether a number is prime *)
exception NotPrime;;

let prime n = 
    if n = 2 then true
    else (
        try
            for i = 2 to int_of_float (sqrt (float_of_int n)) do
                if n mod i = 0 then raise NotPrime
            done;
            true
        with NotPrime -> false
    )

(* generate a list of prime numbers <= n *)
type number = {value : int; mutable prime : bool};;
let generate_prime n = 
    let rec build res m  = 
        if m = n then List.rev res
        else build ({value = m+1; prime = true} :: res) (m+1) in
    let a = build [] 1 in
    for i = 0 to n - 2 do
        let e = List.nth a i in
        let u = n / e.value in
        for j = e.value to u do
            (List.nth a (e.value * j - 2)).prime <- false;
        done
    done;
    let b = List.filter (fun x -> x.prime) a in
    List.map (fun x -> x.value) b;;
    
(*
let prime n = 
    let rec is_not_divisor d = 
        d * d > n || (n mod d <> 0 && is_not_divisor (d+1)) in
    n <> 1 && is_not_divisor 2;; *)

(* 30 greatest common divisor *)

let rec gcd m n = 
    if n = 0 then m else gcd n (m mod n)

(* 31 coprime -- gcd = 1 *)

let coprime x y = 
    gcd x y = 1
