(* heap implementation by array *)
(* single element first *)
open Core.Std

module type ORDERED = sig
    type t
    val compare : t -> t -> bool (* true if a < b *)
end

module type Heap_intf = sig
    type elem
    val of_array : elem array -> unit
    val insert : elem -> elem array -> elem array
    val getMin : elem array -> elem * elem array
end

module Heap (Elem : ORDERED) : (Heap_intf with type elem = Elem.t) = struct
    type elem = Elem.t
    
    let ceil2 a = if a mod 2 = 0 then a / 2 else a/2 + 1
    let parent i = (ceil2 i) - 1
    
    (* heapify is bubble-down *)
    let rec heapify a i = 
        let l = Array.length a and imin = ref i and cmin = ref a.(i) in
        let left = 2*i + 1 in let right = left + 1 in
        begin
            if left < l && Elem.compare a.(left) !cmin then (imin := left; cmin := a.(left));
            if right < l && Elem.compare a.(right) !cmin then (imin := right; cmin := a.(right));
            if !imin <> i then (Array.swap a i !imin; heapify a !imin);
        end
    
    let rec bubbleup a i = 
        let p = parent i in
        if p >= 0 then
            begin
                if Elem.compare a.(i) a.(p) then (Array.swap a i p; bubbleup a p);
            end

    let of_array a = 
        let l = Array.length a in
        for i = l/2 downto 0 do
            heapify a i
        done
     
    (* insert to last then bubble up *)
    let insert e a = 
        let l = Array.length a in
        let res = Array.init (l+1) ~f:(fun i -> if i < l then a.(i) else e) in
        bubbleup res l;
        res
    
    (* bring last elem to root *)
    let getMin a = 
        let emin = a.(0) and l = Array.length a in
        let res = Array.init (l-1) ~f:(fun i -> if i = 0 then a.(l-1) else a.(i)) in
        heapify res 0;
        (emin, res)

end

module Myint = struct
    type t = int
    let compare a b = a < b
end

module IHeap = Heap(Myint)

module Dijkstra = struct

    type vertex = {mutable visited : bool; label : string; mutable dist : int; neighbors : (int * int) list}
    type graph = vertex list
    type set_vertex = string * int (* label, score *)
    
    let build fname = 
        let lines = In_channel.read_lines fname in
        let rec aux res l = match l with
        [] -> ((List.last_exn res).dist <- 0; List.rev res)
        |h :: t -> 
            begin
                let split = String.split ~on:'\t' h in
                let label = Option.value_exn (List.hd split) and
                    neighbors = Option.value_exn (List.tl split) in
                let neighbors = List.filter neighbors (fun s -> String.length s > 0) in
                let neighbors = List.map neighbors ~f:(fun x -> Scanf.sscanf x "%d,%d" (fun x y -> x,y)) in
                aux (({visited = false; label = label; dist = 1000000; neighbors = neighbors})::res) t
            end
        in aux [] lines
    
    (* find min element *)
    let findMin l = List.fold_left ~init:(0, 100000) ~f:(fun (init_l, init_d) (e_l, e_d) -> if init_d < e_d then (init_l, init_d) else (e_l, e_d)) l
    
    (* step function; update dist; return new frontier *)
    let step g f = 
        let (min_l, min_d) = findMin !f in
        if min_l = 0 then () (* empty frontier *)
        else begin
            let e = List.nth_exn g (min_l-1) in
            e.dist <- min_d; e.visited <- true;(* update distance *)
            Printf.printf "%d %d\n" min_l e.dist;
            f := List.Assoc.remove !f min_l;
            List.iteri e.neighbors ~f:(fun i (label, dist) -> 
                if not (List.nth_exn g (label-1)).visited then (
                    if not (List.Assoc.mem !f label) then f := List.Assoc.add !f label (min_d + dist)
                    else if (List.Assoc.find_exn !f label) > (dist + min_d) then f := List.Assoc.add !f label (min_d + dist)
            ))
        end

    (* main loop *)
    let main fname = 
        let g = build fname in
        let f = ref (List.hd_exn g).neighbors in
        for i = 1 to (List.length g) do step g f done;
        g

    let required = [7;37;59;82;99;115;133;165;188;197]
end
