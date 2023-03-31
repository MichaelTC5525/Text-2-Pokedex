% Prolog representation of a grammar to ask a query of a database
% Builds a query which can then be asked of the knowledge base
%  This is not meant to be polished or linguistically reasonable, but purely to show what can be done

% This is expanded code of Figure 13.12 in Section 13.6.6 of
% Poole and Mackworth, Artificial Intelligence: foundations of
% computational agents, Cambridge, 2017

% Copyright (c) David Poole and Alan Mackworth 2017. This program
% is released under GPL, version 3 or later; see http://www.gnu.org/licenses/gpl.html

% Load using:
%?- [geography_query_string].

% noun_phrase(L0,L4,Ind,C0,C4) is true if
%  L0 and L4 are list of words, such that
%        L4 is an ending of L0
%        the words in L0 before L4 (written L0-L4) form a noun phrase
%  Ind is an individual that the noun phrase is referring to
% C0 is a list such that C4 is an ending of C0 and C0-C4 contains the constraints imposed by the noun phrase

% A noun phrase is a determiner followed by adjectives followed
% by a noun followed by an optional modifying phrase:
noun_phrase(L0,L4,Ind,C0,C4) :-
    det(L0,L1,Ind,C3,C4),
    adjectives(L1,L2,Ind,C2,C3),
    noun(L2,L3,Ind,C1,C2),
    omp(L3,L4,Ind,C0,C1).

% Try:

%?- noun_phrase(["a", "Spanish", "speaking", "country"],L1,E1,C0,C1).
%?- noun_phrase(["a", "country", "bordering", "Chile"],L1,E1,C0,C1).
%?- noun_phrase(["a", "Spanish", "speaking", "country", "bordering", "Chile"],[],E1,C0,[]).

% Determiners (articles) are ignored in this oversimplified example.
% They do not provide any extra constraints.
det(["the" | L],L,_,C,C).
det(["a" | L],L,_,C,C).
det(L,L,_,C,C).


% adjectives(L0,L2,Ind,C0,C2) is true if 
% L0-L2 is a sequence of adjectives imposes constraints C0-C2 on Ind
adjectives(L0,L2,Ind,C0,C2) :-
    adj(L0,L1,Ind,C0,C1),
    adjectives(L1,L2,Ind,C1,C2).
adjectives(L,L,_,C,C).

% An optional modifying phrase / relative clause is either
% a relation (verb or preposition) followed by a noun_phrase or
% 'that' followed by a relation then a noun_phrase or
% nothing 
mp(L0,L2,Subject,C0,C2) :-
    reln(L0,L1,Subject,Object,C0,C1),
    aphrase(L1,L2,Object,C1,C2).
mp(["that"|L0],L2,Subject,C0,C2) :-
    reln(L0,L1,Subject,Object,C0,C1),
    aphrase(L1,L2,Object,C1,C2).

%?- mp(["the", "name", "of", "the", "capital", "of", "a", "Spanish", "speaking", "country", "that", "borders", "Argentina"],[],E1,C0,[]).

% An optional modifying phrase is either a modifying phrase or nothing
omp(L0,L1,E,C0,C1) :-
    mp(L0,L1,E,C0,C1).
omp(L,L,_,C,C).

% a phrase is a noun_phrase or a modifying phrase
% note that this uses 'aphrase' because 'phrase' is a static procedure in SWI Prolog
aphrase(L0, L1, E, C0,C1) :- noun_phrase(L0, L1, E,C0,C1).
aphrase(L0, L1, E,C0,C1) :- mp(L0, L1, E,C0,C1).

% DICTIONARY
% adj(L0,L1,Ind,C0,C1) is true if L0-L1 
% is an adjective that imposes constraints C0-C1 Ind
adj(["large" | L],L,Ind, [large(Ind)|C],C).
adj([LangName,"speaking" | L],L,Ind, [language(Ind, Lang), name(Lang, LangName)|C],C).

noun(["country" | L],L,Ind, [country(Ind)|C],C).
noun(["city" | L],L,Ind, [city(Ind)|C],C).
noun([N | L], L, Ind, C,C) :- name(Ind, N). % Parse fails if there is no entity for name

% reln(L0,L1,Sub,Obj,C0,C1) is true if L0-L1 is a relation on individuals Sub and Obj
reln(["borders" | L],L,Sub,Obj,[borders(Sub,Obj)|C],C).
reln(["bordering" | L],L,Sub,Obj,[borders(Sub,Obj)|C],C).
reln(["next", "to" | L],L,Sub,Obj, [borders(Sub,Obj)|C],C).
reln(["the", "capital", "of" | L],L,Sub,Obj, [capital(Obj,Sub)|C],C).
reln(["the", "name", "of" | L],L,Sub,Obj, [name(Obj,Sub)|C],C).

% question(Question,QR,Ind) is true if Query provides an answer about Ind to Question
question(["Is" | L0],L2,Ind,C0,C2) :-
    noun_phrase(L0,L1,Ind,C0,C1),
    mp(L1,L2,Ind,C1,C2).
question(["What","is" | L0], L1, Ind,C0,C1) :-
    aphrase(L0,L1,Ind,C0,C1).
question(["What" | L0],L2,Ind,C0,C2) :-
    noun_phrase(L0,L1,Ind,C0,C1),
    mp(L1,L2,Ind,C1,C2).
question(["What" | L0],L1,Ind,C0,C1) :-
    mp(L0,L1,Ind,C0,C1).

% ask(Q,A) gives answer A to question Q
ask(Q,A) :-
    get_constraints_from_question(Q,A,C),
    prove_all(C).

% get_constraints_from_question(Q,A,C) is true if C is the constraints on A to infer question Q
get_constraints_from_question(Q,A,C) :-
    question(Q,End,A,C,[]),
    member(End,[[],["?"],["."]]).


% prove_all(L) is true if all elements of L can be proved from the knowledge base
prove_all([]).
prove_all([H|T]) :-
    call(H),      % built-in Prolog predicate calls an atom
    prove_all(T).


%  The Database of Facts to be Queried

% country(C) is true if C is a country
country(argentina).
country(brazil).
country(chile).
country(paraguay).
country(peru).

% area(C, A) is true if C is a country and A is the area in square kilometres
area(argentina, 2780400).
area(brazil,    8515767).
area(chile,      756102).
area(paraguay,   406756).
area(peru,      1285216).

% large(C) is true if the area of C is greater than 2m km^2
large(C) :-
    area(C, A), 
    A > 2000000.


% language(C, L) is true of L is the principal language of Country C
language(argentina, spanish).
language(brazil, portugese).
language(chile, spanish).
language(paraguay, spanish).
language(peru, spanish).

capital(argentina, buenos_aires).
capital(chile, santiago).
capital(peru, lima).
capital(brazil, brasilia).
capital(paraguay, asuncion).

name(buenos_aires, "Buenos Aires").
name(santiago, "Santiago").
name(lima, "Lima").
name(brasilia, "Brasilia").
name(asuncion, "AsunciÃ³n").

name(argentina, "Argentina").
name(chile, "Chile").
name(peru, "Peru").
name(brazil, "Brazil").
name(paraguay, "Paraguay").

name(spanish, "Spanish").
name(portugese, "Portugese").


  
% borders(C1, C2) is true if country C1 borders country C2 & C1 is alphabetially before C2
borders0(chile, peru).
borders0(argentina, chile).
borders0(brazil, peru).
borders0(brazil, argentina).
borders0(brazil, paraguay).
borders0(argentina, paraguay).

% borders(C1, C2) is true if country C1 borders country C2
borders(X, Y) :- borders0(X, Y).
borders(X, Y) :- borders0(Y, X).

/* Try the following queries:
?- noun_phrase(["large", "country"], L, A,C0,C1).
?- noun_phrase(["large", "country",  "bordering", "Paraguay", "borders", "Chile"], L, A,C0,C1).
?- ask(["What", "is", "a", "country"], A).
?- ask(["What", "is", "a", "Spanish", "speaking", "country"], A).
?- ask(["What", "is", "the", "name", "of", "a", "Spanish", "speaking", "country"], A).
?- ask(["What", "large", "country",  "bordering", "Paraguay", "borders", "Chile"], A).
?- ask(["What", "is", "the", "name", "of", "a", "large", "Spanish", "speaking", "country"], A).
?- ask(["What", "is", "the", "capital", "of", "Chile"], A).
?- ask(["What", "is", "the", "name", "of", "the", "capital", "of", "a", "country"], A).
?- ask(["What","borders", "Chile"], A).
?- ask(["What", "is", "the", "name", "of", "a", "country", "that", "borders", "Chile"], A).
?- ask(["What", "is",  "a", "country", "that", "borders", "a", "country", "that", "borders", "Chile"], A).
?- ask(["What", "country",  "bordering", "Chile", "borders", "Paraguay"], A).
*/


% To get the input from a line:

q(Ans) :-
    write("Ask me: "), flush_output(current_output), 
    read_line_to_string(user_input, St), 
    split_string(St, " -", " ,?.!-", Ln), % ignore punctuation
    ask(Ln, Ans).
q(Ans) :-
    write("No more answers\n"),
    q(Ans).
   

/*
?- q(Ans).
Ask me: What is a country that borders Chile?
Ans = argentina ;
Ans = peru ;
false.

?- q(Ans).
Ask me: What is the name of the capital of a Spanish speaking country that borders Argentina?
Ans = "Santiago" ;
Ans = "AsunciÃ³n" ;
false.

Some more questions:
What is next to Chile?
Is Brazil next to Peru?
What is a country that borders a country that borders Chile
What country that borders Chile borders Paraguay?
What is borders Chile?
What borders Chile?
What country borders Chile?
What country that borders Chile next to Paraguay?
*/