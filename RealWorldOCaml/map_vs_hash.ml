open Core.Std
open Core_bench.Std

let map_iter ~numkeys ~iter = 
    let rec loop i m = 
        if i = 0 then ()
        else loop (i-1) (Map.change m (i mod numkeys) (fun e -> Some (1 + Option.value ~default:0 e))) in
    loop iter Int.Map.empty

let hash_iter ~numkeys ~iter = 
    let t = Int.Table.create ~size:numkeys () in
    let rec loop i = 
        if i = 0 then ()
        else (
            Hashtbl.change t (i mod numkeys) (fun e -> Some (1 + Option.value ~default:0 e)); 
        loop (i-1) ) in
    loop iter

let map_create ~numkeys ~iter = 
    let rec loop i m = 
        if i = 0 then []
        else (
            let n = Map.change m (i mod numkeys) (fun e -> Some (1+ Option.value ~default:0 e)) in n :: (loop (i-1) n)
        ) in
        loop iter Int.Map.empty

let tbl_create ~numkeys ~iter = 
    let t = Int.Table.create ~size:numkeys () in
    let rec loop i = 
        if i = 0 then [] 
        else (
            Hashtbl.change t (i mod numkeys) (fun e -> Some (1 + Option.value ~default:0 e));
            let n = Hashtbl.copy t in n :: (loop (i-1))
        ) in
    loop iter

let test ~numkeys ~iter = 
    let t name f = Bench.Test.create ~name f in
    [t "map" (fun () -> ignore (map_create ~numkeys ~iter));
     t "hash" (fun () -> ignore (tbl_create ~numkeys ~iter))]

let () = 
test ~numkeys:1000 ~iter:1000
|> Bench.make_command
|> Command.run 
    
