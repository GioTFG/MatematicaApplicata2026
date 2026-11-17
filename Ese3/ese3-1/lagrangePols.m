%% -- Esercitazione 3 -- %%
%% - Esercizio 1: Funzione lagrangePols(xNodi) - %%

% Dati i punti nodali in ingresso (xNodi), 
% restitisce un array con i singoli polinomi della base Lagrangiana.

function outputArr = lagrangePols(xNodi, faiStampa)
arguments
    xNodi {mustBeNumeric, mustBeVector} % Valori x dei nodi in forma di array
    faiStampa (1,1) logical = false     % Se true, stampa i polinomi trovati in forma simbolica
end

    syms xSym               % Usato per stampare in forma simbolica i polinomi
    nNodi = numel(xNodi);
    outputArr = cell(1,nNodi);

    for i = 1:nNodi
        xAltriNodi = xNodi([1:i-1 i+1:end]);
        if faiStampa        % Logica di stampa simbolica
            pol = expand(prod((xSym - xAltriNodi) ./ (xNodi(i) - xAltriNodi)));
            fprintf('l_{%d}(x) = ', i);
            pretty(pol);
            fprintf("\n");
        end

        outputArr{i} = @(x) prod((x-xAltriNodi)./(xNodi(i)-xAltriNodi));
    end
end