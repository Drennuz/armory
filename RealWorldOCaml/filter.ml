(* benchmarking different implementations for Array.filter *)

(* to build: 
include _tags file: true:package(core, core_bench), thread
ocamlbuild -use-ocamlfind filter.byte
*)

(* 1. use Array.append  *)
module Filter = 
struct
    (* append one-element array *)
    let filter_append f a  = 
        let length = Array.length a in
        let rec aux i res = 
            if i < length then 
                if f a.(i) then aux (i+1) (Array.append res [|a.(i)|])
                else aux (i+1) res
            else
                res
        in aux 0 [||]

    (* 2. convert to list first*)

    let filter_list f a = 
        let l = Array.to_list a in
        let fl = List.filter f l in
        let length = List.length fl in
            let res = Array.make length a.(0) and j = ref 0 in
            for i = 0 to Array.length a - 1 do
                if f a.(i) then (res.(!j) <- a.(i); incr j)
            done;
            res
    
    (* use a stack *)
    let filter_stack f a = 
        let st = Stack.create () in
        for i = 0 to Array.length a - 1 do
            if f a.(i) then Stack.push a.(i) st
        done;
        let stl = Stack.length st in
        let res = Array.make stl a.(0) in
            for i = 0 to stl - 1 do
                res.(stl - 1 - i) <- Stack.pop st
            done;
        res

end;;

(* Core  *)
open Core.Std_kernel;;

(* test case *)

Random.self_init ()
let max = 1000
let n = 100000 (* size of array *)
let a = Array.create n 0;;

for i = 0 to n-1 do
    a.(i) <- Random.int max
done

let f x = x mod 2 = 0;;

(* benchmark *)

open Core_bench.Std;;

[ Bench.Test.create ~name:"append" (fun () -> ignore (Filter.filter_append f a));
  Bench.Test.create ~name:"to_list" (fun () -> ignore (Filter.filter_list f a));
  Bench.Test.create ~name:"stack" (fun () -> ignore (Filter.filter_stack f a));
  Bench.Test.create ~name:"Core" (fun () -> ignore (Array.filter f a))]
|> Bench.bench;;
