[Syntax cheatsheet](http://www.ocamlpro.com/files/ocaml-lang.pdf)

    open Core.Std;;

    let even (x:int) : bool = x mod 2 = 0;; (* explicit type annotation optional *)
    
    let a_tuple = (3., "hello");; (* tuples allow different types *)
    let (x,y) = a_tuple;; (* x: float 3. y:string = "hello" *)

    let a_list = [1;2;3;4];; (* list elements must be of the same type *)
    5 :: a_list;; (* adding to the beginning *)

    let div x y = if y = 0 then None else Some (x/y);; (* demonstrate Options *)
    
    type point2d = {x:float; y:float}

    List.exists [1;2;3] (fun x -> x mod 2 = 0);; (* anonymous function *)

    let a = ref 0;; (* refs, equal to {contents = 0} *)

---

### Appendix A

* All files installed under `~/.opam/`
* `ocaml switch list`: browse available compilers

### Prolog

* Statically typed functional programming language

### I. Language concepts

#### 1 A Guided Tour

* Options: `None`, `Some value`, used to encode some value that might not be there. 

* Imperative programming:

     Computations are structured as sequence of instructions that operate by modifying states as they go.

     Mutable data structure: ref, arrays, hashtable, records with `mutable` declaration


* Build:

     Create `_tags` file: `true:package(core), thread`

     `ocamlbuild -use-ocamlfind sum.native`

