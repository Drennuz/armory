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

(* ex3.7  TODO: partial application *)

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

(* ex 5.3 *)
(* can't? function must return the same type *)

(* ex 5.4 *)
let db = 
    ["John", "x3456", 50.1;
    "Jane", "x1234", 107.3;
    "Joan", "unlisted", 12.7]

let find_salary name = 
    let rec aux name = function 
    [] -> raise (Invalid_argument "not found")
    |(name', _, salary)::t -> if name = name' then salary else aux name t
    in
    aux name db

let select f = 
    let rec aux res f = function
        [] -> res
        |h::t ->  if f h then aux (h::res) f t else aux res f t
    in
    aux [] f db

(* ex 5.5 TODO*)
(* f: 'a -> 'a other than identity function? *)

(* ex 5.6 *)
(* function application is NOT true polymorphism *)

let f (n : int) m = m;;
let f' = fun x -> f 0 x;; (* f' is now TRUE polymorphism *)

(* ex 5.7 *)
let append l1 l2 = 
    let rec aux res l = match l with
        [] -> res
        |h::t -> aux (h::res) t
    in List.rev(aux (List.rev l1) l2)

(* ex 5.8 *)
let rec exists c l = match l with
    [] -> false
    |h::t -> if h = c then true
             else (if h < c then exists c t else false)

let find_crook l1 l2 l3 = 
    let rec aux res m1 m2 m3 = match m1 with
        [] -> res
        |h::t -> if exists h m2 && exists h m3 then aux (h::res) t m2 m3
                 else aux res t m2 m3
    in
    aux [] l1 l2 l3
            
