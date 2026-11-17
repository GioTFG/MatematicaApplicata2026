%% -- Esercitazione 3 -- %%
% - Esercizio 2: Creazione delle tabelle delle differenze divise - %

function [tabella] = diffDivise(x, y)    
% Calcola la tabella delle differenze divise.
%
%   tabella = diffDivise(x, y) restituisce la tabella delle differenze
%   divise associate ai vettori x e y.
%
%   Input:
%       x - vettore contenente i nodi di interpolazione
%       y - vettore contenente i valori della funzione nei nodi x
%
%   Output:
%       tabella - tabella triangolare delle differenze divise
    
    arguments
        x {mustBeNumeric, mustBeVector}
        y {mustBeNumeric, mustBeVector}
    end
    
    if numel(x) ~= numel(y)
        error('x e y devono avere la stessa dimensione.')
    end
    
    x = x(:); % Trasformazione dei vettori per renderli entrambi colonna
    y = y(:);
    n = numel(x);
    tabella = zeros(n, n, 'like', y);
    tabella(:, 1) = y;
    
    for j = 2:n
        tabella(1:n-j+1, j) = ...
            (tabella(2:n-j+2, j-1) - tabella(1:n-j+1, j-1)) ./ ...
            (x(j:n) - x(1:n-j+1));
    end
end