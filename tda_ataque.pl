:- module(tda_attack, [createAttack/6]).

% =============================================================================
% TDA Attack
% Representación: attack(Coste, Nombre, Descripcion, Danio, Predicado)
% =============================================================================

% --- CONSTRUCTORES ---

% Predicado: createAttack/6
% Descripción: Crea una estructura que representa un ataque Pokémon.
% Tipo de algoritmo/estrategia: No aplica (Asignación directa / Hecho).
% Argumentos de entrada (dominio):
%   - Cost: Lista de listas con el coste de energía (ej: [[1, "Psiquico"]]).
%   - Nombre: String con el nombre del ataque.
%   - Descripcion: String con el efecto del ataque.
%   - Dagno: Entero con el daño que produce el ataque.
%   - PredicadoAsociado: Predicado Prolog asociado a efectos adicionales.
% Argumentos de salida (recorrido):
%   - A (TDA Attack): Estructura resultante del ataque.
createAttack(Cost, Nombre, Descripcion, Dagno, PredicadoAsociado, 
             attack(Cost, Nombre, Descripcion, Dagno, PredicadoAsociado)).