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

    List.map ~f: (fun x -> x + 1) [2;4;6];; (* named arguments *)

    let div x = function 
        0 -> None
        |y -> Some (x/y);; (* currying; pattern matching using function *)

    let concat ?(sep="") x y = x ^ sep ^ y;; (* optional arguments with default value *)

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

#### 2 Variables and Funtions

* Variables are typically immutable.

* Currying: transform a multi-argument function into a chain of single-argument functions, allow partial application. `->`s are right-associative.

* Declare function with `function`: built-in pattern matching

* Labeled arguments; Optional arguments, must call with label, erased after the first positional argument after optional argument is passed in. Optional arguments at last position cannot be erased at all.

* OCaml completes missing `else` with `unit`

#### 3 Lists and Patterns

* Lists are implemented as singly-linked list.

* Pattern match is a performance win most of the time.

* [List](https://ocaml.janestreet.com/ocaml-core/latest/doc/core_kernel/Core_list.html)

* Tail calls don't require a stack frame due to tail optimization (reuse caller's stack)

     The invocation is a tail call when the caller doesn't do anything with the value returned by the callee except to return it.

#### 4 Files, Modules and Programs

* `_tags` file: specify which compilation options are used for which files for `ocamlbuild`

* `which`: Unix command to identify location of executables

* In general, production executables usually built with native code compiler.

* `ocamlbuild -use-ocamlfind freq.byte`

* Module: `module <name> : <signature> = <implementation>`

* module signature: `module type <name> = sig ... end`

* module implementation: `module <name> = struct ... end`

* `open`: add the contents of the module to environment. Generally good style to keep `open` to minimum.

* `include`: extend a module
