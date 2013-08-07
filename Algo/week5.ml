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
