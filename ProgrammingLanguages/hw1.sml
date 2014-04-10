(* #1, return true if date1 come strictly before date2 *)
fun is_older (date1 : int * int * int, date2 : int * int * int) = 
    let 
        val y1 = #1 date1;
        val y2 = #1 date2;
        val m1 = #2 date1;
        val m2 = #2 date2;
        val d1 = #3 date1;
        val d2 = #3 date2
    in
        if y1 < y2 then true
        else if y1 > y2 then false
        else
            if m1 < m2 then true
            else if m1 > m2 then false
            else
                if d1 < d2 then true
                else false
    end

(* 2. how many days are in the month *)
fun number_in_month (dates : (int * int * int) list, month: int) = 
    let val ct = 0 
    in
        if null dates then ct
        else
            let val tl_ct = number_in_month ((tl dates), month) 
            in
                if #2 (hd dates) = month then ct + 1 + tl_ct
                else ct + tl_ct
            end
    end

(* 3. *)
fun number_in_months (dates : (int * int * int) list, months: int list) = 
    let val ct = 0 
    in
        if null months then ct
        else ct + number_in_month(dates, hd months) + number_in_months(dates, tl months)
    end

(* 4 return list of dates in month, in original order *)
fun dates_in_month (dates : (int * int * int) list, month : int) = 
    if null dates then []
    else
        let val date = hd dates 
        in
            if #2 date = month then date :: (dates_in_month ((tl dates), month))
            else dates_in_month((tl dates), month)
        end

(* 5 *)
fun dates_in_months (dates: (int * int * int) list, months : int list) = 
    if null months then []
    else
        let val m = hd months 
        in
            (dates_in_month (dates, m)) @ (dates_in_months (dates, tl months))
        end

(* 6 no checking on list length *)
fun get_nth (strs : string list, n : int) = 
    if n = 1 then hd strs
    else
        get_nth (tl strs, n-1)

(* 7 *)
fun date_to_string (date : int * int * int) = 
    let 
        val months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        val month = #2 date;
        val year = #1 date;
        val day = #3 date
    in
        get_nth (months, month) ^ " " ^ Int.toString day ^ ", " ^ Int.toString year
    end

(* 8 *)
fun number_before_reaching_sum (sum : int, l: int list) = 
    let val h = hd l
    in
        if h >= sum then 0
        else 1 + number_before_reaching_sum (sum - h, tl l)
    end

(* 9 *)
fun what_month (day : int) = 
    let
        val months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    in
        1 + number_before_reaching_sum (day, months)
    end

(* 10 *)
fun month_range (day1 : int, day2: int) = 
    let
        val m1 = what_month day1;
        val m2 = what_month day2;
        fun build_range (low:int, high : int) = 
            if low > high then []
            else low :: build_range (low+1, high)
    in
        if day1 > day2 then []
        else build_range (m1, m2)
    end

(* 11 *)
fun oldest (dates : (int * int * int) list) = 
    if null dates then NONE
    else
        let 
            val tl_oldest = oldest (tl dates);
            val day1 = hd dates
        in
            if isSome tl_oldest then 
                if is_older (day1, valOf tl_oldest) then SOME day1
                else tl_oldest
            else SOME day1
        end

(* for challenge problems *)
fun in_list (l : int list, e : int) = 
    if null l then false
    else
        if e = hd l then true
        else in_list (tl l, e)

fun del_dup (l : int list) = 
    if null l then []
    else
        let
            val tl_unique = del_dup (tl l);
            val h = hd l
        in
            if in_list (tl_unique, h) then tl_unique
            else h :: tl_unique
        end

fun number_in_months_challenge (dates : (int * int * int) list, months : int list) = 
    let 
        val unique_months = del_dup months 
    in
        number_in_months (dates, unique_months)
    end

fun dates_in_months_challenge (dates: (int*int*int) list, months: int list) = 
    let
        val unique_months = del_dup months
    in
        dates_in_months (dates, unique_months)
    end

fun get_nth_int (l : int list, n: int) = 
    if n = 1 then hd l
    else get_nth_int (tl l, n-1)

fun reasonable_date (date : int * int * int) = 
    let
        val day = #3 date;
        val month = #2 date;
        val year = #1 date;
        val days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        val days_leap = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        fun check_day (l:int list, m : int, d : int) = 
            let val max_day = get_nth_int (l, m) in
            if d >= 1 andalso d <= max_day then true else false
            end
    in
        if year <=0 orelse month < 1 orelse month > 12 then false
        else
            if year mod 400 = 0 orelse (year mod 4 = 0 andalso year mod 100 <> 0)
            then (* leap year *)
                check_day (days_leap, month, day)
            else
                check_day (days, month, day)
    end
