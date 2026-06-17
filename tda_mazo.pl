:- module(tda_deck, [createDeck/2]).
:- use_module(tda_card).

% =============================================================================
% TDA Deck (Baraja)
% Representación: deck(List Card)
% =============================================================================

% --- CONSTRUCTORES ---

% Predicado: createDeck/2
% Descripción: Crea un mazo validando reglas: 60 cartas, 1 pokemon básico min, max 4 copias.
% Tipo de algoritmo: Recursión y conteo sobre listas.
% Argumentos de entrada: Cards (List Card)
% Argumentos de salida: Deck (TDA Baraja)
createDeck(Cards, deck(Cards)) :-
length(Cards, 60),             % Regla 1: Exactamente 60 cartas
hasBasicPokemon(Cards),        % Regla 2: Al menos un Pokémon básico
checkCardLimits(Cards, Cards). % Regla 3: Máximo 4 copias (excepto energías)

% --- OTROS PREDICADOS (Funciones auxiliares privadas) ---

% Verifica recursivamente si hay al menos un Pokémon básico en la lista.
hasBasicPokemon([Card|]) :- isBasicPokemon(Card), !.
hasBasicPokemon([|Rest]) :- hasBasicPokemon(Rest).

% Verifica que ninguna carta (que no sea energía básica) supere las 4 copias.
checkCardLimits([], _).
checkCardLimits([Card|Rest], AllCards) :-
isBasicEnergy(Card), !, % Si es energía básica, no hay límite, pasa a la siguiente.
checkCardLimits(Rest, AllCards).
checkCardLimits([Card|Rest], AllCards) :-
getCardName(Card, NombreCarta),
countOccurrences(NombreCarta, AllCards, Cantidad),
Cantidad =< 4, % Falla si hay más de 4
checkCardLimits(Rest, AllCards).

% Cuenta cuántas veces aparece una carta con el mismo nombre en la lista.
countOccurrences(, [], 0).
countOccurrences(NombreABuscar, [Card|Rest], Cantidad) :-
getCardName(Card, NombreABuscar), !,
countOccurrences(NombreABuscar, Rest, SubCantidad),
Cantidad is SubCantidad + 1.
countOccurrences(NombreABuscar, [|Rest], Cantidad) :-
countOccurrences(NombreABuscar, Rest, Cantidad).