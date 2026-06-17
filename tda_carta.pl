:- module(tda_card, [createEnergyCard/4]).

% =============================================================================
% TDA Card
% =============================================================================
% Representación: 
% card(Expansion, Numero, Nombre, Tipo)
% donde Tipo puede ser "Energia", "Pokemon" o "Entrenador".
% =============================================================================

% --- CONSTRUCTORES ---

% Predicado: createEnergyCard/4
% Descripción: Crea una estructura que representa una carta de energía básica.
% Argumentos de Entrada:
%   - Expansion (string): Nombre de la expansión de la carta.
%   - Numero (int): Número de la carta en la colección.
%   - Nombre (string): Tipo de energía (ej: "Agua", "Fuego").
% Argumentos de Salida:
%   - EC (TDA Card): Estructura resultante que representa la carta.
createEnergyCard(Expansion, Numero, Nombre, card(Expansion, Numero, Nombre, "Energia")).

:- module(tda_card, [createEnergyCard/4, createPokemonCard/13]).
:- use_module(tda_attack). % Necesitamos conocer los ataques para las cartas Pokémon

% =============================================================================
% TDA Card
% Representación: 
% - card_energy(Expansion, Numero, Nombre)
% - card_pokemon(Expansion, Numero, Nombre, EvolucionaDe, Ps, Tipo, Debilidad, Resistencia, CosteRetirada, EsEX, Habilidad, Ataques)
% =============================================================================

% --- CONSTRUCTORES ---

% Predicado: createEnergyCard/4
% Descripción: Crea una carta de energía básica.
% Tipo de algoritmo: No aplica (Hecho).
% Entrada: Expansion (string), Numero (int), Nombre (string).
% Salida: EC (TDA Card).
createEnergyCard(Expansion, Numero, Nombre, card_energy(Expansion, Numero, Nombre)).

% Predicado: createPokemonCard/13
% Descripción: Crea una carta de Pokémon validando que sus PS sean mayores a 0.
% Tipo de algoritmo: Evaluación lógica simple.
% Entrada: Expansion (string), Numero (int), Nombre (string), EvolucionaDe (string/null), 
%          Ps (int), Tipo (string), Debilidad (string/null), Resistencia (string/null), 
%          CosteRetirada (int), EsEX (boolean), Habilidad (Attack/null), Ataques (List Attack).
% Salida: PC (TDA Card).
createPokemonCard(Expansion, Numero, Nombre, EvolucionaDe, Ps, Tipo, Debilidad, Resistencia, CosteRetirada, EsEX, Habilidad, Ataques, 
                  card_pokemon(Expansion, Numero, Nombre, EvolucionaDe, Ps, Tipo, Debilidad, Resistencia, CosteRetirada, EsEX, Habilidad, Ataques)) :-



:- module(tda_card, [
createEnergyCard/4,
createPokemonCard/13,
createTrainerCard/7,
getCardName/2,
isBasicPokemon/1,
isBasicEnergy/1
]).
:- use_module(tda_attack).

% =============================================================================
% TDA Card
% Representación:
% - card_energy(Expansion, Numero, Nombre)
% - card_pokemon(Expansion, Numero, Nombre, EvolucionaDe, Ps, Tipo, Debilidad, Resistencia, CosteRetirada, EsEX, Habilidad, Ataques)
% - card_trainer(Expansion, Numero, Nombre, Tipo, Texto, PredicadoAsociado)
% =============================================================================

% --- CONSTRUCTORES ---

% Predicado: createEnergyCard/4
% Descripción: Crea una carta de energía básica.
% Tipo de algoritmo: Asignación directa.
% Entrada: Expansion (string), Numero (int), Nombre (string).
% Salida: EC (TDA Card).
createEnergyCard(Expansion, Numero, Nombre, card_energy(Expansion, Numero, Nombre)).

% Predicado: createPokemonCard/13
% Descripción: Crea una carta de Pokémon validando que sus PS sean mayores a 0.
% Tipo de algoritmo: Evaluación lógica simple.
% Entrada: Expansion (string), Numero (int), Nombre (string), EvolucionaDe (string/null), Ps (int), Tipo (string), Debilidad (string/null), Resistencia (string/null), CosteRetirada (int), EsEX (boolean), Habilidad (Attack/null), Ataques (List).
% Salida: PC (TDA Card).
createPokemonCard(Expansion, Numero, Nombre, EvolucionaDe, Ps, Tipo, Debilidad, Resistencia, CosteRetirada, EsEX, Habilidad, Ataques,
card_pokemon(Expansion, Numero, Nombre, EvolucionaDe, Ps, Tipo, Debilidad, Resistencia, CosteRetirada, EsEX, Habilidad, Ataques)) :-
Ps > 0.

% Predicado: createTrainerCard/7
% Descripción: Crea una carta de entrenador (partidario u objeto).
% Tipo de algoritmo: Asignación directa.
% Entrada: Expansion (string), Numero (int), Nombre (string), Tipo (string), Texto (string), PredicadoAsociado (predicate).
% Salida: C (TDA Card).
createTrainerCard(Expansion, Numero, Nombre, Tipo, Texto, PredicadoAsociado,
card_trainer(Expansion, Numero, Nombre, Tipo, Texto, PredicadoAsociado)).

% --- SELECTORES Y FUNCIONES DE PERTENENCIA (Apoyo para RF06) ---

% Predicado: getCardName/2
% Descripción: Obtiene el nombre de cualquier tipo de carta.
getCardName(card_energy(_, , Nombre), Nombre).
getCardName(card_pokemon(, _, Nombre, _, _, _, _, _, _, _, _, ), Nombre).
getCardName(card_trainer(, _, Nombre, _, _, _), Nombre).

% Predicado: isBasicPokemon/1
% Descripción: Verifica si la carta es un Pokémon Básico (EvolucionaDe es null).
isBasicPokemon(card_pokemon(_, _, _, null, _, _, _, _, _, _, _, _)).

% Predicado: isBasicEnergy/1
% Descripción: Verifica si la carta es una energía básica.
isBasicEnergy(card_energy(_, _, _)).
    Ps > 0. % Validacion exigida en RF04: Los PS no pueden ser 0 ni negativos.