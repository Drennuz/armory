(* algorithms from notes *)

(* karatsuba multiplication *)
let ndigits n = 
    let rec aux i m = 
        if m < 10 then i
        else aux (i+1) (m/10)
    in aux 1 n;;

let decomp n = 
    let m = (ndigits n) / 2 in 
    let pf = int_of_float (10. ** float_of_int m) in
    let a = n / pf in
    (pf, a, n - a * pf)

let rec karatsuba x y = 
        if x < 10 && y < 10 then x * y 
        else let (p1, a, b) = decomp x and (p2, c, d) = decomp y in
        let f1 = karatsuba a d  and f2 = karatsuba a c and f3 = karatsuba b d  and f4 = karatsuba b c in
        p1 * p2 * f2 + p1 * f1 + p2 * f4 + f3

