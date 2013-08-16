(* multiway trees *)

(* 54 count nodes *)
type 'a mtree = T of 'a * 'a mtree list

let rec count_nodes t = match t with
    T (_, l) -> 1 + (List.fold_left l ~init:0 ~f:(fun acc e -> acc + (count_nodes e)))
    
(* 55 tree construction from|to string *)
let string_of_tree t = 
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
        Buffer.add_char b x;
        match l with
        [] -> () 
        |_ -> (Buffer.add_char b '('; List.iter l ~f:(fun e -> aux b e); Buffer.add_char b ')'))
    in aux b t;
    Buffer.contents b
