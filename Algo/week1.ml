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

(* return l[b:e) in O(e) time *)
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


(* Closest pair algorithm; using Arrays *)
module Cpair = 
struct

    type point = {x : float; y : float}

    (* calculate Euclidean distance between two points, O(1) *)
    let distance t1 t2 = sqrt ((t1.x -. t2.x) ** 2. +. (t1.y -. t2.y) ** 2.)
    
    (* generate an n-length array of random points, bounded by max *)
    (* O(n) *)
    let generate n max = 
        Random.self_init ();
        let res = Array.make n {x = 0.; y = 0.} in
        for i = 0 to n - 1 do
            let r_x = Random.float max and r_y = Random.float max in
            res.(i) <- {x = r_x; y = r_y}
        done;
        res
    
    (* merge sort input array a on one coordinate *)
    let rec merge a b coord = 
        let l1 = Array.length a and l2 = Array.length b in
        if l1 == 0 then b
        else if l2 == 0 then a
        else
            let res = Array.make (l1+l2) a.(0) in
            let i = ref 0 and j = ref 0 in
            for k = 0 to l1 + l2 - 1 do
                
                if coord == 'x' then(
                    if !i < l1 && !j < l2 then
                        if a.(!i).x < b.(!j).x then (res.(k) <- a.(!i); incr i) else (res.(k) <- b.(!j); incr j)
                    else if !i >= l1 then
                        (res.(k) <- b.(!j); incr j)
                    else if !j >= l2 then
                        (res.(k) <- a.(!i); incr i)
                ) 
                
                else if coord == 'y' then(
                    if !i < l1 && !j < l2 then
                    if a.(!i).y < b.(!j).y then (res.(k) <- a.(!i); incr i) else (res.(k) <- b.(!j); incr j)
                    else if !i >= l1 then
                        (res.(k) <- b.(!j); incr j)
                    else if !j >= l2 then
                        (res.(k) <- a.(!i); incr i)
                    )
            done;
            res

                
    let rec merge_list a b coord = match a, b with
        _ , [] -> a
        |[], _  -> b
        |h1 :: t1, h2 :: t2 ->
            if (coord = 'x' && h1.x <= h2.x) || (coord = 'y' && h1.y <= h2.y)  then
                h1 :: (merge_list t1 b coord)
            else h2 :: (merge_list a t2 coord)

    let rec sort a coord =
        let l = Array.length a in
        let hl = l / 2 in
        if l == 0 then [||] else
        if l == 1 then a else
            merge (sort (Array.sub a 0 hl) coord) (sort (Array.sub a hl (l-hl)) coord) coord

    (* find closest pair under O(nlogn) *)
    (* utility functions *)
    (* filter for arrays *)
    let filter f a = 
        let st = Stack.create () and l = Array.length a in
            for i = 0 to l-1 do
                if f a.(i) then Stack.push a.(i) st 
            done;
            let stl = Stack.length st in 
            let res = Array.make stl a.(0) in
            for i = 0 to stl - 1 do
                res.(stl - 1 - i) <- Stack.pop st
            done;
            res
    
    (* return smallest pair in length-3 array *)
    
    let base_3 a = 
        List.fold_left (fun (b0,b1) (c0, c1) -> if distance b0 b1 < distance c0 c1 then (b0, b1) else (c0,c1)) (a.(0), a.(1)) [(a.(0), a.(2));(a.(1), a.(2))]

    let split_pair px py delta = 
        let l = Array.length px in
        let mid_x = px.(l/2).x in
        let py_f = filter (fun p -> p.x <= mid_x +. delta && p.x >= mid_x -. delta) py in
        let minu = ref delta and res = ref None in
        let ly = Array.length py_f in 
        for i = 0 to (ly - 1) do
            for j = 1 to min 7 (ly-i-1) do
                if distance py_f.(i) py_f.(i+j) < !minu then(
                    minu := distance py_f.(i) py_f.(i+j);
                    res := Some(py_f.(i), py_f.(i+j)))
            done
        done;
        !res
    
    let pair_2 (l0, l1) (r0, r1) = 
        let d1 = distance l0 l1 and d2 = distance r0 r1 in
        if d1 < d2 then l0, l1
        else r0, r1
    
    let pair_3 (a0, a1) (b0, b1) (c0, c1) = 
        List.fold_left (fun (p0, p1) (p2, p3) ->
                            if distance p0 p1 < distance p2 p3 then
                            (p0, p1) else (p2, p3)) (a0, a1) [(b0, b1); (c0, c1)]
    
    let rec aux_cpair px py = 
        let l = Array.length px in
        let hl = l / 2 in
        if l <= 1 then failwith "singleton list!"
        else if l == 2 then px.(0), px.(1)
        else if l == 3 then base_3 px
        else
            let x_l = Array.sub px 0 hl and y_l = filter (fun p -> p.x < px.(hl).x) py and x_r = Array.sub px hl (l-hl) and y_r = filter (fun p -> p.x >= px.(hl).x) py in
            let pl0, pl1 = aux_cpair x_l y_l and pr0, pr1 = aux_cpair x_r y_r in
            let delta = min (distance pl0 pl1) (distance pr0 pr1) in
            let res = split_pair px py delta in
            match res with
                None -> pair_2 (pl0, pl1) (pr0, pr1)
                |Some (ps0, ps1) -> pair_3 (pl0, pl1) (pr0, pr1) (ps0, ps1)
    
    let closest a = 
        let px = sort a 'x' and py = sort a 'y' in
        aux_cpair px py
    
    let closest_straight a = 
        let l = Array.length a in
        let minu = ref (distance a.(0) a.(1)) and res = ref (a.(0), a.(1)) in
        for i = 0 to l - 1 do
            for j = i + 1 to l - 1 do
                if distance a.(i) a.(j) < !minu then(
                    minu := distance a.(i) a.(j); res := (a.(i), a.(j)))
            done
        done;
        !res

end
(*
let a = Cpair.generate 5000 20000.
let (x,y) = Cpair.closest a
let (m,n) = Cpair.closest_straight a

open Core_bench.Std;;

[ Bench.Test.create ~name: "clever" (fun () -> ignore (Cpair.closest a));
  Bench.Test.create ~name: "dumb"   (fun () -> ignore (Cpair.closest_straight a))]
|> Bench.bench
*)
