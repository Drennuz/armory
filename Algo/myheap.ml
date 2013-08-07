(* data structures *)

(* binary heap *)

module type ORDERED = sig
    type t
    val compare : t -> t -> bool (* true if fst < snd *)
    val print : t -> unit
end

module type Heap_intf = sig
    type heap
    type elem
    val empty : heap
    val isEmpty : heap -> bool
    val findMin : heap -> elem
    val merge : heap -> heap -> heap
    val insert : elem -> heap -> heap
    val deleteMin : heap -> heap
    val pprint : heap -> unit
    val of_list : elem list -> heap
    val rank : heap -> int
end

module Int = struct
    type t = int
    let compare a b = a < b
    let print x = print_int x
end

module Heap (Elem : ORDERED) : (Heap_intf with type elem = Elem.t) = struct
    type elem = Elem.t
    type heap = Leaf | Node of elem * heap * heap
    
    let rec rank h = match h with
        Leaf -> 0
        |Node (e, l, r) -> 1 + max (rank l) (rank r)

    let empty = Leaf
    
    let isEmpty h = match h with
        Leaf -> true
        |_ -> false

    let findMin h = match h with
        Leaf -> failwith "empty tree"
        |Node (e, _, _) -> e
    
    (* merge: keep largest subtree intact *)
    let rec merge h1 h2 = match h1, h2 with
        Leaf, _ -> h2
        |_, Leaf -> h1
        |Node (x, a1, b1), Node (y, a2, b2) -> (
            let nh = if Elem.compare x y then x else y in
            let (st1,st2,st3) = if nh = x then (a1,b1,h2) else (a2,b2,h1) in
            let (r1, r2, r3) = (rank st1, rank st2, rank st3) in
            if r1 > r2 && r1 > r3 then Node(nh, st1, merge st2 st3)
            else if r2 > r1 && r2 > r3 then Node (nh, st2, merge st1 st3)
            else Node (nh, st3, merge st1 st2)
        )

    let insert e h = merge (Node (e, Leaf, Leaf)) h

    let deleteMin h = match h with
        Leaf -> failwith "empty tree"
        |Node (e, l, r) -> merge l r

    let pprint h = 
        let rec aux level h2 = match h2 with
            Leaf -> ()
            |Node (e, l, r) -> (
                Printf.printf "%*s" (4 * level) "|"; flush stdout;
                Elem.print e;
                print_newline ();
                aux (level+1) l;
                aux (level+1) r
            ) in
        aux 0 h
    
    let of_list l = 
        let rec aux res ll = match ll with
            [] -> res
            |h :: t -> aux (insert h res) t
        in aux empty l
end


(* example *)
module IntHeap = Heap(Int)
