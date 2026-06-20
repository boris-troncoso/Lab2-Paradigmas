% ... existing code ...
:- module(tda_deck, [createDeck/2, shuffleDeck/3]).
:- use_module(tda_card).

% ... existing code ...

% =============================================================================
% RF07: shuffleDeck
% =============================================================================
% Descripción: Revuelve una baraja de juegos usando una semilla.
% Tipo de algoritmo/estrategia: Recursión y ordenamiento por llaves (keysort).
% Argumentos de Entrada:
%   - DeckIn (TDA Baraja): Baraja a revolver.
%   - Seed (int): Número semilla para la aleatoriedad.
% Argumentos de Salida:
%   - DeckOut (TDA Baraja): Baraja revuelta.
% =============================================================================

% Predicado entregado por el enunciado para pseudoaleatoriedad
randomPuro(Xn, Xn1) :-
    Xn1 is (1103515245 * Xn + 12345) mod 2147483648.

% Predicado auxiliar: Generar N números pseudoaleatorios
% generar_randoms(Cantidad, SemillaInicial, ListaResultante)
generar_randoms(0, _, []).
generar_randoms(N, Seed, [NextSeed|Rest]) :-
    N > 0,
    randomPuro(Seed, NextSeed),
    N1 is N - 1,
    generar_randoms(N1, NextSeed, Rest).

% Predicado auxiliar: Empareja cada carta con un número aleatorio
% emparejar_cartas(ListaCartas, ListaRandoms, ListaPares)
emparejar_cartas([], [], []).
emparejar_cartas([C|Cs], [R|Rs], [R-C|Pairs]) :-
    emparejar_cartas(Cs, Rs, Pairs).

% Predicado auxiliar: Extrae solo las cartas de la lista de pares
% desemparejar_cartas(ListaPares, ListaCartas)
desemparejar_cartas([], []).
desemparejar_cartas([_-C|Pairs], [C|Cs]) :-
    desemparejar_cartas(Pairs, Cs).

% Predicado principal
shuffleDeck(deck(CardsIn), Seed, deck(CardsOut)) :-
    length(CardsIn, N),
    generar_randoms(N, Seed, ListaRandoms),
    emparejar_cartas(CardsIn, ListaRandoms, CartasEmparejadas),
    keysort(CartasEmparejadas, CartasOrdenadas),
    desemparejar_cartas(CartasOrdenadas, CardsOut).