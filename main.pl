% CPSC 312 Prolog Project: Text 2 Pokedex
/*
    Authors: Justin Jao, Angela Li, Michael Cheung

    "Using English text queries, provide matching Pokemon individuals."
*/

:- use_module(facts).
:- use_module(library(clpfd)).

start(Ans) :-
    write("Welcome to the Pokedex. Ask me a query:\n"), flush_output(current_output),
    read_line_to_string(user_input, Input),
    split_string(Input, " -", " ,?.!-", Ln), % ignore punctuation
    find_pokemon(Ln, Ans).
start(Ans) :-
    write("Sorry, no more matching Pokemon were found!\n"),
    start(Ans).

% find_pokemon(Q,A) gives matching Pokemon A to question Q
find_pokemon(Q, A) :- parse_question(Q, A, C), test_individual(C).

% test_individual(L) determines a Pokemon satisfying all constraints in L
test_individual([]).
test_individual([H|T]) :- call(H), test_individual(T).

% get_constraints_from_question(Q,A,C) is true if C is the constraints on A to infer question Q
parse_question(Q,A,C) :-
    get_question(Q,End,A,C,[]),
    member(End,[[],["?"],["."]]).

% get_question(Question,QR,Ind) is true if Query provides an answer about Ind to Question
% get_question(["Is" | L0],L2,Ind,C0,C2) :-
%     noun_phrase(L0,L1,Ind,C0,C1),
%     mp(L1,L2,Ind,C1,C2).
get_question(["What","is" | L0], L1, Ind,C0,C1) :-
    aphrase(L0,L1,Ind,C0,C1).
get_question(["What" | L0],L2,Ind,C0,C2) :-
    noun_phrase(L0,L1,Ind,C0,C1),
    mp(L1,L2,Ind,C1,C2).
get_question(["What" | L0],L1,Ind,C0,C1) :-
    mp(L0,L1,Ind,C0,C1).

aphrase(L0, L1, E, C0, C1) :- noun_phrase(L0, L1, E,C0,C1).
aphrase(L0, L1, E, C0, C1) :- mp(L0, L1, E,C0,C1).

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

adj(["heavy" | L],L,Ind, [heavy(Ind)|C],C).
adj(["light" | L], L, Ind, [light(Ind)|C], C).
adj([Typename,"type" | L],L,Ind, [facts:typename(Type, Typename), facts:type(Ind, Type) |C],C).

% heavy(P) is true if the Pokemon P is heavier than 100 kg
heavy(Ind) :-
    weightkg(Ind, W), 
    W > 100.

light(Ind) :-
    weightkg(Ind, W),
    W < 20.

noun(["pokemon" | L],L,Ind, [facts:pokemon(Ind)|C],C).
noun(["Pokemon" | L],L,Ind, [facts:pokemon(Ind)|C],C).
noun([N | L], L, Ind, C,C) :- name(Ind, N). % Parse fails if there is no entity for name

omp(L0,L1,E,C0,C1) :-
    mp(L0,L1,E,C0,C1).
omp(L,L,_,C,C).


mp(L0,L2,Subject,C0,C2) :-
    reln_single(L0,L1,Subject,C0,C1).
mp(["that"|L0],L2,Subject,C0,C2) :-
    reln_single(L0,L1,Subject,C0,C1).
mp(["with", "a"|L0],L2,Subject,C0,C2) :-
    reln_single(L0,L1,Subject,C0,C1).
mp(["with", "an"|L0],L2,Subject,C0,C2) :-
    reln_single(L0,L1,Subject,C0,C1).
mp(["with"|L0],L2,Subject,C0,C2) :-
    reln_single(L0,L1,Subject,C0,C1).

% mp(L0,L2,Subject,C0,C2) :-
%     reln(L0,L1,Subject,Object,C0,C1),
%     aphrase(L1,L2,Object,C1,C2).
% mp(["that"|L0],L2,Subject,C0,C2) :-
%     reln(L0,L1,Subject,Object,C0,C1),
%     aphrase(L1,L2,Object,C1,C2).
% mp(["with"|L0],L2,Subject,C0,C2) :-
%     reln(L0,L1,Subject,Object,C0,C1),
%     aphrase(L1,L2,Object,C1,C2).

reln_single(["weight", "greater", "than", Number, "lb" | L],L,Sub,[facts:weightlb(Sub,Val), number_codes(Num, Number), Val > Num | C ], C).
reln_single(["weight", "larger", "than", Number, "lb" | L],L,Sub,[facts:weightlb(Sub,Val), Val > Number | C ], C).
reln_single(["weight", "bigger", "than" , Number , "lb" | L],L,Sub,[facts:weightlb(Sub,Val), Val > Number | C ], C).
reln_single(["weight", "less", "than" , Number , "lb" | L],L,Sub,[facts:weightlb(Sub,Val), Val < Number | C ], C).
reln_single(["weight", "smaller", "than", Number, "lb" | L],L,Sub,[facts:weightlb(Sub,Val), Val < Number | C ], C).

reln_single(["weight", "greater", "than", Number | L],L,Sub,[facts:weightkg(Sub,Val), number_codes(Num, Number), Val > Num | C], C).
reln_single(["weight", "larger", "than", Number | L],L,Sub,[facts:weightkg(Sub,Val), Val > Number | C ], C).
reln_single(["weight", "bigger", "than", Number | L],L,Sub,[facts:weightkg(Sub,Val), Val > Number | C ], C).
reln_single(["weight", "less", "than", Number | L],L,Sub,[facts:weightkg(Sub,Val), Val < Number | C ], C).
reln_single(["weight", "smaller", "than", Number | L],L,Sub,[facts:weightkg(Sub,Val), Val < Number | C ], C).

reln_single(["height", "greater", "than",  Number | L],L,Sub,[facts:height_m(Sub,Val), Val > Number | C ], C).
reln_single(["height", "larger", "than" , Number | L],L,Sub,[facts:height_m(Sub,Val), Val > Number | C ], C).
reln_single(["height", "bigger", "than" , Number | L],L,Sub,[facts:height_m(Sub,Val), Val > Number | C ], C).
reln_single(["height", "less", "than" , Number | L],L,Sub,[facts:height_m(Sub,Val), Val < Number | C ], C).
reln_single(["height", "smaller", "than" , Number | L],L,Sub,[facts:height_m(Sub,Val), Val < Number | C ], C).


% reln(["bordering" | L],L,Sub,Obj,[borders(Sub,Obj)|C],C).
% reln(["next", "to" | L],L,Sub,Obj, [borders(Sub,Obj)|C],C).
% reln(["the", "capital", "of" | L],L,Sub,Obj, [capital(Obj,Sub)|C],C).
% reln(["the", "name", "of" | L],L,Sub,Obj, [name(Obj,Sub)|C],C).

