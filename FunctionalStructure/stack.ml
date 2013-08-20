module Stack = struct
    type 'a t = Nil | Cons of 'a * 'a t
    let empty = Nil
    let isempty t = t = Nil
    
    let cons x t = Cons(x,t)

    let tail t = match t with
        Nil -> failwith "empty stack"
        |Cons (_, tail) -> tail

    let head t = match t with
        Nil -> failwith "empty stack"
        |Cons (x, _) -> x

    let pop t = head t
    let push t e = cons t e
    
    (* tail-recursive version 
    let (++) s1 s2 = 
        match s1 with
        Nil -> s2
        |Cons (x, t) -> 
            let rec rev acc l = match l with
                Nil -> acc
                |Cons (x, t) -> rev (Cons(x,acc)) t
            in let rev_s1 = rev Nil s1 in
            let rec aux acc l = match l with
                Nil -> acc
                |Cons (y, t) -> aux (Cons (y,acc)) t
            in aux rev_s1 s2
    *)

    let rec (++) s1 s2 = match s1 with
        Nil -> s2
        |Cons (s, t) -> Cons (s, (++) t s2)
    
    let rec update s i y = match s with
        Nil -> failwith "empty"
        |Cons (x, t) -> if i = 0 then Cons (y, t)
            else Cons (x, update t (i-1) y)

end
