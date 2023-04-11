:- module(api, [get_dict4/2]).

:- use_module(library(http/http_client)).
:- use_module(library(http/http_open)).
:- use_module(library(http/http_json)).
:- use_module(library(http/json)).
:- use_module(library(dicts)).

get_dict4(Pokemon, Type) :- get_dict3(Dict, Pokemon), get_dict(name, Dict, Type).

get_dict3(Val, Pokemon) :- get_dict2(Dict, Pokemon), get_dict(type, Dict, Val).

get_dict2(H, Pokemon) :- get_dict1([H|_], Pokemon).

get_dict1(Val, Pokemon) :- api_call(Dict, Pokemon), get_dict(types, Dict, Val).

request_ok(URL) :- http_open(URL, _, [status_code(Code)]), Code > 199, Code < 300.

api_call(Dict, Pokemon) :-
    atomics_to_string(["https://pokeapi.co/api/v2/pokemon/", Pokemon], URL),
    request_ok(URL),
    setup_call_cleanup(
        http_open(URL, In, [request_header('Accept'='application/json')]),
        json_read_dict(In, Dict),
        close(In)
    ).