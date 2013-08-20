module Stream = struct

    type 'a streamcell = Nil | Cons of 'a * 'a stream and 
    'a stream = 'a streamcell lazy_t

    (* example: lazy (Cons(2, lazy Nil)) *)

    let lazyappend l1 l2 = lazy ((force l1) @ (force l2))

    let rec append s1 s2 = match s1, s2 with
        lazy Nil, _ -> s2
        |lazy (Cons(x, t)), s2 -> lazy (Cons(x, append t s2))

    let rec take s n = match s, n with
        _, 0 -> lazy Nil
        |lazy Nil, _ -> lazy Nil
        |lazy (Cons(x, t)), _ -> lazy (Cons(x, take t (n-1)))

    let fst s = match s with
        lazy Nil -> failwith "empty stream"
        |lazy (Cons(x, t)) -> x

    (* drop: complete *)

    let rec drop s n = match s, n with
        _, 0 -> s
        |lazy Nil, _ -> lazy Nil
        |lazy (Cons(x, t)), _ -> drop t (n-1)

    let reverse s = 
        let rec rev' s r = match s, r with
            lazy Nil, _ -> r
            |lazy (Cons(x,t)), _ -> rev' t (lazy (Cons(x, r)))
        in rev' s (lazy Nil)
end
