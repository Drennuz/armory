module type ORDERED = sig
    type t
    val compare : t -> t -> int
    val print : t -> unit
end

module type Tree_itf = sig
    type tree
    type elem 
    val empty : tree
    val search : elem -> tree -> elem option
    val insert : elem -> tree -> tree
    val findMin : tree -> elem
    val findMax : tree -> elem
    val traverse : tree -> unit
    val of_list : elem list -> tree
    val select : tree -> int -> elem
    val size : tree -> int
    val rank : elem -> tree -> int
    val pred : elem -> tree -> elem
    val succ : elem -> tree -> elem
end

module Tree (Elem:ORDERED) : (Tree_itf with type elem = Elem.t) = struct
    type elem = Elem.t
    type tree = Leaf | Node of elem * tree * tree * int (* tree size *)
    
    let empty = Leaf
    
    let size t = match t with
        Leaf -> 0
        |Node (_, _, _, i) -> i

    let rec search e t = match t with
        Leaf -> None
        |Node (root, l, r, _) -> if (Elem.compare e root = 0) then (Some e) 
            else if (Elem.compare e root < 0) then search e l
            else search e r
    
    let rec insert e t = match t with
        Leaf -> Node (e, Leaf, Leaf, 1)
        |Node (root, l, r, i) -> if (Elem.compare e root = 0) then t
            else if (Elem.compare e root < 0) then Node (root, insert e l, r, i+1)
            else Node (root, l, insert e r, i+1)

    let rec findMin t = match t with
        Leaf -> failwith "empty tree"
        |Node (root, Leaf, _, _) -> root
        |Node (root, l, _, _) -> findMin l

    let rec findMax t = match t with
        Leaf -> failwith "empty tree"
        |Node (root, _, Leaf, _) -> root
        |Node (root, _, r, _) -> findMax r

    (* delete: parent pointer; swap with predecessor *)

    (* in-order traversal *)
    let rec traverse t = match t with
        Leaf -> ()
        |Node (root, l, r, _) -> 
            begin
                traverse l;
                Elem.print root;
                traverse r;
            end
    (* List.fold_left *) 
    let of_list l = 
        let rec aux t rem = match rem with
            [] -> t
            |h :: tl -> aux (insert h t) tl
        in aux empty l

    let rec select t i = match t with
        Leaf -> failwith "empty tree in select"
        |Node (e, l, r, n) -> 
            begin
                let lsize = size l in
                if lsize = i-1 then e
                else if lsize > i-1 then select l i
                else select r (i-1-lsize)
            end
    
    let rec rank e t = match t with
        Leaf -> failwith "empty tree in rank"
        |Node (root, l, r, n) -> 
            begin
                let lsize = size l in
                if (Elem.compare root e = 0) then (lsize + 1)
                else if (Elem.compare e root < 0) then rank e l
                else lsize + 1 + (rank e r)
            end

    let pred e t = 
        let r = rank e t in select t (r-1)

    let succ e t = 
        let r = rank e t in select t (r+1)

end

module MyInt = struct
    type t = int
    let compare a b = if a = b then 0 else if a < b then -1 else 1
    let print i = Printf.printf "%d\t" i
end

module IntTree = Tree(MyInt)
