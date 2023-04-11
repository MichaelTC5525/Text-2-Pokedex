# Text-2-Pokedex
A Prolog Project for CPSC312-2022W-T2 at UBC

## Introduction

Similar to what was shown in lecture, our group decided to develop a natural language processing system that can answer queries formulated in normal English, within the realm of Pokemon characteristics and attributes. With logic programming, the idea of evaluating facts and hosting a knowledge base seems to be a suitable purpose for a language like Prolog.

See the [UBC Wiki](https://wiki.ubc.ca/Course:CPSC312-2023/Pokedex) for more information on this idea.

## Goals

- To learn more about Prolog and its syntax; develop skills in logic programming and how to build a knowledge base for languages like this
- Parse a query as a sentence, taking components of the sentence to inform the search for results
- Provide a system that is easily expandable and can include more additional Pokemon individuals and their properties using a consistent format that makes them readily query-able
- To learn how to make HTTP REST API calls in Prolog to external databases to enrich our knowledge base.
- To learn how to properly handle responses and data from external API calls using Prolog.

## Team / Contributors
- Justin Jao
- Angela Li
- Michael Cheung

## Other

Example queries and session traces may be provided in the `samples/` directory.

### References

Our project takes inspiration and reference from provided lecture material, which is used to assist in developing the parsing behaviour of the system

- Lecture .pl files located in the `reference/` directory.

Information on Pokemon is sourced from online resources; we generally consult [Bulbapedia](https://bulbapedia.bulbagarden.net/) and [PokemonDB](https://pokemondb.net/).

External API calls were made to the open-source PokeAPI at https://pokeapi.co/.

