% tda deck rf06 a rf07
% una baraja se representa como un arreglo con la etiqueta deck y las cartas

:- module(tda_deck, [
    createDeck/2,
    deckGetCartas/2,
    deckSetCartas/3,
    shuffleDeck/3,
    randomPuro/2
]).

:- use_module(tda_card).

% constructor

% createDeck Cartas, Deck
% dominio: lista de cartas x deck
% reglas del mazo:
%   exactamente 60 cartas
%   maximo 4 cartas con el mismo nombre y la energia basica no tiene limite
%   al menos 1 pokemon basico
% estrategia: validacion con 3 chequeos y luego construccion
createDeck(Cartas, [deck, Cartas]) :-
    length(Cartas, 60),
    limiteCopiasOk(Cartas),
    hayPokemonBasico(Cartas).

% selector y modificador

% deckGetCartas Deck, Cartas
deckGetCartas([deck, Cartas], Cartas).

% deckSetCartas Deck, NuevasCartas, NuevoDeck
deckSetCartas([deck, _], NuevasCartas, [deck, NuevasCartas]).

% validaciones del mazo

% limiteCopiasOk Cartas
% ninguna carta que no sea energia puede tener mas de 4 copias por nombre
% estrategia: fuerza bruta por cada carta no energia cuenta cuantas comparten su nombre en todo el mazo y exige que sean 4 o menos
limiteCopiasOk(Cartas) :-
    limiteCopiasOkAux(Cartas, Cartas).

limiteCopiasOkAux([], _).
limiteCopiasOkAux([Carta | Resto], TodasLasCartas) :-
    ( esEnergia(Carta)
    ->  true                                   % las energias no tienen limite
    ;   cardGetNombre(Carta, Nombre),
        contarPorNombre(TodasLasCartas, Nombre, N),
        N =< 4
    ),
    limiteCopiasOkAux(Resto, TodasLasCartas).

% contarPorNombre Cartas, Nombre, N
% cuenta cuantas cartas de la lista se llaman igual
% estrategia: recursion con acumulacion del conteo
contarPorNombre([], _, 0).
contarPorNombre([Carta | Resto], Nombre, N) :-
    contarPorNombre(Resto, Nombre, N1),
    cardGetNombre(Carta, NombreCarta),
    ( NombreCarta == Nombre -> N is N1 + 1 ; N is N1 ).

% hayPokemonBasico Cartas
% verdadero si existe al menos un pokemon basico en la lista
% estrategia: recursion que se detiene al encontrar el primero
hayPokemonBasico([Carta | _]) :-
    esPokemonBasico(Carta),
    !.
hayPokemonBasico([_ | Resto]) :-
    hayPokemonBasico(Resto).

% barajado rf07

% randomPuro Xn, Xn1
% generador pseudoaleatorio entregado en el enunciado
randomPuro(Xn, Xn1) :-
    Xn1 is (1103515245 * Xn + 12345) mod 2147483648.

% shuffleDeck DeckIn, Semilla, DeckOut
% dominio: deck x int x deck
% revuelve las cartas de la baraja usando la semilla
% estrategia: saca las cartas las mezcla y reconstruye la baraja
shuffleDeck(DeckIn, Semilla, DeckOut) :-
    deckGetCartas(DeckIn, Cartas),
    mezclar(Cartas, Semilla, CartasMezcladas),
    deckSetCartas(DeckIn, CartasMezcladas, DeckOut).

% mezclar Cartas, Semilla, CartasMezcladas
% en cada paso genera un nuevo numero con randompuro lo usa para elegir una posicion saca esa carta y continua con el resto
% estrategia: recursion arrastrando la semilla
mezclar([], _, []).
mezclar(Cartas, Semilla, [CartaElegida | RestoMezclado]) :-
    Cartas \= [],
    randomPuro(Semilla, NuevaSemilla),
    length(Cartas, Largo),
    Indice is NuevaSemilla mod Largo,
    sacarEnPosicion(Cartas, Indice, CartaElegida, CartasRestantes),
    mezclar(CartasRestantes, NuevaSemilla, RestoMezclado).

% sacarEnPosicion Lista, Indice, Elemento, Resto
% saca el elemento que esta en la posicion contando desde 0 y deja el resto de la lista limpia
% estrategia: recursion bajando el indice hasta llegar a 0
sacarEnPosicion([X | Resto], 0, X, Resto).
sacarEnPosicion([X | Resto], N, Elem, [X | RestoSinElem]) :-
    N > 0,
    N1 is N - 1,
    sacarEnPosicion(Resto, N1, Elem, RestoSinElem).