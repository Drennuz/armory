(* chapter 7 intro to OCaml notes *)

(* queue; using 2 lists *)
module Queue = 
struct
    type 'a queue = ('a list * 'a list) ref
    
    let create () = ref ([], [])
    let add queue x = let (q1, q2) = !queue in
        queue := (x::q1, q2)
    let rec take queue = match !queue with
        ([], []) -> failwith "empty queue"
        |(q1, h::t) -> queue := (q1, t); h
        |(q1, []) -> queue := ([], List.rev q1); take queue
end

(* doubly-linked lists *)
module DList :
sig
    type 'a elem
    val nil_elem : 'a elem
    val create_elem : 'a -> 'a elem
    val get : 'a elem -> 'a
    val prev_elem: 'a elem -> 'a elem
    val next_elem: 'a elem -> 'a elem

    type 'a dllist
    val create : unit -> 'a dllist
    val insert : 'a dllist -> 'a elem -> unit
    val remove : 'a dllist -> 'a elem -> unit
end = 
struct
    type 'a elem = 
        Nil
        |Elem of 'a * 'a elem ref * 'a elem ref
    
    let nil_elem = Nil
    let create_elem a = Elem (a, ref Nil, ref Nil)

    let prev_elem e = match e with
        Nil -> Nil
        |Elem (_, p, _) -> !p

    let next_elem e = match e with
        Nil -> Nil
        |Elem (_, _, p) -> !p

    let get e = match e with
        Nil -> raise (Invalid_argument "get")
        |Elem (a, _, _) -> a

    type 'a dllist = 'a elem ref
    let create () = ref Nil
    
    let insert d e = match e, !d with
        Elem (a, prev, next), Nil -> prev := Nil; next := Nil;d := e 
        |Elem (a, prev1, next1), (Elem (_, prev2, next2) as h) -> 
            prev1 := Nil; 
            prev2 := e; next1 := h; d := e
        |Nil, _ -> raise (Invalid_argument "empty node")

    let remove d e = match e with
        Elem (a, prev, next) -> 
            (match !prev with    
                Nil -> d := !next
                |Elem (b, prev2, next2) -> next2 := !next);
            (match !next with
                Nil -> () 
                |Elem (c, prev3, next3) -> prev3 := !prev)
        |Nil -> raise (Invalid_argument "Nil element")
end

(* Memoization
Result stored in cache *)

module Memoiz = 
struct
    (* won't work for recursive calls *)
    let memo_wrong f = 
        let table = ref [] in
        let g x = 
        try
            List.assoc x !table
        with
        Not_found -> 
            let y = f x in
            table := (x,y) :: !table;
            y
        in
        (fun x -> g x)
    
    let memo f = 
        let m = ref [] in
        let rec g x = 
        try
            List.assoc x !m 
        with
        Not_found -> 
            let y = f g x in
                m := (x, y) :: !m;
                y
        in g

    let rec fib2 self n = match n with
        1 | 2 -> 1
        |n -> self (n-1) + self (n-2)

    let rec fib = function
        1 | 2 -> 1
        |n -> fib (n-1) + fib (n-2)

    let memo_fib = memo fib2
    let fib = memo_wrong fib

    let time f x = 
        let start = Sys.time () in
        let y = f x in
        let end1 = Sys.time () in
        end1 -. start
end


(* Graph Kruskal's algorithm *)
(* union-find structure *)
module Mst = struct

    type 'a parent = Root of int | Parent of 'a vertex
    and 'a vertex = 'a * 'a parent ref
    type 'a edge = float * 'a vertex * 'a vertex
    
    let create_vertex label = (label, ref (Root 1))
    
    let union ((_, p1) as v1) ((_, p2) as v2) = 
        match !p1, !p2 with
        Root size1, Root size2 when size1 > size2 ->
            p2 := Parent v1;
            p1 := Root (size1 + size2)
        | Root size1, Root size2 ->
            p1 := Parent v2;
            p2 := Root (size1 + size2)
        | _ -> raise (Invalid_argument "union: not roots")

    let rec compress root (_, p) = match !p with
        Root _ -> ()
        |Parent vp -> p := Parent root; compress root vp
    
    let rec simple_find ((_, p) as v) = 
        match !p with
        Root _ -> v
        |Parent vp -> simple_find vp

    let find v = 
        let root = simple_find v in
        compress root v;
        root
    
    let kruskal edges = 
        let span_tree = ref [] in
        List.iter (fun ((_, v1, v2) as edge) ->
            let u1 = find v1 in
            let u2 = find v2 in
            if u1 != u2 then begin
                span_tree := edge :: !span_tree;
                union u1 u2
                end) edges;
            !span_tree

end
