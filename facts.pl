:- module(facts, [name/2, type/2, typename/2, weightlb/2, weightkg/2, height_m/2]).

pokemon(pikachu).
pokemon(sandslash).
pokemon(phanpy).
pokemon(groudon).
pokemon(entei).
pokemon(charizard).
pokemon(electabuzz).
pokemon(squirtle).
pokemon(treecko).

% Names of Pokemon in KB

name(pikachu, "Pikachu").
name(sandslash, "Sandslash").
name(phanpy, "Phanpy").
name(groudon, "Groudon").
name(entei,"Entei").
name(charizard, "Charizard").
name(electabuzz, "Electabuzz").
name(squirtle, "Squirtle").
name(treecko, "Treecko").

% Type of Pokemon in KB

type(pikachu, electric).
type(sandslash, ground).
type(phanpy, ground).
type(groudon, ground).
type(entei, fire).
type(charizard, fire).
type(charizard, flying).
type(electabuzz, electric).
type(squirtle, water).
type(treecko, grass).

% Weight of Pokemon in pounds

weightlb(pikachu, 13.2).
weightlb(sandslash, 65.0).
weightlb(phanpy, 73.9).
weightlb(groudon, 2094.4).
weightlb(entei, 436.5).
weightlb(charizard, 199.5).
weightlb(electabuzz, 66.1).
weightlb(squirtle, 19.8).
weightlb(treecko, 11.0).

% Weight of Pokemon in kg

weightkg(pikachu, 6.0).
weightkg(sandslash, 29.5).
weightkg(phanpy, 33.5).
weightkg(groudon, 950.0).
weightkg(entei, 198.0).
weightkg(charizard, 90.5).
weightkg(electabuzz, 30.0).
weightkg(squirtle, 9.0).
weightkg(treecko, 5.0).

% Height of Pokemon in meters

height_m(pikachu, 0.4).
height_m(sandslash, 1.0).
height_m(phanpy, 0.5).
height_m(groudon, 3.5).
height_m(entei, 2.1).
height_m(charizard, 1.7).
height_m(electabuzz, 1.1).
height_m(squirtle, 0.5).
height_m(treecko, 0.5).

% National Pokedex number of Pokemon

national_num(pikachu, 25).
national_num(sandslash, 28).
national_num(phanpy, 231.0).
national_num(groudon, 383.0).
national_num(entei, 244.0).
national_num(charizard, 6.0).
national_num(electabuzz, 125.0).
national_num(squirtle, 7.0).
national_num(treecko, 252.0).

% Type names

typename(electric, "Electric").
typename(water, "Water").
typename(fire, "Fire").
typename(grass, "Grass").
typename(normal, "Normal").
typename(flying, "Flying").
typename(ground, "Ground").