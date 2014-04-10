is_older ((2013,1,1), (2014,1,1)) = true;
is_older ((2014,1,1), (2013,1,1)) = false;
is_older ((2013,1,1), (2013,2,1)) = true;
is_older ((2013,2,1), (2013,1,1)) = false;
is_older ((2013,1,1), (2013,1,2)) = true;
is_older ((2013,1,2), (2013,1,1)) = false;
is_older ((2013,1,1), (2013,1,1)) = false;

number_in_month ([(2013,1,1), (2013,1,3), (2013,2,3)], 1) = 2;
number_in_month ([(2013,1,1), (2013,3,1)], 2) = 0;

number_in_months ([(2013,1,1), (2013,2,1)], [1,2]) = 2;
number_in_months ([(2013,1,1), (2013,2,1)], [1]) = 1;
number_in_months ([(2013,1,1), (2013,2,1)], [3]) = 0;
number_in_months ([(2013,1,1), (2013,2,1)], []) = 0;

val d1 = (2013, 1, 1);
val d2 = (2013, 2, 1);
val d3 = (2013, 3, 1);
val d4 = (2013, 2, 20);

dates_in_month ([d1,d2,d3, d4], 2) = [(2013, 2, 1), (2013, 2, 20)];

dates_in_months ([d1,d2,d3,d4], [2,3]) = [d2,d4,d3];

get_nth (["abc","d","e"], 3) = "e";

date_to_string ((2013,1,20)) = "January 20, 2013";

number_before_reaching_sum (10, [20,30]) = 0;
number_before_reaching_sum (10, [2,3,8]) = 2;
number_before_reaching_sum (10, [2,3,5,8]) = 2;

what_month 31 = 1;
what_month 365 = 12;
what_month 32 = 2;

month_range (1, 365) = [1,2,3,4,5,6,7,8,9,10,11,12];
month_range (1, 28) = [1];
month_range (3, 2) = [];

oldest [] = NONE;
oldest ([(2013,1,1), (2010,2,1)]) = SOME (2010,2,1);

number_in_months_challenge ([(2013,1,1), (2013,2,1)], [1,2, 2, 2, 5]) = 2;
number_in_months_challenge ([(2013,1,1), (2013,2,1)], [1, 1, 1, 3]) = 1;
number_in_months_challenge ([(2013,1,1), (2013,2,1)], [3, 3, 3]) = 0;
number_in_months_challenge ([(2013,1,1), (2013,2,1)], []) = 0;

dates_in_months_challenge ([d1,d2,d3,d4], [2,3,3,2]) = [d3, d2, d4];

reasonable_date (0,1,1) = false;
reasonable_date (1952, 0, 1) = false;
reasonable_date (1952, 13, 2) = false;
reasonable_date (1989, 2, 31) = false;
reasonable_date (2000, 2, 29) = true;
reasonable_date (1800, 2, 29) = false;
reasonable_date (1999, 2, 28) = true;
reasonable_date (1996, 2, 29) = true;
