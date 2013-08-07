module Gsearch = struct
    type vertex = {label : char; mutable explored : bool; mutable neighbors : vertex list; mutable dist : int; mutable tsort : int}
    type graph = vertex list
    
    let s = {label = 'S'; explored = false; neighbors = []; dist = 0; tsort = 0} 
    let a = {label = 'A'; explored = false; neighbors = []; dist = 0; tsort = 0} 
    let b = {label = 'B'; explored = false; neighbors = []; dist = 0; tsort = 0} 
    let c = {label = 'C'; explored = false; neighbors = []; dist = 0; tsort = 0} 
    let d = {label = 'D'; explored = false; neighbors = []; dist = 0; tsort = 0} 
    let e = {label = 'E'; explored = false; neighbors = []; dist = 0; tsort = 0} 

    let init () = 
        let g1 = [s;a;b;c] in
        (s.neighbors <- [a;b];
        a.neighbors <- [c];
        b.neighbors <- [c]);
        g1
    
    let rec printg g = 
        List.iter (fun h -> 
print_char h.label; print_char '\t'; let e = if h.explored then "explored \t" else "unexplored \t" in print_string e; 
        print_int (h.dist); print_string "\t tsort\t"; print_int h.tsort;
        print_newline ()) g

    (* BFS search, return updated graph *)
    let bfs g v = 
        List.iter (fun x -> x.explored <- false) g;
        let q = Queue.create () in
        Queue.add v q;
        while not (Queue.is_empty q) do
            let e = Queue.take q in
            List.iter (fun x -> if not x.explored then (x.explored <- true; Queue.add x q)) e.neighbors
        done
    
    let rec dfs g v = 
        v.explored <- true;
        List.iter (fun x -> if not x.explored then dfs g x) v.neighbors

    let spath g v = 
        (* clean up g *)
        List.iter (fun x -> x.explored <- false) g;
        v.dist <- 0;
        v.explored <- true;
        let q = Queue.create () in
        Queue.add v q;
        while not (Queue.is_empty q) do
            let e = Queue.take q in
            List.iter (
                fun x -> if not x.explored then (
                    x.explored <- true;
                    x.dist <- e.dist + 1;
                    Queue.add x q)
                ) e.neighbors
        done

    let topsort g = 
        let current_label = ref (List.length g) in
        let rec idfs g v = (
            v.explored <- true;
            List.iter (fun x -> if not x.explored then idfs g x) v.neighbors;
            v.tsort <- !current_label;
            decr current_label) in
        List.iter (fun x -> if not x.explored then idfs g x) g

end

module Kosaraju = struct
    type vertex = {mutable label : int; mutable neighbors : vertex list; mutable explored : bool; mutable f : int; mutable leading : int}
    type graph = vertex list
    
    let create_node l = {label = l; neighbors = []; explored = false; f = -1; leading = -1}
    
    let a = create_node 0
    let b = create_node 1
    let c = create_node 2
    let d = create_node 3
    let e = create_node 4
    let f = create_node 5
    
    let init () = 
    a.neighbors <- [b];
    b.neighbors <- [c; d];
    c.neighbors <- [a];
    d.neighbors <- [e];
    e.neighbors <- [f];
    f.neighbors <- [d];
    [a;b;c;d;e;f]
    
    let g = init ()

    let rec pprint v = 
        Printf.printf "label:%d explored: %b f : %d leading : %d neighbors " v.label v.explored v.f v.leading;
        List.iter (fun x -> Printf.printf "%d " x.label) v.neighbors;
        print_newline ()
    
    let st_to_list s = 
        let rec aux res t = 
        if Stack.is_empty t then res
        else aux ((Stack.pop t)::res) t in
        aux [] s

    let rev g = 
        let starray = Array.init (List.length g) (fun x -> Stack.create ()) in
        let ael = Array.init (List.length g) (fun x -> create_node x) in
        let el = Array.to_list ael in
        List.iter (fun x -> (List.iter (fun y -> Stack.push ael.(x.label) starray.(y.label)) x.neighbors )) g;
        List.iter (fun x -> x.neighbors <- st_to_list starray.(x.label)) el; 
        el

    let scc g = 
        let rg = rev g and l = List.length g in
        let n = ref 1 in
        let res = Array.init l (fun x -> create_node x) in
        let rec dfs v = (
            v.explored <- true;
            List.iter (fun x -> if not x.explored then dfs x) v.neighbors;
            v.f <- !n;
            incr n) in
        List.iter (fun x -> if not x.explored then dfs x) rg;
        List.iter2 (fun v rv -> v.f <- rv.f) g rg;
        List.iter (fun x -> res.(l - x.f) <- x) g;
        let p2 = Array.to_list res in
        let lv = ref 0 in
        let rec dfs2 v = (
            v.explored <- true;
            List.iter (fun x -> if not x.explored then dfs2 x) v.neighbors;
            v.leading <- !lv;
        ) in
        List.iter (fun x -> if not x.explored then (lv := x.label; dfs2 x)) p2
    
    let res g = 
        let a = Array.init (List.length g) (fun x -> (x, 0)) in
        List.iter (
            fun e -> let (x,y) = a.(e.leading) in a.(e.leading) <- (x, y+1);
        ) g;
        Array.to_list a
    
    let load fname max =
        let inp = Array.init max (fun x -> create_node x) in
        let sts = Array.init max (fun x -> Stack.create ()) in
        let f = open_in fname in
            let rec aux () = 
                let a = try Some (Scanf.sscanf (input_line f) "%d %d " (fun x y -> x,y)) 
                with End_of_file -> None in
                match a with
                None -> ()
                |Some (x,y) -> (
                (*    if x mod 100 = 0 then Printf.printf "%d\n" x; flush stdout;*)
                    if y <> x then Stack.push inp.(y) sts.(x);
                    aux ())
                in
            aux ();
        close_in f;
        Array.iter (fun n -> inp.(n.label).neighbors <- st_to_list sts.(n.label)) inp;
        Array.to_list inp
    
    
    let tidy l = 
        let r = Array.make (List.length l) 0 and k = ref 0 in
        List.iter (fun (x,y) -> r.(!k) <- y; incr k) l;
        let cmp x y = if y > x then 1 else -1 in
        Array.sort cmp r;
        r
end

let t0 = Unix.time ();;
let g = Kosaraju.load "SCC.txt" 875715;;
Kosaraju.scc g;;
let r = Kosaraju.tidy (Kosaraju.res g);;

for i = 0 to 5 do
    Printf.printf "%d\t" r.(i)
done;;
Printf.printf "\n%f\n" (Unix.time () -. t0);;
