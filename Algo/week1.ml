(* algorithms from notes *)

(* karatsuba multiplication *)
let ndigits n = 
    let rec aux i m = 
        if m < 10 then i
        else aux (i+1) (m/10)
    in aux 1 n;;

let decomp n = 
    let m = (ndigits n) / 2 in 
    let pf = int_of_float (10. ** float_of_int m) in
    let a = n / pf in
    (pf, a, n - a * pf)

let rec karatsuba x y = 
        if x < 10 && y < 10 then x * y 
        else let (p1, a, b) = decomp x and (p2, c, d) = decomp y in
        let f1 = karatsuba a d  and f2 = karatsuba a c and f3 = karatsuba b d  and f4 = karatsuba b c in
        p1 * p2 * f2 + p1 * f1 + p2 * f4 + f3

(* merge sort *)

let rec merge l1 l2 = match l1, l2 with
    _, [] -> l1
    |[], _ -> l2
    |h1::t1, h2::t2 -> if h1 < h2 then h1::(merge t1 l2)
                       else h2::(merge l1 t2)

let rec sublist l b e =  match l with
    [] -> []
    |h::t -> let tail = if e = 1 then [] else sublist t (b-1) (e-1) in
        if b > 0 then tail else h::tail
       
let rec merge_sort l = match l with
    [] -> raise (Failure "fail!") (* should never reach *)
    |[_] as t -> t
    |_ -> let n = (List.length l) / 2 in
        let l1, l2 = (sublist l 0 n, sublist l n (List.length l)) in
        merge (merge_sort l1) (merge_sort l2)


(* count inversions -- SLOW *)

let merge_and_count l1 l2 = 
    let rec aux res count m1 m2 = match m1, m2 with
        _, [] -> count, (List.rev res @ m1)
        |[], _ ->count, (List.rev res @ m2)
        |h1::t1, h2::t2 -> if h1 < h2 then aux (h1::res) count t1 m2
            else aux (h2::res) (count + List.length m1) m1 t2
    in aux [] 0 l1 l2

let rec aux_count_inversion l = match l with
    [] -> failwith "empty list"
    |[_] as t -> 0, t
    |_ -> let n = (List.length l) / 2 in
        let l1, l2 = sublist l 0 n, sublist l n (List.length l) in
        let c1, ll1 = aux_count_inversion l1 and c2, ll2 = aux_count_inversion l2 in
        let c, m = merge_and_count ll1 ll2 in
        c1 + c2 + c, m

let count_inversion l = 
    let c, m = aux_count_inversion l in c

(* Strassen's Algorithm for matrix multiplication in mat.ml *)

