:- module(tda_game, [initGame/4]).
:- use_module(tda_card).
:- use_module(tda_deck).

% =============================================================================
% TDA Game y TDA Player
% =============================================================================
% Representación Player: 
% player(Nombre, DeckRestante, Mano, Premios, Activo, Banca, Descarte)
% Representación Game: 
% game(Player1, Player2, TurnoActual)
% =============================================================================

% Predicado entregado por el enunciado para pseudoaleatoriedad
randomPuro(Xn, Xn1) :-
    Xn1 is (1103515245 * Xn + 12345) mod 2147483648.

% --- PREDICADOS AUXILIARES ---

% isBasicPokemon/1: Verifica si una carta es un Pokémon básico (EvolucionaDe = null)
isBasicPokemon(card_pokemon(_, _, _, null, _, _, _, _, _, _, _, _)).

% hasBasicPokemon/1: Verifica si hay al menos un Pokémon básico en una lista de cartas
hasBasicPokemon([C|_]) :- isBasicPokemon(C), !.
hasBasicPokemon([_|Cs]) :- hasBasicPokemon(Cs).

% setup_player/5: Realiza el robo de cartas aplicando la regla del Mulligan
setup_player(DeckIn, Seed, Nombre, player(Nombre, DeckRestante, Mano, Premios, null, [], []), NextSeed) :-
    shuffleDeck(DeckIn, Seed, deck(CartasMezcladas)),
    % Separar las primeras 7 cartas para la mano
    length(ManoTemp, 7),
    append(ManoTemp, Resto1, CartasMezcladas),
    (   hasBasicPokemon(ManoTemp) ->
        % Tiene básico: sacar 6 premios y guardar el resto como mazo
        length(PremiosTemp, 6),
        append(PremiosTemp, CartasDeckFinal, Resto1),
        Mano = ManoTemp,
        Premios = PremiosTemp,
        DeckRestante = deck(CartasDeckFinal),
        % Generar siguiente semilla para el otro jugador
        randomPuro(Seed, NextSeed)
    ;   % No tiene básico: hacer Mulligan (recursión con nueva semilla)
        randomPuro(Seed, SeedMulligan),
        setup_player(DeckIn, SeedMulligan, Nombre, player(Nombre, DeckRestante, Mano, Premios, null, [], []), NextSeed)
    ).

% --- CONSTRUCTORES / MODIFICADORES ---

% Predicado: initGame/4
% Descripción: Inicializa el juego barajando mazos, robando manos, premios y lanzando moneda.
% Tipo de algoritmo: Recursión (en setup_player) y evaluación lógica.
% Argumentos de Entrada:
%   - DeckJ1 (TDA Baraja): Mazo del jugador 1.
%   - DeckJ2 (TDA Baraja): Mazo del jugador 2.
%   - Seed (int): Semilla aleatoria inicial.
% Argumentos de Salida:
%   - Game (TDA Juego): Estructura con el juego inicializado.
initGame(DeckJ1, DeckJ2, Seed, game(Player1, Player2, JugadorInicial)) :-
    % 1. Lanzar moneda para ver quién comienza
    randomPuro(Seed, SeedMoneda),
    Moneda is SeedMoneda mod 2,
    (Moneda =:= 0 -> JugadorInicial = "Jugador 1" ; JugadorInicial = "Jugador 2"),
    
    % 2. Inicializar Jugador 1 (robar 7 cartas, premios y mulligan)
    randomPuro(SeedMoneda, SeedP1),
    setup_player(DeckJ1, SeedP1, "Jugador 1", Player1, SeedP2),
    
    % 3. Inicializar Jugador 2
    setup_player(DeckJ2, SeedP2, "Jugador 2", Player2, _).




:- module(tda_game, [initGame/4, playToBench/3]).
:- use_module(tda_card).
:- use_module(tda_deck).

% =============================================================================
% TDA Game y TDA Player
% =============================================================================
% Representación Player: 
% player(Nombre, DeckRestante, Mano, Premios, Activo, Banca, Descarte)
% Representación Game: 
% game(Player1, Player2, TurnoActual)
% =============================================================================

% Predicado entregado por el enunciado para pseudoaleatoriedad
randomPuro(Xn, Xn1) :-
    Xn1 is (1103515245 * Xn + 12345) mod 2147483648.

% --- PREDICADOS AUXILIARES Y SELECTORES ---

% Verifica si una carta es un Pokémon básico
isBasicPokemon(card_pokemon(_, _, _, null, _, _, _, _, _, _, _, _)).

% Verifica si una carta es de tipo Pokémon (cualquiera)
isPokemonCard(card_pokemon(_, _, _, _, _, _, _, _, _, _, _, _)).

% Verifica si hay al menos un Pokémon básico en una lista
hasBasicPokemon([C|_]) :- isBasicPokemon(C), !.
hasBasicPokemon([_|Cs]) :- hasBasicPokemon(Cs).

% setup_player: Realiza el robo inicial aplicando Mulligan
setup_player(DeckIn, Seed, Nombre, player(Nombre, DeckRestante, Mano, Premios, null, [], []), NextSeed) :-
    shuffleDeck(DeckIn, Seed, deck(CartasMezcladas)),
    length(ManoTemp, 7),
    append(ManoTemp, Resto1, CartasMezcladas),
    (   hasBasicPokemon(ManoTemp) ->
        length(PremiosTemp, 6),
        append(PremiosTemp, CartasDeckFinal, Resto1),
        Mano = ManoTemp,
        Premios = PremiosTemp,
        DeckRestante = deck(CartasDeckFinal),
        randomPuro(Seed, NextSeed)
    ;   randomPuro(Seed, SeedMulligan),
        setup_player(DeckIn, SeedMulligan, Nombre, player(Nombre, DeckRestante, Mano, Premios, null, [], []), NextSeed)
    ).

% --- CONSTRUCTORES ---

% RF08: initGame
initGame(DeckJ1, DeckJ2, Seed, game(Player1, Player2, JugadorInicial)) :-
    randomPuro(Seed, SeedMoneda),
    Moneda is SeedMoneda mod 2,
    (Moneda =:= 0 -> JugadorInicial = "Jugador 1" ; JugadorInicial = "Jugador 2"),
    randomPuro(SeedMoneda, SeedP1),
    setup_player(DeckJ1, SeedP1, "Jugador 1", Player1, SeedP2),
    setup_player(DeckJ2, SeedP2, "Jugador 2", Player2, _).

% =============================================================================
% RF10: playToBench
% =============================================================================
% Descripción: Pone un Pokémon de la mano en la banca del jugador actual 
%              siempre que haya espacio disponible (máximo 5).
% Tipo de algoritmo/estrategia: Selección y modificación de estructuras.
% Argumentos de Entrada:
%   - GameIn (TDA Juego): Estado actual del juego.
%   - Card (TDA Card): Carta que se desea jugar.
% Argumentos de Salida:
%   - GameOut (TDA Juego): Estado del juego modificado.
% =============================================================================
playToBench(game(P1, P2, "Jugador 1"), Card, game(P1Out, P2, "Jugador 1")) :-
    P1 = player(Nom, Deck, Mano, Prem, Act, Banca, Desc),
    isPokemonCard(Card),
    select(Card, Mano, NuevaMano),             % Valida que la carta esté en la mano y la saca
    length(Banca, L), L < 5,                   % Valida que la banca tenga espacio (máx 5)
    append(Banca, [Card], NuevaBanca),         % Agrega la carta al final de la banca
    P1Out = player(Nom, Deck, NuevaMano, Prem, Act, NuevaBanca, Desc).

playToBench(game(P1, P2, "Jugador 2"), Card, game(P1, P2Out, "Jugador 2")) :-
    P2 = player(Nom, Deck, Mano, Prem, Act, Banca, Desc),
    isPokemonCard(Card),
    select(Card, Mano, NuevaMano),             % Valida que la carta esté en la mano y la saca
    length(Banca, L), L < 5,                   % Valida que la banca tenga espacio (máx 5)
    append(Banca, [Card], NuevaBanca),         % Agrega la carta al final de la banca
    P2Out = player(Nom, Deck, NuevaMano, Prem, Act, NuevaBanca, Desc).