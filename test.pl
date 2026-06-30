% script de pruebas
% archivo: test.pl

:- set_prolog_flag(answer_write_options, [max_depth(0)]).

:- use_module(tda_card).
:- use_module(tda_deck).
:- use_module(tda_juego).
:- use_module(main_195598568_BORIS_TRONCOSO_CONOPAN).

% efectos dummy para que los predicados compilen bien
sinEfecto(JuegoIn, JuegoIn).
efectoCynthia(JuegoIn, JuegoIn).
efectoPocion(JuegoIn, JuegoIn).
efectoHabilidad(JuegoIn, JuegoIn).

prueba_partida :-
    writeln('--- iniciando partida de prueba ---'),

    % 1. armo unas energias rapidas
    createEnergyCard("basica", 1, "Rayo", E_Rayo),
    createEnergyCard("basica", 2, "Agua", E_Agua),

    % 2. ataques
    createAttack([[1,"Rayo"]], "impactrueno", "pega suave", 20, sinEfecto, Ataque1),
    createAttack([[2,"Rayo"]], "rayo fuerte", "pega mas duro", 50, sinEfecto, Ataque2),
    createAttack([[1,"Agua"]], "burbuja", "tira agua", 20, sinEfecto, Ataque3),
    createAttack([], "foco energia", "habilidad de prueba", 0, efectoHabilidad, Habilidad1),

    % 3. pokemones
    % mi mazo usa electricos
    createPokemonCard("base", 1, "Pikachu", null, 60, "Rayo", "Lucha", "Metal", 1, false, null, [Ataque1], Pika),
    createPokemonCard("base", 2, "Raichu", "Pikachu", 100, "Rayo", "Lucha", "Metal", 2, false, null, [Ataque2], Raichu),
    createPokemonCard("base", 3, "Voltorb", null, 50, "Rayo", "Lucha", "Ninguna", 1, false, Habilidad1, [Ataque1], Volt),
    
    % mazo rival usa agua
    createPokemonCard("base", 4, "Squirtle", null, 60, "Agua", "Rayo", "Ninguna", 1, false, null, [Ataque3], Squir),
    createPokemonCard("base", 5, "Lapras EX", null, 150, "Agua", "Rayo", "Ninguna", 3, true, null, [Ataque3], Lapras),

    % 4. entrenadores
    createTrainerCard("base", 10, "Cynthia", "partidario", "robar cartas", efectoCynthia, Cynthia),
    createTrainerCard("base", 11, "Pocion", "objeto", "cura 30", efectoPocion, Pocion),

    % 5. crear mazos distintos
    % mazo 1 mio puras cosas electricas
    createDeck([
        Pika, Pika, Pika, Pika, Raichu, Raichu, Volt, Volt,
        Cynthia, Cynthia, Pocion, Pocion,
        E_Rayo, E_Rayo, E_Rayo, E_Rayo, E_Rayo, E_Rayo, E_Rayo, E_Rayo,
        E_Rayo, E_Rayo, E_Rayo, E_Rayo, E_Rayo, E_Rayo, E_Rayo, E_Rayo,
        E_Rayo, E_Rayo, E_Rayo, E_Rayo, E_Rayo, E_Rayo, E_Rayo, E_Rayo,
        E_Rayo, E_Rayo, E_Rayo, E_Rayo, E_Rayo, E_Rayo, E_Rayo, E_Rayo,
        E_Rayo, E_Rayo, E_Rayo, E_Rayo, E_Rayo, E_Rayo, E_Rayo, E_Rayo,
        E_Rayo, E_Rayo, E_Rayo, E_Rayo, E_Rayo, E_Rayo, E_Rayo, E_Rayo
    ], MazoMio),

    % mazo 2 del rival enfocado en agua
    createDeck([
        Squir, Squir, Squir, Squir, Pocion, Lapras, Lapras, Lapras,
        Cynthia, Cynthia, Cynthia, Pocion,
        E_Agua, E_Agua, E_Agua, E_Agua, E_Agua, E_Agua, E_Agua, E_Agua,
        E_Agua, E_Agua, E_Agua, E_Agua, E_Agua, E_Agua, E_Agua, E_Agua,
        E_Agua, E_Agua, E_Agua, E_Agua, E_Agua, E_Agua, E_Agua, E_Agua,
        E_Agua, E_Agua, E_Agua, E_Agua, E_Agua, E_Agua, E_Agua, E_Agua,
        E_Agua, E_Agua, E_Agua, E_Agua, E_Agua, E_Agua, E_Agua, E_Agua,
        E_Agua, E_Agua, E_Agua, E_Agua, E_Agua, E_Agua, E_Agua, E_Agua
    ], MazoRival),

    % 6. inicio de la partida
    initGame(MazoMio, MazoRival, 42, G0),
    writeln('mesa inicial:'),
    printGame(G0, Str0), writeln(Str0),

    % 7. preparacion de la mesa sacando cartas reales de lo que nos toco en la mano
    gameGetJ1(G0, J1_ini), playerGetMano(J1_ini, [MiCarta1, MiCarta2, MiCarta3 | _]),
    playToBench(G0, MiCarta1, G1),
    changeActivePokemon(G1, null, G2),
    usePokemonAttack(G2, null, null, [], G3), % pasamos el turno

    % preparacion jugador 2 sacando de su propia mano
    gameGetJ2(G3, J2_ini), playerGetMano(J2_ini, [SuCarta1, SuCarta2, SuCarta3 | _]),
    playToBench(G3, SuCarta1, G4),
    playToBench(G4, SuCarta2, G5),
    changeActivePokemon(G5, null, G6),
    usePokemonAttack(G6, null, null, [], G7), % pasamos turno al j1

    % 8. turno real 1 de j1
    drawCardFromDeck(G7, _CartaRobadaJ1, G8),
    gameGetActivePokemon(G8, ActivoJ1),
    useEnergyCard(G8, ActivoJ1, MiCarta2, G9), % usamos la segunda carta que nos toco
    usePokemonAttack(G9, ActivoJ1, "impactrueno", [], G10),
    
    writeln('estado despues de mi primer ataque:'),
    printGame(G10, Str10), writeln(Str10),

    % turno 1 de j2
    drawCardFromDeck(G10, _CartaRobadaJ2, G11),
    gameGetActivePokemon(G11, ActivoJ2),
    useEnergyCard(G11, ActivoJ2, SuCarta3, G12), % usa su tercera carta
    usePokemonAttack(G12, ActivoJ2, "burbuja", [], G14),

    writeln('estado final tras el ataque del rival:'),
    printGame(G14, Str19), writeln(Str19),
    writeln('--- test finalizado con exito ---'),
    true.