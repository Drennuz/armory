(* chapter 4 *)

open Core.Std

let build_ct () = 
    In_channel.fold_lines stdin ~init:Counter.empty ~f: Counter.touch

let () = 
    build_ct ()
    |> Counter.to_list
    |> List.sort ~cmp:(fun (_, x) (_,y) -> Int.descending x y) 
    |> (fun l -> List.take l 10)
    |> List.iter ~f: (fun (line, ct) -> printf "%3d: %s\n" ct line)
