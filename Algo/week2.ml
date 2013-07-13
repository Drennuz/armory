(* Quick sort *)
(* more efficient than merge sort using benchmark *)

module Qsort : sig
    val max : int
    val generate : int -> int array
    val sort : 'a array -> unit
end = 
struct
    let max = 100000
    let generate n = 
        Random.self_init ();
        let a = Array.make n 0 in
        for i = 0 to (n-1) do
            a.(i) <- Random.int max
        done;
        a

    let swap i j a = 
        let temp = a.(i) in
        a.(i) <- a.(j);
        a.(j) <- temp;;

    let sort a = 
        Random.self_init ();
        let rec aux st ed = 
            if ed - st <= 1 then () 
            else
                let pivot_i = st + (Random.int (ed - st)) in
                let pivot = a.(pivot_i) in(
                    swap st pivot_i a;
                    let i = ref (st + 1) in
                    for j = (st+1) to (ed-1) do
                        if a.(j) < pivot then (swap !i j a; incr i) 
                    done;
                    swap st (!i-1) a;
                    aux st (!i-1);
                    aux !i ed;
                )
        in aux 0 (Array.length a)
end
