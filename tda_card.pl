% TDA card rf01 a rf05
% representacion comun para todas las cartas usando listas con etiqueta
%
%   energia    : [card, energia,    Exp, Num, Nombre]
%   pokemon    : [card, pokemon,    Exp, Num, Nombre, EvolucionaDe, Ps, Tipo,
%                                   Debilidad, Resistencia, CosteRetirada,
%                                   EsEX, Habilidad, Ataques]
%   entrenador : [card, entrenador, Exp, Num, Nombre, Tipo, Texto, Predicado]
%
% ademas el tda attack usado por ataques y habilidades
%   attack     : [attack, Costo, Nombre, Descripcion, Dagno, Predicado]

:- module(tda_card, [
    createEnergyCard/4,
    createAttack/6,
    createPokemonCard/13,
    createTrainerCard/7,
    cardGetCategoria/2,
    cardGetExpansion/2,
    cardGetNumero/2,
    cardGetNombre/2,
    energiaGetTipo/2,
    pokeGetEvolucionaDe/2,
    pokeGetPs/2,
    pokeGetTipo/2,
    pokeGetDebilidad/2,
    pokeGetResistencia/2,
    pokeGetCosteRetirada/2,
    pokeEsEX/2,
    pokeGetHabilidad/2,
    pokeGetAtaques/2,
    trainerGetTipo/2,
    trainerGetTexto/2,
    trainerGetPredicado/2,
    attackGetCosto/2,
    attackGetNombre/2,
    attackGetDescripcion/2,
    attackGetDagno/2,
    attackGetPredicado/2,
    esEnergia/1,
    esPokemon/1,
    esEntrenador/1,
    esPokemonBasico/1
]).

% constructores

% createEnergyCard Exp, Num, Nombre, Carta
% descripcion: crea una carta de energia basica el nombre indica el tipo
% dominio: exp string x num int x nombre string
% recorrido: carta lista que representa el tda
% estrategia: unificacion directa
createEnergyCard(Exp, Num, Nombre, [card, energia, Exp, Num, Nombre]).

% createAttack Costo, Nombre, Desc, Dagno, Pred, Attack
% descripcion: crea un ataque o habilidad si el costo es una lista vacia
% dominio: costo lista de listas x nombre string x desc string x dagno int x pred predicado
% recorrido: attack lista que representa el tda
% estrategia: unificacion directa
createAttack(Costo, Nombre, Desc, Dagno, Pred,
             [attack, Costo, Nombre, Desc, Dagno, Pred]).

% createPokemonCard Exp, Num, Nombre, EvDe, Ps, Tipo, Deb, Res, CosteRet, EsEX, Hab, Ataques, Carta
% descripcion: crea una carta pokemon validando reglas de ps y cantidad de ataques
% dominio: exp str x num int x nombre str x evde str x ps int x tipo str x deb str x res str x costeret int x esex bool x hab attack x ataques lista attack
% recorrido: carta lista que representa el tda
% estrategia: validacion logica ps mayor a 0 y limite de lista de ataques luego unificacion
createPokemonCard(Exp, Num, Nombre, EvDe, Ps, Tipo, Deb, Res, CosteRet,
                  EsEX, Hab, Ataques,
                  [card, pokemon, Exp, Num, Nombre, EvDe, Ps, Tipo, Deb, Res,
                   CosteRet, EsEX, Hab, Ataques]) :-
    Ps > 0,
    cantidadAtaquesValida(Hab, Ataques).

% cantidadAtaquesValida Habilidad, Ataques
% sin habilidad maximo 3 ataques con habilidad maximo 2
cantidadAtaquesValida(null, Ataques) :-
    length(Ataques, N),
    N =< 3.
cantidadAtaquesValida(Hab, Ataques) :-
    Hab \= null,
    length(Ataques, N),
    N =< 2.

% createTrainerCard Exp, Num, Nombre, Tipo, Texto, Predicado, Carta
% descripcion: crea una carta de entrenador sea partidario u objeto
% dominio: exp string x num int x nombre string x tipo string x texto string x pred predicado
% recorrido: carta lista que representa el tda
% estrategia: unificacion directa
createTrainerCard(Exp, Num, Nombre, Tipo, Texto, Pred,
                  [card, entrenador, Exp, Num, Nombre, Tipo, Texto, Pred]).

% selectores comunes sirven para cualquier carta
% estrategia: acceso directo por posicion mediante unificacion

% cardGetCategoria Carta, Categoria - energia, pokemon o entrenador
cardGetCategoria([card, Cat | _], Cat).

% cardGetExpansion Carta, Exp
cardGetExpansion([card, _, Exp | _], Exp).

% cardGetNumero Carta, Num
cardGetNumero([card, _, _, Num | _], Num).

% cardGetNombre Carta, Nombre - el nombre va en la misma posicion en las 3 cartas
cardGetNombre([card, _, _, _, Nombre | _], Nombre).

% selectores de energia

% energiaGetTipo Carta, Tipo - el tipo de energia es su propio nombre
energiaGetTipo([card, energia, _, _, Tipo], Tipo).

% selectores de pokemon

pokeGetEvolucionaDe( [card, pokemon, _,_,_, EvDe | _], EvDe).
pokeGetPs(           [card, pokemon, _,_,_,_, Ps | _], Ps).
pokeGetTipo(         [card, pokemon, _,_,_,_,_, Tipo | _], Tipo).
pokeGetDebilidad(    [card, pokemon, _,_,_,_,_,_, Deb | _], Deb).
pokeGetResistencia(  [card, pokemon, _,_,_,_,_,_,_, Res | _], Res).
pokeGetCosteRetirada([card, pokemon, _,_,_,_,_,_,_,_, CR | _], CR).
pokeEsEX(            [card, pokemon, _,_,_,_,_,_,_,_,_, EsEX | _], EsEX).
pokeGetHabilidad(    [card, pokemon, _,_,_,_,_,_,_,_,_,_, Hab | _], Hab).
pokeGetAtaques(      [card, pokemon, _,_,_,_,_,_,_,_,_,_,_, Ataques], Ataques).

% selectores de entrenador

trainerGetTipo(     [card, entrenador, _,_,_, Tipo | _], Tipo).
trainerGetTexto(    [card, entrenador, _,_,_,_, Texto | _], Texto).
trainerGetPredicado([card, entrenador, _,_,_,_,_, Pred], Pred).

% selectores de attack

attackGetCosto(      [attack, Costo | _], Costo).
attackGetNombre(     [attack, _, Nombre | _], Nombre).
attackGetDescripcion([attack, _,_, Desc | _], Desc).
attackGetDagno(      [attack, _,_,_, Dagno | _], Dagno).
attackGetPredicado(  [attack, _,_,_,_, Pred], Pred).

% predicados de pertenencia

% esEnergia Carta
esEnergia(Carta) :- cardGetCategoria(Carta, energia).

% esPokemon Carta
esPokemon(Carta) :- cardGetCategoria(Carta, pokemon).

% esEntrenador Carta
esEntrenador(Carta) :- cardGetCategoria(Carta, entrenador).

% esPokemonBasico Carta - un basico no evoluciona de nadie o sea es null
esPokemonBasico(Carta) :-
    esPokemon(Carta),
    pokeGetEvolucionaDe(Carta, null).