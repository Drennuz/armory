module Chap10 = struct

    (* 10.2 *)
    let read_lines chan = 
        let rec aux res = 
            let nl = try Some (input_line chan) with End_of_file -> None in
            match nl with
            None -> List.rev res
            |Some s -> aux (s::res) in
    aux []

    (* 10.3 *)
    let with_in_file fname f = 
        let ch = open_in fname in
        try (let y = f ch in close_in ch; y)
        with _ as e -> (close_in ch; raise e)
    
    (* 10.4 *)
    let exchange f1 f2 = 
    try
        let c1 = open_in f1 and c2 = open_in f2 in
        let a = input_char c1 and b = input_char c2 in
        close_in c1;
        close_in c2;
        let c1 = open_out f1 and c2 = open_out f2 in
        output_char c1 b; output_char c2 a;
        close_out c1; close_out c2
    with _ -> ()

    (* 10.5 *)
    type exp = 
        Int of int
        |Id of string
        |List of exp list

    let rec print_exp e = match e with
        Int i -> Printf.printf "%d" i
        |Id s -> Printf.printf "%s" s
        |List l -> (print_char '('; 
            for i = 0 to List.length l - 2 do
                print_exp (List.nth l i);
                print_char ' '
            done;
            print_exp (List.nth l (List.length l - 1));
            print_char ')')
    
    (* 10.6 *)
    let f6 fname = 
        let c = open_in fname in
        let b1 = Buffer.create 20 and b2 = Buffer.create 20 in
        let rec aux () = 
        try
            let h = input_char c in
            if h = '1' then Buffer.add_string b1 (input_line c) else Buffer.add_string b2 (input_line c);
            if Buffer.length b2 > 0 && Buffer.length b1 > 0 then (
                print_string (Buffer.contents b1);  
                print_newline ();
                print_string (Buffer.contents b2);
                print_newline ();
                Buffer.clear b1;
                Buffer.clear b2;);
            aux ();
        with _ -> () in
        aux ();
        close_in c

    (* 10.7 *)
    let f7 (x,y,z) = Printf.printf "%-*s0x%08x %*s\n" (max 5 (String.length x)) x y (max 3 (String.length z)) z
    
    (* 10.8 *)
    let print_cols pl = 
        let (l1, l2) = List.split pl in
        let c1 = List.fold_left (fun x s -> max (String.length s) x) 0 l1 in
        List.iter2 (Printf.fprintf stdout "%-*s%s\n" (c1+1)) l1 l2
end
