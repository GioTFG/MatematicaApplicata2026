%% -- Esercitazione 3 -- %%
% - Esercizio 1 - %

% -- Pulizia del workspace --
clear; clc; close all;

% -- Valori dati nella traccia -- %
puntiDati = [
    1, 2, 3, 4, 5, 6, 7;
    2.31, 2.01, 1.80, 1.66, 1.55, 1.47, 1.41
];

%TODO:
% - Inserire polinomio di Newton completo giusto per completezza
% - Aggiustare approssimazione polinomiale Newton a tratti ogni 3 punti
% (Hermite).
% - Approssimazione con spline lineare (??? Non è una parabola)
% - Approssimazione con spline cubica normale (??? Non è una parabola)
% --> Spline quadratica
% - Trovare alpha, beta, gamma sperimentalmente 

% -- Valori di alpha, beta, gamma per le 35 combinazioni di 3 punti tra i 7 dati --

% - Generazione delle combinazioni di tre punti - %
combinazioniPunti = nchoosek(1:size(puntiDati, 2), 3);
numCombinazioni = size(combinazioniPunti, 1);
coefficienti = zeros(numCombinazioni, 3);
erroriCoefficienti = zeros(numCombinazioni, 1);

%% - Calcolo dei coefficienti per ogni combinazione di tre punti - %
for indiceCombinazione = 1:numCombinazioni
    indici = combinazioniPunti(indiceCombinazione, :);
    coefficienti(indiceCombinazione, :) = polyfit(puntiDati(1, indici), puntiDati(2, indici), 2);

    valoriStimati = polyval(coefficienti(indiceCombinazione, :), puntiDati(1, :));
    erroriCoefficienti(indiceCombinazione) = sum(abs(valoriStimati - puntiDati(2, :)));
end

[coefficienti erroriCoefficienti]
erroreMinimo = min(erroriCoefficienti);
righeErroreMinimo = find(erroriCoefficienti == erroreMinimo);

%[righeErroreMinimo, coefficienti(righeErroreMinimo, :), erroriCoefficienti(righeErroreMinimo)]

%% -- Approssimazione polinomiale di Newton -- %
%  - Differenze divise - %
xPunti = puntiDati(1, :);
yPunti = puntiDati(2, :);
numPunti = numel(xPunti);

differenzeDivise = diffDivise(xPunti, yPunti)

% Interpolazione di sesto grado
coefficientiNewtonCompleto = differenzeDivise(1, :);
syms x
polNewtonCompletoSym = sym(0);
termineNewton = sym(1);

for k = 1:numPunti
    polNewtonCompletoSym = polNewtonCompletoSym + ...
        differenzeDivise(1, k) * termineNewton;
    termineNewton = termineNewton * (x - xPunti(k));
end

polNewtonCompletoSym = expand(polNewtonCompletoSym);
fprintf("Polinomio di Newton completo:\n"); pretty(polNewtonCompletoSym);

% Interpolazione a tratti ogni tre punti, di secondo grado
% Terza colonna, coefficienti alterni
coefficientiNewtonTratti = differenzeDivise(1:2:end-2, 1:3)

syms x
startIdx = 1:2:(numPunti - 2);    % Polinomio a tratti creato in maniera dinamica
if startIdx(end) ~= numPunti - 2
    startIdx(end + 1) = numPunti - 2;
end

args = cell(1, 2 * numel(startIdx) + 1);

for k = 1:numel(startIdx)
    idx = startIdx(k):(startIdx(k) + 2);

    coeff = polyfit(xPunti(idx), yPunti(idx), 2);
    polTratto = poly2sym(coeff, x);

    if k < numel(startIdx)
        cond = x >= xPunti(idx(1)) & x < xPunti(idx(end));
    else
        cond = x >= xPunti(idx(1)) & x <= xPunti(idx(end));
    end

    args{2 * k - 1} = cond;
    args{2 * k} = polTratto;
end

args{end} = sym(NaN);   % valore fuori dall'intervallo
polNewtonTrattiSym = piecewise(args{:});
fprintf("Polinomio di Newton a tratti:\n"); pretty(polNewtonTrattiSym);

%% Grafici
paddingXLim = 1;

% -- Interpolazioni a confronto --
figure;
xq = linspace(min(xPunti)-paddingXLim, max(xPunti)+paddingXLim, 500);
graf2a1 = plot(xq, double(subs(polNewtonTrattiSym,x,xq)), 'r-', LineWidth=2); % Polinomio a tratti Newton
hold on;
graf2a2 = plot(xq, double(subs(polNewtonCompletoSym,x,xq)), 'b-', LineWidth=1); % Polinomio Newton completo
graf2a3 = plot(xq, interp1(xPunti, yPunti, xq, "linear"), "g-", LineWidth=1.3); % Spline lineare
graf2a4 = plot(xq, interp1(xPunti, yPunti, xq, "spline"), "c-", LineWidth=3); % Spline cubica (??)

plot(xPunti, yPunti, ".k", MarkerSize=15);

ylim([1.25 2.5]);
grid on; grid minor;
hold off;