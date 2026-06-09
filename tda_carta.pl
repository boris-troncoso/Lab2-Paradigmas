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