(* Dan Grossman, CSE341 Spring 2013, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)

fun all_except_option (s, l) = 
    case l of
    [] => NONE
    |h::t => if same_string (s, h) then SOME t
             else 
                case (all_except_option (s, t)) of
                NONE => NONE
                |SOME l2 => SOME (h :: l2)

fun get_substitutions1 (sl, s) = 
    case sl of
    [] => []
    |hl :: tl => case (all_except_option (s, hl)) of
        NONE => get_substitutions1 (tl, s)
        |SOME l => l @ (get_substitutions1 (tl, s))

fun get_substitutions2 (sl, s) = 
    let fun aux (acc, l) = 
        case l of
        [] => acc
        |hl :: tl => case (all_except_option (s, hl)) of
            NONE => aux (acc, tl)
            |SOME l2 => aux (acc @ l2, tl)
    in
        aux ([], sl)
    end

fun similar_names (substitutions, {first=f, middle=m, last=last}) = 
    let val firsts = f :: (get_substitutions2 (substitutions, f))
    in
        let fun aux l = case l of
            [] => []
            |h :: t => {first = h, middle = m, last = last} :: (aux t)
        in aux firsts
        end
    end

(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)

(* 2a *)
fun card_color (suit, rank) = 
    case suit of
        Clubs => Black
        |Spades => Black
        |_ => Red

(* 2b *)
fun card_value (suit, rank) = 
    case rank of
        Num i => i
        |Ace => 11
        |_ => 10

fun card_value_ace_one (suit, rank) = 
    case rank of
        Num i => i
        |Ace => 1
        |_ => 10
(* 2c *)
fun remove_card (cs, c, e) = 
    case cs of
    [] => raise e
    |h :: t => if h = c then t
        else remove_card (t, c, e)
  
(* 2d *)
fun all_same_color cs = 
    case cs of
    [] => true
    |h :: [] => true
    | h1 :: (h2 :: t) => if card_color h1 = card_color h2 then all_same_color (h2 ::t)
        else false

(* 2e *)
fun sum_cards cs = 
    let fun aux (acc, l) = 
        case l of
        [] => acc
        |h :: t => aux (acc + card_value h, t)
    in aux (0, cs)
    end

fun sum_cards_ace_one cs = 
    let fun aux (acc, l) = 
        case l of
        [] => acc
        |h ::t => aux (acc + card_value_ace_one h, t)
    in aux (0, cs)
    end

(* 2f *)
fun score (cs, goal) = (* cs is the held-cards *)
    let val sum = sum_cards cs in
        let val pre_score = if sum > goal then 3 * (sum - goal) else (goal - sum) in
            if all_same_color cs then pre_score div 2
            else pre_score
        end
    end

fun score_ace_one (cs, goal) = 
    let val sum = sum_cards_ace_one cs in
        let val pre_score = if sum > goal then 3 * (sum - goal) else (goal - sum) in
            if all_same_color cs then pre_score div 2
            else pre_score
        end
    end

(* 2g *)
fun officiate (card_list, move_list, goal) = 
    let fun aux (card_list, held_cards, move_list) = 
        case move_list of
        [] => score (held_cards, goal)
        |Discard card :: move_t => aux (card_list, remove_card (held_cards, card, IllegalMove), move_t)
        |Draw :: move_t => case card_list of
            [] => score (held_cards, goal)
            |card ::card_t => 
                let val post_draw_sum = sum_cards (card :: held_cards) 
                in
                if post_draw_sum > goal then score (card :: held_cards, goal) else aux (card_t, card :: held_cards, move_t)
                end
    in
        aux (card_list, [], move_list)
    end

(* challenge problems *)

fun score_challenge (cs, goal) =  
    let val score1 = score (cs, goal);
        val score2 = score_ace_one (cs, goal)
    in if score1 < score2 then score1 else score2
    end

fun officiate_challenge (card_list, move_list, goal) = 
    let fun aux (card_list, held_cards, move_list) = 
        case move_list of
        [] => score_challenge (held_cards, goal)
        |Discard card :: move_t => aux (card_list, remove_card (held_cards, card, IllegalMove), move_t)
        |Draw :: move_t => case card_list of
            [] => score_challenge (held_cards, goal)
            |card ::card_t => 
                let val post_draw_sum = sum_cards (card :: held_cards) 
                in
                if post_draw_sum > goal then score_challenge (card :: held_cards, goal) else aux (card_t, card :: held_cards, move_t)
                end
    in
        aux (card_list, [], move_list)
    end

fun revlist l = 
    let fun aux (acc, l) = 
        case l of
        [] => acc
        |h :: t => aux (h::acc, t)
    in aux ([], l)
    end

(* fun careful_player (card_list, goal) =  *)

