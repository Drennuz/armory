(* 1a *)
all_except_option ("hello", ["world", "miss"]) = NONE;
all_except_option ("hello", ["hello", "world"]) = SOME ["world"];
all_except_option ("Fred", ["Freddie", "Fred", "F"]) = SOME ["Freddie", "F"];

(* 1b *)
get_substitutions1 ([["Fred", "frederick"], ["Elizabeth", "Betty"], ["Freddie", "Fred", "F"]], "Fred") = ["frederick", "Freddie", "F"];
get_substitutions1 ([["Fred", "Frederick"], ["Jeff", "Jefferey"], ["Geoff", "Jeff", "Jefferey"]], "Jeff") = ["Jefferey", "Geoff", "Jefferey"];

(* 1c *)
get_substitutions2 ([["Fred", "frederick"], ["Elizabeth", "Betty"], ["Freddie", "Fred", "F"]], "Fred") = ["frederick", "Freddie", "F"];
get_substitutions2 ([["Fred", "Frederick"], ["Jeff", "Jefferey"], ["Geoff", "Jeff", "Jefferey"]], "Jeff") = ["Jefferey", "Geoff", "Jefferey"];

(* 1d *)
similar_names ([["Fred", "Frederick"], ["Elizabeth", "betty"], ["Freddie", "Fred", "F"]], {first="Fred", middle="W", last="Smith"}) = 
    [{first="Fred", middle="W", last="Smith"},
     {first="Frederick", middle="W", last="Smith"},
     {first="Freddie", middle="W", last="Smith"},
     {first="F", middle="W", last="Smith"}];

(* 2a *)
card_color (Spades, Jack) = Black;
card_color (Clubs, Jack) = Black;
card_color (Diamonds, Jack) = Red;
card_color (Hearts, Jack) = Red;

(* 2b *)
card_value (Spades, Num 8) = 8;
card_value (Spades, Ace) = 11;
card_value (Spades, King) = 10;

(* 2c *)
val cs = [(Clubs, Jack), (Diamonds, Queen), (Hearts, Num 10)];
remove_card (cs, (Clubs, Jack), IllegalMove) = [(Diamonds, Queen), (Hearts, Num 10)];

(* 2d *)
val cs2 = [(Clubs, Jack), (Spades, Jack)];
all_same_color cs2 = true;
all_same_color cs = false;

(* 2e *)
sum_cards cs2 = 20;
sum_cards cs = 30;

(* 2f *)
score (cs, 40) = 10;
score (cs, 10) = 60;
score (cs2, 30) = 5;
score (cs2, 10) = 15;


