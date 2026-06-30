% ============================================================================
% tda juego
% representa la mesa y el estado de la partida
% game: [game, TurnoActual, Jugador1, Jugador2]
% jugador: [player, Mazo, Mano, Banca, Activo, Premios, Descarte]
% ============================================================================

:- module(tda_juego, [
    createPlayer/7,
    createGame/4,
    gameGetTurno/2,
    gameGetJ1/2,
    gameGetJ2/2,
    playerGetMazo/2,
    playerGetMano/2,
    playerGetBanca/2,
    playerGetActivo/2,
    playerGetPremios/2,
    playerGetDescarte/2,
    gameSetJ1/3,
    gameSetJ2/3,
    gameSetTurno/3,
    playerSetMazo/3,
    playerSetMano/3,
    playerSetBanca/3,
    playerSetActivo/3,
    playerSetPremios/3,
    playerSetDescarte/3,
    gameGetActivePokemon/2,
    gameGetBenchPokemon/2
]).

% ----------------------------------------------------------------------------
% constructores
% ----------------------------------------------------------------------------

% createPlayer Mazo, Mano, Banca, Activo, Premios, Descarte, PlayerOut
% descripcion: empaqueta todas las zonas de un jugador en una sola lista
% dominio: mazo lista x mano lista x banca lista x activo carta x premios lista x descarte lista x playerout lista
% recorrido: playerout lista con etiqueta player
% estrategia: unificacion directa
createPlayer(Mazo, Mano, Banca, Activo, Premios, Descarte, 
             [player, Mazo, Mano, Banca, Activo, Premios, Descarte]).

% createGame Turno, J1, J2, GameOut
% descripcion: arma la mesa con el turno y ambos jugadores
% dominio: turno int x j1 player x j2 player x gameout lista
% recorrido: gameout lista con etiqueta game
% estrategia: unificacion directa
createGame(Turno, J1, J2, [game, Turno, J1, J2]).

% ----------------------------------------------------------------------------
% selectores del juego
% ----------------------------------------------------------------------------

% gameGetTurno Game, Turno
gameGetTurno([game, Turno, _, _], Turno).

% gameGetJ1 Game, J1
gameGetJ1([game, _, J1, _], J1).

% gameGetJ2 Game, J2
gameGetJ2([game, _, _, J2], J2).

% ----------------------------------------------------------------------------
% selectores del jugador
% ----------------------------------------------------------------------------

playerGetMazo([player, Mazo, _, _, _, _, _], Mazo).
playerGetMano([player, _, Mano, _, _, _, _], Mano).
playerGetBanca([player, _, _, Banca, _, _, _], Banca).
playerGetActivo([player, _, _, _, Activo, _, _], Activo).
playerGetPremios([player, _, _, _, _, Premios, _], Premios).
playerGetDescarte([player, _, _, _, _, _, Descarte], Descarte).

% ----------------------------------------------------------------------------
% modificadores del juego
% estrategia: desarmo la lista cambio solo lo que necesito y la vuelvo a armar
% ----------------------------------------------------------------------------

% gameSetJ1 GameIn, NuevoJ1, GameOut
gameSetJ1([game, Turno, _, J2], NuevoJ1, [game, Turno, NuevoJ1, J2]).

% gameSetJ2 GameIn, NuevoJ2, GameOut
gameSetJ2([game, Turno, J1, _], NuevoJ2, [game, Turno, J1, NuevoJ2]).

% gameSetTurno GameIn, NuevoTurno, GameOut
gameSetTurno([game, _, J1, J2], NuevoTurno, [game, NuevoTurno, J1, J2]).

% ----------------------------------------------------------------------------
% modificadores del jugador
% ----------------------------------------------------------------------------

playerSetMazo([player, _, Mano, Banca, Activo, Premios, Descarte], NuevoMazo, 
              [player, NuevoMazo, Mano, Banca, Activo, Premios, Descarte]).

playerSetMano([player, Mazo, _, Banca, Activo, Premios, Descarte], NuevaMano, 
              [player, Mazo, NuevaMano, Banca, Activo, Premios, Descarte]).

playerSetBanca([player, Mazo, Mano, _, Activo, Premios, Descarte], NuevaBanca, 
               [player, Mazo, Mano, NuevaBanca, Activo, Premios, Descarte]).

playerSetActivo([player, Mazo, Mano, Banca, _, Premios, Descarte], NuevoActivo, 
                [player, Mazo, Mano, Banca, NuevoActivo, Premios, Descarte]).

playerSetPremios([player, Mazo, Mano, Banca, Activo, _, Descarte], NuevosPremios, 
                 [player, Mazo, Mano, Banca, Activo, NuevosPremios, Descarte]).

playerSetDescarte([player, Mazo, Mano, Banca, Activo, Premios, _], NuevoDescarte, 
                  [player, Mazo, Mano, Banca, Activo, Premios, NuevoDescarte]).

% ----------------------------------------------------------------------------
% selectores especiales que pide el test de la profe
% ----------------------------------------------------------------------------

% gameGetActivePokemon Juego, Activo
% descripcion: saca directamente el pokemon activo del jugador que esta de turno
% estrategia: revisa el turno actual y usa el selector del jugador correspondiente
gameGetActivePokemon([game, 1, J1, _], Activo) :- 
    playerGetActivo(J1, Activo).
gameGetActivePokemon([game, 2, _, J2], Activo) :- 
    playerGetActivo(J2, Activo).

% gameGetBenchPokemon Juego, Banca
% descripcion: saca directamente la banca del jugador que esta de turno
% estrategia: revisa el turno actual y usa el selector del jugador correspondiente
gameGetBenchPokemon([game, 1, J1, _], Banca) :- 
    playerGetBanca(J1, Banca).
gameGetBenchPokemon([game, 2, _, J2], Banca) :- 
    playerGetBanca(J2, Banca).