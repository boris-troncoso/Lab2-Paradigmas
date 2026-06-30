% ============================================================================
% motor del juego main.pl
% aca van las reglas y la logica de movimiento de cartas
% ============================================================================

:- module(main, [
    initGame/4,
    printGame/2,
    playToBench/3,
    changeActivePokemon/3,
    drawCardFromDeck/3,
    useEnergyCard/4,
    evolvePokemon/4,
    useTrainerCard/4,
    usePokemonAbility/4,
    usePokemonAttack/5
]).

:- use_module(tda_card).
:- use_module(tda_deck).
:- use_module(tda_juego).

% ----------------------------------------------------------------------------
% helpers para el manejo de turnos y listas
% ----------------------------------------------------------------------------

% obtenerJugadorActual Game, Jugador
obtenerJugadorActual([game, 1, J1, _], J1).
obtenerJugadorActual([game, 2, _, J2], J2).

% actualizarJugadorActual GameIn, NuevoJugador, GameOut
actualizarJugadorActual([game, 1, _, J2], NuevoJ1, [game, 1, NuevoJ1, J2]).
actualizarJugadorActual([game, 2, J1, _], NuevoJ2, [game, 2, J1, NuevoJ2]).

% sacarDeLista Elemento, ListaIn, ListaOut
% saca la primera ocurrencia del elemento en la lista
sacarDeLista(X, [X | Cola], Cola) :- !.
sacarDeLista(X, [Y | Cola], [Y | NuevaCola]) :- sacarDeLista(X, Cola, NuevaCola).

% cambiarTurno GameIn, GameOut
cambiarTurno([game, 1, J1, J2], [game, 2, J1, J2]).
cambiarTurno([game, 2, J1, J2], [game, 1, J1, J2]).

% ----------------------------------------------------------------------------
% rf08 initGame
% ----------------------------------------------------------------------------

% initGame Deck1, Deck2, Seed, Game
% estrategia: baraja saca mano valida basico saca premios y junta todo en el tda
initGame(Deck1, Deck2, Seed, GameOut) :-
    randomPuro(Seed, Seed1),
    shuffleDeck(Deck1, Seed1, Deck1Barajado),
    randomPuro(Seed1, Seed2),
    shuffleDeck(Deck2, Seed2, Deck2Barajado),
    
    randomPuro(Seed2, Seed3),
    sacarManoInicial(Deck1Barajado, Seed3, Mano1, Mazo1Restante, Seed4),
    sacarManoInicial(Deck2Barajado, Seed4, Mano2, Mazo2Restante, Seed5),
    
    sacarCartas(Mazo1Restante, 6, Premios1, Mazo1Final),
    sacarCartas(Mazo2Restante, 6, Premios2, Mazo2Final),
    
    randomPuro(Seed5, Seed6),
    TurnoInicial is (Seed6 mod 2) + 1,
    
    createPlayer(Mazo1Final, Mano1, [], null, Premios1, [], J1),
    createPlayer(Mazo2Final, Mano2, [], null, Premios2, [], J2),
    createGame(TurnoInicial, J1, J2, GameOut).

sacarManoInicial(MazoIn, SeedIn, ManoOut, MazoOut, SeedOut) :-
    deckGetCartas(MazoIn, ListaCartas),
    sacarCartas(ListaCartas, 7, ManoTemp, MazoTemp),
    ( tieneBasicoEnMano(ManoTemp) ->
        ManoOut = ManoTemp,
        MazoOut = MazoTemp,
        SeedOut = SeedIn
    ;
        shuffleDeck(MazoIn, SeedIn, MazoRebarajado),
        randomPuro(SeedIn, NuevaSeed),
        sacarManoInicial(MazoRebarajado, NuevaSeed, ManoOut, MazoOut, SeedOut)
    ).

tieneBasicoEnMano([Carta|_]) :- esPokemonBasico(Carta), !.
tieneBasicoEnMano([_|Resto]) :- tieneBasicoEnMano(Resto).

sacarCartas(Lista, 0, [], Lista).
sacarCartas([X|RestoIn], N, [X|RestoSacadas], ListaOut) :-
    N > 0,
    N1 is N - 1,
    sacarCartas(RestoIn, N1, RestoSacadas, ListaOut).

% ----------------------------------------------------------------------------
% rf09 printGame
% ----------------------------------------------------------------------------

printGame(Game, StrOut) :-
    gameGetTurno(Game, Turno),
    gameGetJ1(Game, J1),
    gameGetJ2(Game, J2),
    string_concat("=== ESTADO DEL JUEGO ===\nTurno actual: ", Turno, S1),
    string_concat(S1, "\n\n--- JUGADOR 1 ---\n", S2),
    armarStringJugador(J1, StrJ1),
    string_concat(S2, StrJ1, S3),
    string_concat(S3, "\n--- JUGADOR 2 ---\n", S4),
    armarStringJugador(J2, StrJ2),
    string_concat(S4, StrJ2, StrOut).

armarStringJugador(Player, StrOut) :-
    playerGetMazo(Player, Mazo), length(Mazo, LMazo),
    playerGetPremios(Player, Premios), length(Premios, LPremios),
    playerGetMano(Player, Mano), length(Mano, LMano),
    playerGetBanca(Player, Banca), length(Banca, LBanca),
    playerGetActivo(Player, Activo),
    string_concat("Cartas en mazo: ", LMazo, S1),
    string_concat(S1, "\nPremios restantes: ", S2),
    string_concat(S2, LPremios, S3),
    string_concat(S3, "\nCartas en mano: ", S4),
    string_concat(S4, LMano, S5),
    string_concat(S5, "\nPokemon en banca: ", S6),
    string_concat(S6, LBanca, S7),
    ( Activo == null -> StrActivo = "Ninguno" ; cardGetNombre(Activo, StrActivo) ),
    string_concat(S7, "\nPokemon Activo: ", S8),
    string_concat(S8, StrActivo, S9),
    string_concat(S9, "\n", StrOut).

% ----------------------------------------------------------------------------
% rf10 playToBench
% ----------------------------------------------------------------------------

% playToBench GameIn, Carta, GameOut
% saca el pokemon de la mano y lo agrega al final de la banca
playToBench(GameIn, Carta, GameOut) :-
    obtenerJugadorActual(GameIn, J),
    playerGetMano(J, Mano),
    sacarDeLista(Carta, Mano, NuevaMano),
    playerGetBanca(J, Banca),
    length(Banca, LBanca),
    LBanca < 5, % limite de la banca en el juego
    append(Banca, [Carta], NuevaBanca),
    playerSetMano(J, NuevaMano, JTemp),
    playerSetBanca(JTemp, NuevaBanca, JFinal),
    actualizarJugadorActual(GameIn, JFinal, GameOut).

% ----------------------------------------------------------------------------
% rf11 changeActivePokemon
% ----------------------------------------------------------------------------

% changeActivePokemon GameIn, Carta, GameOut
% mueve un pokemon de la banca al activo si no hay activo o paga coste si hay
changeActivePokemon(GameIn, Carta, GameOut) :-
    obtenerJugadorActual(GameIn, J),
    playerGetBanca(J, Banca),
    playerGetActivo(J, ActivoActual),
    ( Carta == null -> 
        % si mandan null asumo que solo saco el primero de la banca
        Banca = [NuevoActivo | NuevaBanca]
    ; 
        sacarDeLista(Carta, Banca, NuevaBanca),
        NuevoActivo = Carta
    ),
    ( ActivoActual == null ->
        BancaFinal = NuevaBanca
    ;
        % si habia activo lo devuelvo a la banca simplificado por ahora
        append(NuevaBanca, [ActivoActual], BancaFinal)
    ),
    playerSetBanca(J, BancaFinal, JTemp),
    playerSetActivo(JTemp, NuevoActivo, JFinal),
    actualizarJugadorActual(GameIn, JFinal, GameOut).

% ----------------------------------------------------------------------------
% rf12 drawCardFromDeck
% ----------------------------------------------------------------------------

% drawCardFromDeck GameIn, Carta, GameOut
% saca la primera del mazo y va a la mano
drawCardFromDeck(GameIn, Carta, GameOut) :-
    obtenerJugadorActual(GameIn, J),
    playerGetMazo(J, Mazo),
    Mazo = [Carta | NuevoMazo],
    playerGetMano(J, Mano),
    append(Mano, [Carta], NuevaMano),
    playerSetMazo(J, NuevoMazo, JTemp),
    playerSetMano(JTemp, NuevaMano, JFinal),
    actualizarJugadorActual(GameIn, JFinal, GameOut).

% ----------------------------------------------------------------------------
% rf13 useEnergyCard
% ----------------------------------------------------------------------------

% useEnergyCard GameIn, Pokemon, Energia, GameOut
% quita la energia de la mano simplificado no se asocia visualmente para no alargar
useEnergyCard(GameIn, _Pokemon, Energia, GameOut) :-
    obtenerJugadorActual(GameIn, J),
    playerGetMano(J, Mano),
    sacarDeLista(Energia, Mano, NuevaMano),
    playerSetMano(J, NuevaMano, JFinal),
    actualizarJugadorActual(GameIn, JFinal, GameOut).

% ----------------------------------------------------------------------------
% rf14 evolvePokemon
% ----------------------------------------------------------------------------

evolvePokemon(GameIn, PokemonEnJuego, CartaEvolucion, GameOut) :-
    obtenerJugadorActual(GameIn, J),
    playerGetMano(J, Mano),
    sacarDeLista(CartaEvolucion, Mano, NuevaMano),
    % simplificado asume que reemplaza al activo
    playerSetMano(J, NuevaMano, JTemp),
    playerSetActivo(JTemp, CartaEvolucion, JFinal),
    actualizarJugadorActual(GameIn, JFinal, GameOut).

% ----------------------------------------------------------------------------
% rf15, rf16 y rf17 usar entrenadores, habilidades y ataques
% ----------------------------------------------------------------------------

useTrainerCard(GameIn, CartaEntrenador, Args, GameOut) :-
    obtenerJugadorActual(GameIn, J),
    playerGetMano(J, Mano),
    sacarDeLista(CartaEntrenador, Mano, NuevaMano),
    playerGetDescarte(J, Descarte),
    append(Descarte, [CartaEntrenador], NuevoDescarte),
    playerSetMano(J, NuevaMano, JTemp),
    playerSetDescarte(JTemp, NuevoDescarte, JFinal),
    actualizarJugadorActual(GameIn, JFinal, GamePreEfecto),
    trainerGetPredicado(CartaEntrenador, Predicado),
    % llamar al predicado del efecto dinamicamente
    call(Predicado, GamePreEfecto, GameOut).

usePokemonAbility(GameIn, Pokemon, Args, GameOut) :-
    pokeGetHabilidad(Pokemon, Hab),
    Hab \= null,
    attackGetPredicado(Hab, Predicado),
    call(Predicado, GameIn, GameOut).

usePokemonAttack(GameIn, _Pokemon, NombreAtaque, _Args, GameOut) :-
    ( NombreAtaque == null ->
        cambiarTurno(GameIn, GameOut)
    ;
        % aca iria la logica de daño simplificamos pasando el turno al final del ataque
        cambiarTurno(GameIn, GameOut)
    ).