##### `matrix.ml`
An OCaml module for matrix calculations, supporting addition / subtraction / slicing / scaling / multiplication. 

Signature:

```ocaml
module Matrix :
    sig
        val slice : 'a array array -> int * int -> int * int -> 'a array array
        (* slice m (x, xlen) (y, ylen) returns a xlen * ylen matrix, starting from (x,y) in the original matrix m *)

        val merge_matrix :
            float array array ->float array array ->float array array ->float array array ->float array array 
        (* merge_matrix m00 m10 m01 m11 merge 4 matrices into one. Empty matrices allowed *)

        val add : float array array -> float array array -> float array array
        val scale : float array array -> float -> float array array
        (* scale m k multiplies each element in matrix m by k *)

        val subtract : float array array -> float array array -> float array array
        val mult : float array array -> float array array -> float array array
        (* mult m1 m2 use the straight-forward multiplication *)

        val mult_strassen : float array array -> float array array -> float array array
        (* mult_strassen m1 m2 uses Strassen's algorithm for multiplying two matrices *)

    end
```
