(* 21-39 in OCaml 99 
finish section number *)

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

let rec extract n l = 
    if n = 1 then (
        let rec aux res m = match m with
            h :: t -> aux (List.append res [[h]]) t
            |[] -> res
        in aux [] l
    ) else (let lb = extract (n-1) l in
        let res = ref [] in
        for i = 0 to List.length l - 1 do
            for j = 0 to List.length lb - 1 do
                if (not (List.mem (List.nth l i) (List.nth lb j))) then res := List.append !res ([(List.nth l i) :: (List.nth lb j)])
            done
        done;
        !res)

(* 27 *)

(* 28 *)

let length_sort l = 
    let l2 = List.map l ~f:(fun e -> (e, List.length e)) in
    let l3 = List.sort l2 ~cmp:(fun e1 e2 -> Int.compare (snd e1) (snd e2)) in
    List.map l3 ~f:(fun e -> fst e)

let freq_sort l = 
    let l2 = List.sort (List.map l ~f:List.length) ~cmp:Int.compare in
    let rec aux count acc l = match l with
        [] -> acc
        |[e] -> (e, count+1) :: acc
        |a :: (b::_ as t) -> if a = b then aux (count+1) acc t 
            else aux 0 ((a, count+1)::acc) t
    in let l3 = aux 0 [] l2 in
    let l4 = List.map l ~f:(fun e -> let f = List.Assoc.find_exn l3 (List.length e) in (f, e)) in
    let l5 = List.sort l4 ~cmp:(fun e1 e2 -> Int.compare (fst e1) (fst e2)) in
    List.map l5 ~f:snd

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

let is_prime n = 
    let n = abs n in
    let rec is_not_divisor d = 
    d * d > n || (n mod d <> 0 && is_not_divisor (d+1)) in
    n <> 1 && is_not_divisor 2

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

(* 32 Euler's totient function phi(m) #positive integers that are coprime *)

let phi n = 
    let rec aux acc d = 
        if d < n then let e = if coprime d n then 1 else 0 in aux (acc + e) (d+1)
        else acc
    in
    if n = 1 then 1
    else aux 0 1

(* 33 prime factors of a given positive integer *)
let nactor n = 
    let primes = generate_prime n in
    let rec aux res k ps = 
        if prime k then List.rev (k::res)
        else(
            match ps with
            [] -> res
            |h :: t as l -> if k mod h = 0 then aux (h::res) (k / h) l else aux res k t
        )
    in aux [] n primes

let factors n = 
    let rec aux d k =
        if k = 1 then [] else
        if k mod d = 0 then d :: (aux d (k/d)) else aux (d+1) k
    in
    aux 2 n

(* 34 prime factors with multiplicity *)
let mfactors n = 
    let fs = factors n in
    let rec aux current count res l = match l with
        [] -> List.rev ((current, count) :: res)
        |h :: t -> if current = h then aux current (count+1) res t 
                else aux h 1 ((current,count)::res) t
    in match fs with
        [] -> [] 
        |h :: t -> aux h 1 [] t

(* 35 improved Euler's phi function *)
let phi_improved n = 
    let fs = mfactors n in
    let rec aux res l = match l with
        [] -> int_of_float res
        |(p,m) :: t -> aux (res *. (float_of_int (p-1)) *. (float_of_int p) ** (float_of_int (m-1))) t in
    aux 1. fs

(* 36 benchmark two phi *)
let timeit f n =
    let x = Sys.time () in
    let y = ignore (f n) in
    Sys.time () -. x

(* 37 a list of prime numbers *)
let rec all_primes l u = 
    if l > u then [] else
    let rest = all_primes (l+1) u in 
    if prime l then l :: rest else rest

(* 38 Goldbach's conjecture: two primes sum up to n *)
exception Break

let goldbach n = 
    let rec aux d = 
    if is_prime d && is_prime (n-d) then (d, n-d)
    else aux (d+1) in
    aux 2

(* 39 A list of goldbach compositions *)
let goldbach_list l u = 
    let rec aux res d = 
        if d > u then List.rev res 
        else if d mod 2 = 0 then 
            let p = goldbach d in
            aux ((d, p) :: res) (d+2)
        else aux res (d+1) in
    aux [] l

let rec rgoldbach_list l u = 
    if l > u then []
    else if l mod 2 = 0 then (l, goldbach l) :: (goldbach_list (l+2) u)
    else goldbach_list (l+1) u

let goldbach_limit l u t = 
    List.filter (fun (_, (t1, t2)) -> t1 >= t && t2 >= t) (goldbach_list l u)
