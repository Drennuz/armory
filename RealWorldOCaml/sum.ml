(* 1. A guided tour *)

open Core.Std

let rec read_and_accum accum = 
    let line = In_channel.input_line In_channel.stdin in
        match line with
        None -> accum
        |Some x -> read_and_accum (accum +. Float.of_string x)

let () = 
    printf "Total: %F\n" (read_and_accum 0.)
