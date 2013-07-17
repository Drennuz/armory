(* hash table: hash(key) as index into array *)

module Ref = 
struct
    type 'a ref = {mutable contents : 'a}

    let ref a = {contents = a}

    let (!) r = r.contents

    let (:=) r c = r.contents <- c
end

(* 8.3 *)

module Dic = 
struct
    type ('key, 'value) dictionary = 
        {
            insert : 'key -> 'value -> ('key, 'value) dictionary;
            find : 'key -> 'value
        }
        let empty = 
            let contents = ref [] in
            let rec r = 
                {
                insert = (fun k v -> contents := (k,v) :: !contents; r);
                find = (fun x -> List.assoc x !contents)
                } in
                r
end

(* 8.4 *)

module Gui = 
struct
    type blob = 
        {get : unit -> float * float;
         area : unit -> float;
         set : float * float -> unit;
         move : float * float -> unit
        }
    
    let new_rec x y w h = 
        let pos = ref (x,y) in
        let rec r = 
            {
                get = (fun () -> !pos);
                area = (fun () -> w *. h);
                set = (fun loc -> pos := loc);
                move = (fun (dx, dy) ->
                    let (x,y) = r.get() in
                    r.set (x +. dx, y +. dy))
            }
            in 
            r
end

(* 8.5 reverse string in-place *)

module Rstring = 
struct
    let swap s i j = 
        let temp = s.[i] in
        s.[i] <- s.[j];
        s.[j] <- temp
    
    let reverse s = let l = String.length s in
        for i = 0 to (l/2 - 1) do
            swap s i (l-1-i)
        done;
        s
end

(* 8.6 out of bounds  *)

(* 8.7 insertion sort *)

module Isort = 
struct
    let max = 10000
    let generate n = 
        Random.self_init ();
        let res = Array.make n 0 in
        for i = 0 to n-1 do
            res.(i) <- Random.int max
        done;
        res

    let insert a i = 
        let temp = a.(i) in
        let j = ref i in
        while !j - 1 >= 0 && a.(!j - 1) > temp do
            a.(!j) <- a.(!j-1);
            decr j
        done;
        a.(!j) <- temp
    
    let sort a = 
        for i = 1 to (Array.length a - 1) do
        insert a i
        done
end
