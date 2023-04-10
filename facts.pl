:- module(facts, [name/2, type/2, typename/2, weightlb/2, weightkg/2, height_m/2, national_num/2]).

pokemon(pikachu).
pokemon(sandslash).
pokemon(phanpy).
pokemon(groudon).
pokemon(entei).
pokemon(charizard).
pokemon(electabuzz).
pokemon(squirtle).
pokemon(treecko).
pokemon(floette).
pokemon(ninetales).
pokemon(gardevoir).
pokemon(aggron).
pokemon(nidorina).
pokemon(bonsly).
pokemon(wurmple).
pokemon(dratini).
pokemon(corsola).


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
name(floette, "Floette").
name(ninetales, "Ninetales").
name(gardevoir, "Gardevoir").
name(aggron, "Aggron").
name(nidorina, "Nidorina").
name(bonsly, "Bonsly").
name(wurmple, "Bonsly").
name(dratini, "Dratini").
name(corsola, "Corsola").

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
type(floette, fairy).
type(ninetales, ice).
type(gardevoir, psychic).
type(aggron, steel).
type(nidorina, poison).
type(bonsly, rock).
type(wurmple, bug).
type(dratini, dragon).
type(corsola, ghost).

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
weightlb(floette, 2.0).
weightlb(ninetales, 43.9).
weightlb(gardevoir, 106.7).
weightlb(aggron, 793.7).
weightlb(nidorina, 44.1).
weightlb(bonsly, 33.1).
weightlb(wurmple, 7.9).
weightlb(dratini, 7.3).
weightlb(corsola, 11.0).

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
weightkg(floette, 0.9).
weightkg(ninetales, 19.9).
weightkg(gardevoir, 48.4).
weightkg(aggron, 360.0).
weightkg(nidorina, 20.0).
weightkg(bonsly, 15.0).
weightkg(wurmple, 3.6).
weightkg(dratini, 3.3).
weightkg(corsola, 5.0).

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
height_m(floette, 0.2).
height_m(ninetales, 1.1).
height_m(gardevoir, 1.6).
height_m(aggron, 2.1).
height_m(nidorina, 0.8).
height_m(bonsly, 0.5).
height_m(wurmple, 0.3).
height_m(dratini, 1.8).
height_m(corsola, 0.6).

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
national_num(floette, 670.0).
national_num(ninetales, 38.0).
national_num(gardevoir, 282.0).
national_num(aggron,306.0).
national_num(nidorina,30.0).
national_num(bonsly,438.0).
national_num(wurmple,265.0).
national_num(dratini,147.0).
national_num(corsola,222.0).

% Type names

typename(electric, "Electric").
typename(water, "Water").
typename(fire, "Fire").
typename(grass, "Grass").
typename(normal, "Normal").
typename(flying, "Flying").
typename(ground, "Ground").
typename(fighting, "Fighting").
typename(fairy, "Fairy").
typename(ice, "Ice").
typename(psychic, "Psychic").
typename(steel, "Steel").
typename(poison, "Poison").
typename(rock, "Rock").
typename(bug, "Bug").
typename(dragon, "Dragon").
typename(ghost, "Ghost").
typename(dark, "Dark").

type_adv(ground, electric).
type_adv(electric, water).
type_adv(water, fire).
type_adv(fire, grass).
type_adv(grass, water).
type_adv(flying, fighting).
type_adv(fighting, normal).
type_adv(ground, fire).