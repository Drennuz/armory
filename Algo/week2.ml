(* Quick sort *)
(* more efficient than merge sort using benchmark *)

module Qsort : sig
    val max : int
    val generate : int -> int array
    val sort : int array -> int
    val read_file : string -> int array 
    val median : 'a array -> int -> int -> int -> int
end = 
struct
    let max = 100000
    
    let read_file fname = 
        let f = open_in fname in
        let rec aux res = 
        try 
            aux ((Scanf.fscanf f "%d\n" (fun x -> x)) :: res)
        with End_of_file -> Array.of_list (List.rev res)
        in aux []
    
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
    
    let median a i j k = 
        if (a.(i) <= a.(j) && a.(j) <= a.(k)) || (a.(k) <= a.(j) && a.(j) <= a.(i)) then j
        else if (a.(j) <= a.(i) && a.(i) <= a.(k)) || (a.(k) <= a.(i) && a.(i) <= a.(j)) then i
        else k

    let sort a = 
        Random.self_init ();
        let ct = ref 0 in
        let rec aux st ed = 
            if ed - st <= 1 then !ct 
            else
                (ct := !ct + (ed - st - 1);
                let pivot_i = median a st (ed - 1) (st + (ed-st-1)/2)  in
                let pivot = a.(pivot_i) in(
                    swap st pivot_i a;
                    let i = ref (st + 1) in
                    for j = (st+1) to (ed-1) do
                        if a.(j) < pivot then (swap !i j a; incr i) 
                    done;
                    swap st (!i-1) a;
                    ignore (aux st (!i-1));
                    ignore (aux !i ed);
                );
                !ct)
        in aux 0 (Array.length a)
end
