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
    Ps > 0. % Validacion exigida en RF04: Los PS no pueden ser 0 ni negativos.