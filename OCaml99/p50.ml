(* string representation of binary trees *)

type 'a btree = Leaf | Node of 'a * 'a btree * 'a btree

let string_of_btree t = 
    let b = Buffer.create 128 in
    let rec aux b t = 
        match t with
        Leaf -> ()
        |Node (n, Leaf, Leaf) -> Buffer.add_char b n
        |Node (n, l, r) -> 
            begin
            Buffer.add_char b n;
            Buffer.add_char b '(';
            aux b l;
            Buffer.add_char b ',';
            aux b r;
            Buffer.add_char b ')'
            end
    in aux b t;
    Buffer.contents b

let bt = Node ('a', Node ('b', Node('d', Leaf, Leaf), Node('e', Leaf, Leaf)), Node('c', Leaf, Node('f', Node('g', Leaf, Leaf), Leaf)))


(* preorder *)
let preorder t = 
    let b = Buffer.create 128 in
    let rec aux b t = match t with
        Node (n, l, r) -> begin
            aux b l;
            Buffer.add_char b n;
            aux b r
            end
        |_ -> ()
    in aux b t;
    Buffer.contents b

let inorder t = 
    let b = Buffer.create 128 in
    let rec aux b t = match t with
        Node (n, l, r) -> begin
            Buffer.add_char b n;
            aux b l;
            aux b r
            end
        |_ -> ()
    in aux b t;
    Buffer.contents b

let make_tree n l r = match n with
    Node (x, _, _) -> Node (x, l, r)
    |_ -> failwith "yo!"

let bt_of_string s = 
    let cl = String.to_array s in
    let len = Array.length cl  in
    let st = Stack.create () in
    for i = 0 to (len-1) do
        let c = cl.(i) in match c with
        '(' -> ()
        |',' -> if cl.(i-1) = '(' || cl.(i+1) = ')' then Stack.push st Leaf else ()
        |')' -> let r = Stack.pop_exn st and l = Stack.pop_exn st and n = Stack.pop_exn st in Stack.push st (make_tree n l r)
        |_ -> Stack.push st (Node (c, Leaf, Leaf))
    done;
    Stack.pop_exn st

let dot_of_bt t = 
    let b = Buffer.create 128 in
    let rec aux b t = match t with
        Leaf -> Buffer.add_char b '.'
        |Node(x, l, r) -> begin
            Buffer.add_char b x;
            aux b l;
            aux b r
            end
    in aux b t;
    Buffer.contents b

(* multiway trees *)

(* 54 count nodes *)
type 'a mtree = T of 'a * 'a mtree list

let rec count_nodes t = match t with
    T (_, l) -> 1 + (List.fold_left l ~init:0 ~f:(fun acc e -> acc + (count_nodes e)))
    
(* 55 tree construction from|to string *)
let string_of_mtree t = 
    let b = Buffer.create 128 in
    let rec buffer b (T(x, l)) = 
        begin
            Buffer.add_char b x;
            List.iter l ~f:(fun e -> buffer b e);
            Buffer.add_char b '^'
        end
    in buffer b t; Buffer.contents b

let t = T('a', [T('f', [T('g', [])]); T('c', []); T('b', [T('d', []); T('e', [])])])


(* 55.2 tree of substring *)

let rec tos t s i len = 
if i >= len || s.[i] = '^' then List.rev t, i+1
else
    let sub, j = tos [] s (i+1) len in
    tos (T(s.[i], sub)::t) s j len

let mt_of_string s = 
    match tos [] s 0 (String.length s) with
    [t], _ -> t
    |_ -> failwith "yo"

(* 56 internal path *)
let ipl t = 
    let rec aux len (T(_, sub)) = 
    List.fold_left sub ~init:len ~f:(fun acc e -> acc + (aux (len+1) e))
    in aux 0 t

(* 57 bottom-up *)

let bottom_up tr = 
    let t = Stack.create () in
    let rec aux t (T(x, l)) = 
    begin
        List.iter l ~f:(fun e -> aux t e);
        Stack.push t x
    end 
    in aux t tr;
    let rec aux res st = 
        let e = Stack.pop st in
        if e = None then res else aux ((Option.value_exn e)::res) st
    in aux [] t

(* 58 lispy like tree representation *)

let lispy t = 
    let b = Buffer.create 128 in
    let rec aux b (T(x, l)) = (
        match l with
        [] -> Buffer.add_char b x 
        |_ -> (Buffer.add_char b '('; Buffer.add_char b x;List.iter l ~f:(fun e -> aux b e); Buffer.add_char b ')'))
    in aux b t;
    Buffer.contents b

(* complete balance tree *)
type 'a btree = Leaf | Node of 'a * 'a btree * 'a btree

let is_complete_tree t n = 
    let a = Array.create ~len:n None and n = ref 1 in
    let rec aux start t = match t with
    Leaf -> true
    |Node(x, l, r) -> if start >= 2 && (a.(start-2) = None) then false
        else (a.(start-1) <- Some x; aux (2*start) l; aux (2*start + 1) r)
    in aux 1 t

