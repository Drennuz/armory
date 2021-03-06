### Files

`filter.ml`: Different implementations of Array.filter and benchmarking script.

* * *

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

* value restriction: only immutable values (numbers | char | function) can have true polymorphism. Function application | mutable data structure is not.

* comma is right-associative: `let x=1 in x+1, let y=2 in y+1,4` evals to `int * (int * int) = (2, (3, 4))`
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

#### 5 Records

* Record patterns are irrefutable, need not to be complete

* `#warnings "+9"`, enable warning for incomplete record pattern matching

* First-class fields: confused

#### 6 Variants

* Index:
    * Combining records and variants
    * Variants and recursive data structures

* Syntax: `type enum = Basic of int * int | White`

* Avoid catch-all cases in pattern matching 

* Record: shared data; Variance: disjunction

#### 7 Exceptions

* error-aware return types(Core): Options, Result,  Error

* Exceptions: `exception`, `raise` (type exn -> 'a, can throw anywhere in a program); `assert`

* Handling exceptions: `try...with Exp...`

#### 9 Functors

* Functors: function from modules to modules
    
    * Usage: extending modules

* functors require explicit type annotation

#### 11 Objects

* Objects and classes: dynamic binding; modules: static scoping. 

* Modules can declare types, objects cannot

#### I12 Module system

#### Async

* Useful functions:
    * Reader.file_contents; Writer.save;
    * named parameters: ~
    * String.split
    * >>= : pipe Deferred.t to fun t -> Deferred.t; Deferred.bind
    * >>| : pipe Deferred.t to fun a -> b; Deferred.map
    * return: wrapping to Deferred value

#### I10 Inputs and Outputs
* open_out, open_in, close_out, close_in
* output_*
* seek, pos, length
* flush: buffered I/O
* String buffers:
* printf
    * Printf.fprintf | printf | sprintf | bprintf
    * Scanf.scanf | sscanf | fscanf; takes in function
    * [-] [width].[precision] specifier; width/precision can be specified as *

#### I11 File system

* can define transparent type in interface, implementation must be the same.
* open: expose a namespace, prefer fully qualified name
* debug: ocamlc -c -g; ocamldebug ./exec
    * run; step; next; goto; list; break; print
* ocamlc -i f.ml # compiler produce interface

#### 13 Map and Hashtbl

* Map: key-value pairs 
    * assoc lists: linear time
    * map: log(n); hashtbl: constant time
    * Comparator.Make functor : take in a module, return a Core_kernel.Comparator.t
        * t, compare, t_of_sexp, sexp_of_t
        * Comparator.Poly.comparator; Map.Poly.of_alist_exn
    * useful functions: Map.of_alist_exn ~comparator alist; 
    * Map.to_tree; almost same performance as map 

* Tree:
    * map without comparator (still in type; "phantom type parameter")

* Sets: key only; no duplicates
    * Int.Set.of_list 

* Hashtables key-value pairs
    * mutable
    * pass in hashable in Hashtbl.create
    * Int.Table.create (); Hashtbl.create ~hashable: Int.Hashable

* choose:
    * Map --> functional; Hashtbl --> imperative
    * Hashtbl: performance win on updates/lookups
    * map: keep multiple related key/value pairs, more efficient

* Bench.make_command; Command.run 

#### 20 memory representation of values

* type checking at compile time
* uniform memory representation: int or pointer to int (bottom single bit tag)
* basic unit of allocation on heap: value (head + data) (int are never allocated on heap)
    * Obj.is_int (Obj.repr []); Obj.is_block (Obj.repr [1;2])
    * Obj.tag; Obj.double_tag
    * optimization for float arrays
    * List: Head | Cons (pointer to rest)
    * marker for GC (opaque or not)

#### 21 garbage collector

* generational:
    * for small variables in use for a short time
    * small minor heap | large major heap
* fast minor heap: (2 mb; Core: 8mb)
    * constant time allocating
    * gc: copy-collecting live blocks to major heap
* major heap:
    * allocate: free-list; expansion; large values directly on major heap 
    * gc: mark-and-sweep
        mark -> sweep -> compact
        mark: color bits; incrementally in slice; DFS
    * write barrier: may be slower than immutable data structure

#### 22 Compiler frontend

* parsing -> syntax extension -> untyped AST -> typed AST 
* ocp-indent | ocamldoc
* preprocessing: camlp4
* type checking : 
    * auto type inference
        * Hindley-Milner algorithm
    * module
    * subtyping
