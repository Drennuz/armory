(* sorting and selecting, benchmark in the end *)

module Sort : sig

    val generate : int -> int -> int array
    val merge_sort : 'a array -> 'a array
    val quick_sort : 'a array -> unit
    val rselect : 'a array -> int -> 'a
    val dselect : 'a array -> int -> 'a

end = struct

    let generate n max = 
        Random.self_init ();
        let res = Array.make n 0 in
        for i = 0 to n-1 do
            res.(i) <- Random.int max
        done;
        res

    (* merge sort *)

    let merge a1 a2 = 
        let l1 = Array.length a1 and l2 = Array.length a2 in
        let res = Array.make (l1+l2) a1.(0) in
        let i = ref 0 and j = ref 0 and k = ref 0 in
        while !k < (l1+l2) do
            if !i < l1 && !j < l2 then (
                if a1.(!i) < a2.(!j) then (res.(!k) <- a1.(!i); incr i;) else (res.(!k) <- a2.(!j); incr j)
            )
            else if !i >= l1 && !j < l2 then (res.(!k) <- a2.(!j); incr j)
            else if !j >= l2 && !i < l1 then (res.(!k) <- a1.(!i); incr i);
            incr k;
        done;
        res
    
    let rec merge_sort a = 
        let l = Array.length a in
        if l <= 1 then a else 
            merge (merge_sort (Array.sub a 0 (l/2))) (merge_sort (Array.sub a (l/2) (l - l/2))) 

    (* quick sort -- random pivot *)
    
    let swap a i j = 
        let temp = a.(i) in
        a.(i) <- a.(j);
        a.(j) <- temp

    let quick_sort a = 
        Random.self_init ();
        let l = Array.length a in
        let rec aux_qsort st ed = 
            if ed-st <= 1 then () else (
                let pivot_i = st + Random.int (ed-st) in
                let pivot = a.(pivot_i) in
                swap a st pivot_i;
                let i = ref (st+1) in
                for j = st+1 to ed-1 do
                    if a.(j) < pivot then (swap a !i j; incr i)
                done;
                swap a st (!i-1);
                aux_qsort st (!i-1); aux_qsort !i ed)
        in
        aux_qsort 0 l
    
    (* R-select, O(n) *)
    let rselect a k = 
        Random.self_init ();
        let l = Array.length a in
        let rec aux_rselect st ed = 
            if ed-st <= 1 then a.(st) else(
                let pivot_i = st + Random.int (ed-st) in
                let pivot = a.(pivot_i) in
                swap a st pivot_i;
                let i = ref (st+1) in
                for j = st+1 to ed-1 do
                    if a.(j) < pivot then (swap a !i j; incr i)
                done;
                swap a st (!i-1);
                if (!i-1) = k then pivot
                else if (!i-1) > k then aux_rselect st (!i-1)
                else aux_rselect !i ed
            )
        in
        aux_rselect 0 l
    
    let find a n = 
        let res = ref 0 in 
        for i = 0 to (Array.length a) - 1 do
            if a.(i) = n then res := i
        done;
        !res

    (* D-select, deterministic, O(n) *)
    let rec dselect a k = 
        let l = Array.length a in
        if l <= 1 then a.(0) else (
            let n = (if l mod 5 = 0 then l / 5 else l/5 + 1) in
            let median = Array.make n a.(0) in
            for i = 0 to n-2 do
                median.(i) <- (merge_sort (Array.sub a (5*i) 5)).(2)
            done;
            let rem = l - 5 * (n-1) in
            median.(n-1) <- (merge_sort (Array.sub a (5*(n-1)) rem)).(rem/2);
            let pivot = dselect median (n/2) in 
            let pivot_i = find a pivot in
            swap a 0 pivot_i; 
            let i = ref 1 in
            for j = 1 to l-1 do
                if a.(j) < pivot then (swap a !i j; incr i)
            done;
            swap a 0 (!i-1);
            if (!i-1) = k then pivot
            else if (!i-1) > k then dselect (Array.sub a 0 (!i-1)) k
            else dselect (Array.sub a !i (l - !i)) (k - !i)
        )
end

(*
Benchmark: 1m array with max 100m
---------------------------------
Name             % of max
merge_sort       100.00
quick_sort       86.30
---------------------------------
Name             % of max
rselect          9.90
dselect          100.00
*)
