% CPSC 312 Prolog Project: Text 2 Pokedex
/*
    Authors: Justin Jao, Angela Li, Michael Cheung

    "Using English text queries, provide matching Pokemon individuals."
*/

:- use_module(facts).
:- use_module(api).
:- use_module(library(clpfd)).

% ONLINE Pokedex Workflow
api(Ans) :- 
    write("Welcome to the ONLINE Pokedex. Harness the power of the Internet! Give me a Pokemon to check the type of:\n"), flush_output(current_output),
    read_line_to_string(user_input, Input), string_lower(Input, Lowered_Input),
    lookup_pokemon(Lowered_Input, Ans).
api(Ans) :-
    write("Sorry, no known matching Pokemon were found!\n"),
    api(Ans).

% lookup_pokemon(Q,A) makes an API call\
lookup_pokemon(Q, A) :- get_dict4(Q, A).


% OFFLINE Pokedex Workflow
start(Ans) :-
    write("Welcome to the OFFLINE Pokedex. Ask me a query:\n"), flush_output(current_output),
    read_line_to_string(user_input, Input),
    split_string(Input, " -", " ,?.!-", Ln), % ignore punctuation
    find_pokemon(Ln, Ans).
start(Ans) :-
    write("Sorry, no known matching Pokemon were found!\n"),
    start(Ans).

% find_pokemon(Q,A) gives matching Pokemon A to question Q
find_pokemon(Q, A) :- parse_question(Q, A, C), test_individual(C).

% test_individual(L) determines a Pokemon satisfying all constraints in L
test_individual([]).
test_individual([H|T]) :- call(H), test_individual(T).

% parse_question(Q, A, C) is true if question Q contains constraints C on returned answer A
parse_question(Q, A, C) :-
    get_question(Q, End, A, C, []),
    member(End, [[], ["?"], ["."]]).

% get_question(Question,QR,Ind) is true if Query provides an answer about Ind to Question
get_question(["What","is" | L0], L1, Ind, C0, C1) :-
    aphrase(L0, L1, Ind, C0, C1).
get_question(["What" | L0], L2, Ind, C0, C2) :-
    noun_phrase(L0, L1, Ind, C0, C1),
    mp(L1, L2, Ind, C1, C2).
get_question(["What" | L0], L1, Ind, C0, C1) :-
    mp(L0, L1, Ind, C0, C1).

aphrase(L0, L1, E, C0, C1) :- noun_phrase(L0, L1, E, C0, C1).
aphrase(L0, L1, E, C0, C1) :- mp(L0, L1, E, C0, C1).

noun_phrase(L0,L4,Ind,C0,C4) :-
    det(L0,L1,Ind,C3,C4),
    adjectives(L1,L2,Ind,C2,C3),
    noun(L2,L3,Ind,C1,C2),
    omp(L3,L4,Ind,C0,C1).

det(["the" | L],L,_,C,C).
det(["a" | L],L,_,C,C).
det(["an" | L], L, _, C, C).
det(L,L,_,C,C).

adjectives(L0,L2,Ind,C0,C2) :-
    adj(L0,L1,Ind,C0,C1),
    adjectives(L1,L2,Ind,C1,C2).
adjectives(L,L,_,C,C).

adj(["heavy" | L], L, Ind, [heavy(Ind) | C], C).
adj(["light" | L], L, Ind, [light(Ind) | C], C).
adj([Typename,"type" | L], L, Ind, [facts:typename(Type, Typename), facts:type(Ind, Type) | C], C).

% heavy(P) is true if the Pokemon P is heavier than 100 kg
heavy(Ind) :-
    weightkg(Ind, W), 
    W > 100.

light(Ind) :-
    weightkg(Ind, W),
    W < 20.

noun(["pokemon" | L], L, Ind, [facts:pokemon(Ind)|C], C).
noun(["Pokemon" | L], L, Ind, [facts:pokemon(Ind)|C], C).
noun([N | L], L, Ind, C, C) :- name(Ind, N). % Parse fails if there is no entity for name

omp(L0, L1, E, C0, C1) :-
    mp(L0, L1, E, C0, C1).
omp(L, L, _, C, C).


mp(L0, L2, Subject, C0, C1) :-
    conj(L0, L1),
    reln_single(L1, L2, Subject, C0, C1).
mp(["that" | L0], L2, Subject, C0, C1) :-
    conj(L0, L1),
    reln_single(L1, L2, Subject, C0, C1).

mp(L0, L3, Subject, C0, C2) :-
    conj(L0, L1),
    reln(L1, L2, Subject, Object, C0, C1),
    aphrase(L2, L3, Object, C1, C2).
mp(["that" | L0], L3, Subject, C0, C2) :-
    conj(L0, L1),
    reln(L1, L2, Subject, Object, C0, C1),
    aphrase(L2, L3, Object, C1, C2).

conj(["has", "a" | L], L).
conj(["has" | L], L).
conj(["will", "be" | L], L).
conj(["is" | L], L).
conj(["with", "a" | L], L).
conj(["with", "an" | L], L).
conj(["with" | L], L).

reln_single(["weight", "greater", "than", Number, "lb" | L], L, Sub, [facts:weightlb(Sub, Val), number_codes(Num, Number), Val > Num | C ], C).
reln_single(["weight", "larger", "than", Number, "lb" | L], L, Sub, [facts:weightlb(Sub, Val), number_codes(Num, Number), Val > Num | C ], C).
reln_single(["weight", "bigger", "than" , Number , "lb" | L], L, Sub, [facts:weightlb(Sub, Val), number_codes(Num, Number), Val > Num | C ], C).
reln_single(["heavier", "than" , Number , "lb" | L], L, Sub, [facts:weightlb(Sub, Val), number_codes(Num, Number), Val > Num | C ], C).
reln_single(["weight", "less", "than" , Number , "lb" | L], L, Sub, [facts:weightlb(Sub, Val), number_codes(Num, Number), Val < Num | C ], C).
reln_single(["weight", "smaller", "than", Number, "lb" | L], L, Sub, [facts:weightlb(Sub, Val), number_codes(Num, Number), Val < Num | C ], C).
reln_single(["lighter", "than" , Number , "lb" | L], L, Sub, [facts:weightlb(Sub, Val), number_codes(Num, Number), Val > Num | C ], C).

reln_single(["weight", "greater", "than", Number, "kg" | L], L, Sub, [facts:weightkg(Sub,Val), number_codes(Num, Number), Val > Num | C], C).
reln_single(["weight", "larger", "than", Number, "kg"| L], L, Sub, [facts:weightkg(Sub, Val), number_codes(Num, Number), Val > Num | C ], C).
reln_single(["weight", "bigger", "than", Number, "kg" | L], L, Sub, [facts:weightkg(Sub, Val), number_codes(Num, Number), Val > Num | C ], C).
reln_single(["heavier", "than" , Number, "kg" | L], L, Sub, [facts:weightkg(Sub, Val), number_codes(Num, Number), Val > Num | C ], C).
reln_single(["weight", "less", "than", Number, "kg" | L], L, Sub, [facts:weightkg(Sub, Val), number_codes(Num, Number), Val < Num | C ], C).
reln_single(["weight", "smaller", "than", Number, "kg" | L], L, Sub, [facts:weightkg(Sub, Val), number_codes(Num, Number), Val < Num | C ], C).
reln_single(["lighter", "than", Number, "kg" | L], L, Sub, [facts:weightkg(Sub, Val), number_codes(Num, Number), Val < Num | C ], C).

reln_single(["height", "greater", "than",  Number, "m" | L], L, Sub, [facts:height_m(Sub, Val), number_codes(Num, Number), Val > Num | C ], C).
reln_single(["height", "larger", "than" , Number, "m" | L], L, Sub, [facts:height_m(Sub, Val), number_codes(Num, Number), Val > Num | C ], C).
reln_single(["height", "bigger", "than" , Number, "m" | L], L, Sub, [facts:height_m(Sub, Val), number_codes(Num, Number), Val > Num | C ], C).
reln_single(["taller", "than" , Number, "m" | L], L, Sub, [facts:height_m(Sub, Val), number_codes(Num, Number), Val > Num | C ], C).
reln_single(["height", "less", "than" , Number, "m" | L], L, Sub, [facts:height_m(Sub, Val), number_codes(Num, Number), Val < Num | C ], C).
reln_single(["height", "smaller", "than" , Number, "m" | L], L, Sub, [facts:height_m(Sub, Val), number_codes(Num, Number), Val < Num | C ], C).
reln_single(["shorter", "than" , Number, "m" | L], L, Sub, [facts:height_m(Sub, Val), number_codes(Num, Number), Val < Num | C ], C).

reln_single(["national", "number", "greater", "than",  Number | L], L, Sub, [facts:national_num(Sub, Val), number_codes(Num, Number), Val > Num | C ], C).
reln_single(["national", "number", "larger", "than",  Number | L], L, Sub, [facts:national_num(Sub, Val), number_codes(Num, Number), Val > Num | C ], C).
reln_single(["national", "number", "bigger", "than",  Number | L], L, Sub, [facts:national_num(Sub, Val), number_codes(Num, Number), Val > Num | C ], C).
reln_single(["national", "number", "less", "than" , Number | L], L, Sub, [facts:national_num(Sub, Val), number_codes(Num, Number), Val < Num | C ], C).
reln_single(["national", "number", "smaller", "than" , Number | L], L, Sub, [facts:national_num(Sub, Val), number_codes(Num, Number), Val < Num | C ], C).

reln(["strong", "against" | L], L, Sub, Obj, [strong_against(Sub, Obj) | C], C).
reln(["good", "against" | L], L, Sub, Obj, [strong_against(Sub, Obj) | C], C).

reln(["weak", "against" | L], L, Sub, Obj, [weak_against(Sub, Obj) | C], C).
reln(["bad", "against" | L], L, Sub, Obj, [weak_against(Sub, Obj) | C], C).

strong_against(A, B) :- type(A, Type1), type(B, Type2), facts:type_adv(Type1, Type2), dif(Type1, Type2).
weak_against(A, B) :- type(A, Type1), type(B, Type2), facts:type_adv(Type2, Type1), dif(Type1, Type2).