(* 7.2 + 7.3 *)

module Lazy  =
struct
    type 'a deferred = {value :'a option ref; f : (unit -> 'a)}
    let defer f = {value = ref None; f = f}

    let force t = match !(t.value) with
        None -> let y = t.f () in t.value := Some y; y
        |Some v -> v

    type 'a lazy_list = 
        Nil
        |Cons of 'a * 'a lazy_list
        |LazyCons of 'a * 'a lazy_list deferred

    let nil = Nil
    let is_nil a = match a with
        Nil -> true
        |_ -> false
    
    let cons a t = Cons(a, t)

    let lazy_cons a f = LazyCons(a, {value = ref None; f = f})
    
    let head a = match a with
        Nil -> failwith "empty list"
        |Cons (h, t) -> h
        |LazyCons (h, t) -> h
    
    let tail a = match a with
        Nil -> failwith "empty list"
        |Cons (h, t) -> t
        |LazyCons (h, t) -> force t

    let rec append l1 l2 = match l1, l2 with
        Nil, _ -> l2
        |_, Nil -> l1
        |Cons(h1, t1), Cons(h2, t2) -> LazyCons(h1, {value = ref None; f = function () -> lazy_cons h2 (function () -> append t1 t2)})
        |Cons(h1, t1), LazyCons(h2, t2) -> append l1 (cons h2 (force t2))
        |LazyCons(h1, t1), Cons(h2, t2) -> append (cons h1 (force t1)) l2
        |LazyCons(h1, t1), LazyCons(h2, t2) -> append (cons h2 (force t1)) (cons h2 (force t2))
end

module Pqueue = 
struct
    type 'a queue = 'a list * 'a list

    let empty = [], []

    let add queue e = match queue with
        [], q2 -> [e], q2
        |q1, q2 -> e::q1, q2

    let rec take queue = match queue with
        [], [] -> failwith "empty queue"
        |q1, [] -> take ([], List.rev q1)
        |q1, h::t -> h , (q1, t)
end

module Rmemo = 
struct

    let timing f = 
        let start = Sys.time () in
        let y = f () in
        (Sys.time ()) -. start

    type ('a, 'b) memo = ('a * 'b) list ref

    let create_memo () : ('a, 'b) memo = ref []
    
    let memo_find m e = 
        try
            Some (List.assoc e !m)
        with Not_found -> None
    
    let memo_add m a b = match memo_find m a with
        None -> m := (a,b) :: !m
        |Some _ -> ()
    
    (* difference: call memo_fib (rather than fib) in recursion *)
    
    let rec memo_fib m n = match n with
        1 | 2 -> memo_add m n 1; 1
        |x -> (match memo_find m x with
            Some v -> v
            |None -> let y = (memo_fib m (n-1)) + (memo_fib m (n-2)) in
                memo_add m x y; y
            )
    
    let rec fib = function
        1|2 -> 1
        |n -> (fib(n-1)) + (fib(n-2))
    
    let mfib = memo_fib (create_memo ()) 
end

module DFS = 
struct
    (* label, out edges, marked, DFS index *)
    type 'a vertex = Vertex of 'a * 'a vertex list ref * bool ref * int option ref
    type 'a directed_graph = 'a vertex list
    
    let create_node a = Vertex(a, ref [], ref false, ref None)
    let add_edge v e = match v with
        Vertex (_, b, _, _) -> b := e::!b
    
    let get_label v = match v with
        Vertex (l, _, _, _) -> l

    let get_edges v = match v with
        Vertex (_, l, _, _) -> l

    let get_mark v = match v with
        Vertex (_, _, m, _) -> m

    let get_index v = match v with
        Vertex (_, _, _, c) -> c
    
    let mark_index v c = match v with
        Vertex (_, _, _, ind) -> ind := c

    let rec push_list l st = match l with
        [] -> ()
        |h::t -> Stack.push h st; push_list t st

end
