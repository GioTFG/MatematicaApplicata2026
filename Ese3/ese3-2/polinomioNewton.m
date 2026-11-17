%% -- Esercitazione 3 -- %%
% - Esercizio 2: Costruzione del polinomio di Newton - %

function pol = polinomioNewton(var, x, coefficienti, indici)
    % POLINOMIONEWTON Costruisce il polinomio di Newton in forma simbolica.
    %
    %   pol = polinomioNewton(x, coefficienti, indici) restituisce il
    %   polinomio di Newton come espressione simbolica nella variabile x.
    %
    %   Input:
    %       var          - variabile simbolica del polinomio
    %       x            - Valori x ordinati con i coefficienti di Newton
    %       coefficienti - Coefficienti del polinomio
    %       nIndici      - numero di coefficienti da considerare
    %
    %   Output:
    %       pol          - polinomio simbolico in forma di Newton
    
    arguments
        var {mustBeSymbolicScalar}
        x {mustBeNumeric, mustBeVector, mustBeNonempty, mustBeFinite}
        coefficienti {mustBeNumeric, mustBeVector, mustBeNonempty, mustBeFinite}
        indici {mustBeNumeric, mustBeVector, mustBeNonempty, mustBeFinite} ...
            = numel(coefficienti)
    end

    for i = 1:indici        
        if i == 1
            pol = sym(coefficienti(1));
        else
            pol = pol + coefficienti(i) * prod(var - x(1:i-1));
        end
    end
end

function mustBeSymbolicScalar(x)
    if ~isa(x, 'sym') || ~isscalar(x)
        error('x deve essere uno scalare simbolico.');
    end
end