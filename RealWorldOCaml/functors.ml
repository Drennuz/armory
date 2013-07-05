module type Comparable =
    sig
        type t
        val compare : t -> t -> int
    end

module type Interval_out = 
    sig
        type t
        type endpoint
        val create : endpoint -> endpoint -> t
        val is_empty : t -> bool
        val contains : t -> endpoint -> bool
        val intersect : t -> t -> t
    end

module MakeInterval(Endpoint:Comparable) : (Interval_out with type endpoint = Endpoint.t)= 
    struct
        type endpoint = Endpoint.t
        type t = Empty | Interval of Endpoint.t * Endpoint.t

        let create low high = 
            if Endpoint.compare low high >= 0 then Empty
            else Interval(low,high)

        let is_empty = function
            Empty -> true
            |Interval _ -> false

        let contains t x = match t with
            Empty -> false
            |Interval(l, h) -> 
                if Endpoint.compare l x <=0 && Endpoint.compare h x >= 0 then true else false

         let intersect s1 s2 = 
            let min x y = if Endpoint.compare x y < 0 then x else y and
            max x y = if Endpoint.compare x y > 0 then x else y in
            match s1, s2 with
            Empty, _ | _, Empty -> Empty
            |Interval(l1, h1), Interval(l2, h2) -> Interval(max l1 l2, min h1 h2)
    end

