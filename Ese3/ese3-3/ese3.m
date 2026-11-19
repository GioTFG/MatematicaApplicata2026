%% -- Esercitazione 3 -- %%
% - Esercizio 3 - %

% -- Pulizia del workspace --
clear; clc; close all;

% -- Valori dati nella traccia -- %
ptiFunz = [
    0, 0.25, 0.5, 0.75, 1;
    0, 0.75, 1, 0.75, 0
];

%% Creazione polinomio interpolatore di Newton
syms x; assume(x, 'real');
n = numel(ptiFunz(1,:));
basiLagrange = sym(zeros(1, n)); % Inizializzazione polinomi simbolici


for i = 1:n
    xi = ptiFunz(1, i);
    altri = ptiFunz(1, [1:i-1, i+1:end]);
    basiLagrange(i) = prod((x - altri) ./ (xi - altri));
end

polLagrangeSym = sum(ptiFunz(2,:) .* basiLagrange);
polLagrangeSym = expand(polLagrangeSym);

% Output:
fprintf("Basi del polinomio di Lagrange:\n");
for i = 1:numel(basiLagrange)
    disp("L_" + i + ": ");
    disp((basiLagrange(i)));
end

fprintf("Polinomio interpolatore:\n");
pretty(polLagrangeSym);
