(* find i-th statistics from an array *)

module Rselect = 
struct
    
    let max = 10000

    let generate n = 
        Random.self_init ();
        let res = Array.make n 0 in
        for i = 0 to n-1 do
            res.(i) <- Random.int max
        done;
        res

    let swap a i j = 
        let temp = a.(i) in
        a.(i) <- a.(j);
        a.(j) <- temp

    let select a n = 
        Random.self_init ();
        let l = Array.length a in
        let rec aux_select st ed k = 
            if ed - st <= 1 then a.(st)
            else (
                let pivot_i = st + Random.int (ed - st) in
                let pivot = a.(pivot_i) in
                swap a pivot_i st;
                let i = ref (st+1) in
                for j = st+1 to ed-1 do
                    if a.(j) < pivot then (swap a !i j; incr i)
                done;
                swap a st (!i-1);
                if !i-1 = k then pivot
                else (if !i-1 > k then aux_select st (!i-1) k
                else aux_select !i ed k))
        in
        aux_select 0 l n

end

module Mincut = 
struct

    let readfile fname  = 
        let f = open_in fname and res = ref [||] in
        try
            while true do 
                let line = input_line f in
                let l = List.map (int_of_string) (Str.split (Str.regexp "[ \t\r]+") line) in
                match l with
                h :: t -> let at = Array.of_list t in res := Array.append !res [|(h, at)|]
                |_ -> failwith "empty line!" (* should never happen! *)
            done;
            !res
        with End_of_file -> !res
    
    let sample = [|(1, [|2;3|]);
                   (2, [|1;3;4|]);
                   (3, [|1;2;4|]);
                   (4, [|2;3|])|]
    
    let add a e = Array.append a [|e|]

    (* delete all x in a *)
    let del a x = 
        let s = Stack.create () in
        for i = 0 to Array.length a - 1 do
            if a.(i) != x then Stack.push a.(i) s
        done;
        let l = Stack.length s in
        let res = Array.make l a.(0) in
        for i = 0 to l - 1 do
            res.(l-1-i) <- Stack.pop s
        done;
        res
    
    (* remove i-th line *)
    let remove a i = 
        Array.append (Array.sub a 0 i) (Array.sub a (i+1) (Array.length a - i - 1))
    (* a is the formatted array *)

    let rec single_karger a = 
        if Array.length a <= 2 then
            let (v, e) = a.(0) in Array.length e 
        else (
            Random.self_init ();
            let l = Array.length a in
            let v_i = Random.int l in
            let (v, e) = a.(v_i) in
            let u_i = Random.int (Array.length e) in
            let u = e.(u_i) and to_del = ref 0 in
            for i = 0 to l-1 do
                let (x,y) = a.(i) in if x = u then to_del := i
            done;
            let res = Array.make (l-1) a.(0) and k = ref 0 in
            for i = 0 to l-1 do
                let (x,y) = a.(i) in
                if x!= v && x!= u then (
                    let ty = Array.copy y in
                    for j = 0 to Array.length y - 1 do
                        if y.(j) = u then ty.(j) <- v
                    done;
                    res.(!k) <- (x, ty);
                    incr k
                )
                else if x = v then (
                    let ty = ref [||] in
                    let (u_x, u_y) = a.(!to_del) in
                    for j = 0 to Array.length y - 1 do
                        if y.(j) != u then ty := add !ty y.(j)
                    done;
                    for j = 0 to Array.length u_y - 1 do
                        if u_y.(j) != v then ty := add !ty u_y.(j)
                    done;
                    res.(!k) <- (x, !ty);
                    incr k
                )
            done;
            single_karger res
        )

    let karger a = 
        let l = Array.length a in
        let n = l * l * (int_of_float (log (float_of_int l))) in
        let min = ref (single_karger a) in
        for i = 1 to n do
            let y = single_karger a in 
            if y < !min then min := y;
            if i mod 10 = 0 then (
                print_int i;
                print_char '\t';
                print_int !min ;
                print_newline ();
            )
        done;
        !min
end

