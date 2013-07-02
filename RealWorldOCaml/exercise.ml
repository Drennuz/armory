(* exercises from Introduction to OCaml *)

(* ex3.3 *)
let sum n m f = 
    let rec aux n m res f = 
        if m - n = 0 then res + f m 
        else aux n (m-1) (f m + res) f
    in aux n m 0 f;;

(* ex3.4 *)
let rec (%%) n m = 
    if m = 0 then n else
        if n > m then (%%) (n-m) m
        else (%%) n (m-n);;

(* ex3.5 *)

let search f n = 
    let rec aux i f = 
        if i < n && f i < 0 && f (i+1) >= 0 then i+1
        else aux (i+1) f
    in aux 0 f

(* ex3.6 *)
let empty (x:string) = 0
let add dict key v = function 
    key' -> if key = key' then v else dict key'
let find dict key = dict key

(* ex3.7 *)

(* ex3.8 *)
let hd s = s 0;;
let tl s = function i -> s (i+1);;
let (+:) s c = function i -> s i + c;;
let (-|) s1 s2 = function i -> s1 i - s2 i
let map f s = function i -> f (s i)
let derivative s = tl s -| s
let (+|) s1 s2 = function i -> s1 i + s2 i
let rec integral s = 
    let rec aux res n = match n with
        0 -> res
        |i -> aux (res + s (i-1)) (n-1)
    in aux 0

(* ex 4.3 TODO: get code review*)

let mapping = [('A','C'); ('B','A'); ('C','D');('D','B')]
let plaintext s = String.iter (fun c -> if c >= 'A' && c <= 'z' then () else raise (Invalid_argument "Not a plaintext string")) s;;
let check s1 s2 = 
    if plaintext s1 = () then
        s2 = String.map (fun c -> List.assoc c mapping) s1
    else raise (Invalid_argument "Not a plaintext string")
