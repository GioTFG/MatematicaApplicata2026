%% -- Esercitazione 3 -- %%
%% - Esercizio 1 - %%

%-- Pulizia Workspace
clear; clc; close all;

%-- Dati iniziali
f = @(x,y) x.^2 + y.^2; % Funzione data
domF = [
    -1, 1; % Dominio di f sulle x
    -2, 2  % Dominio di f sulle y
];

%-- Densità punti nodali di interpolazione
n = 5; m = 5;
hx = (domF(1,2) - domF(1,1)) / (n - 1);
hy = (domF(2,2) - domF(2,1)) / (m - 1);

%-- Definizione dei punti nodali
xNodi = domF(1,1):hx:domF(1,2);
yNodi = domF(2,1):hy:domF(2,2);

%-- Basi del polinomio di Lagrange per x e per y
fprintf("-- BASE PER X --\n");
xBaseLagrange = lagrangePols(xNodi, true);  % True a entrambi per stampare i polinomi trovati
fprintf("-- BASE PER Y --\n");
yBaseLagrange = lagrangePols(yNodi, true);

%- Valori della funzione sui punti nodali
% (Per il calcolo del polinomio interpolatore)
[Xg, Yg] = ndgrid(xNodi, yNodi);
Fg = f(Xg, Yg);

%- Creazione del polinomio interpolatore di Lagrange
syms xSym ySym

polLagrangeSym = sym(0);        % Creazione simbolica (usata per la stampa dei valori dei coefficienti)
for i = 1:numel(xNodi)
    for j = 1:numel(yNodi)
        polLagrangeSym = polLagrangeSym + Fg(i,j) * xBaseLagrange{i}(xSym) * yBaseLagrange{j}(ySym);
    end
end

polLagrangeSym = expand(polLagrangeSym);
disp(polLagrangeSym)    % Stampa del polinomio trovato (simbolico)

polLagrangeHandle = matlabFunction(polLagrangeSym, 'Vars', [xSym, ySym]);

% Creazione dei punti a griglia usati per la creazione dei grafici
[Xplot, Yplot] = meshgrid(linspace(domF(1,1), domF(1,2), 50), ...
    linspace(domF(2,1), domF(2,2), 50));

%- Creazione del polinomio interpolatore lineare con interp2
Zinterp = interp2(xNodi, yNodi, Fg.', Xplot, Yplot);

%-- Grafico 1A
%-- Visualizzazione della funzione e dell'interpolante di Lagrange
figure;
graf1a1 = surf(Xplot, Yplot, f(Xplot, Yplot), ...
    'FaceAlpha', 0.4, 'EdgeColor', 'b', 'FaceColor', 'b');
hold on;

graf1a2 = surf(Xplot, Yplot, polLagrangeHandle(Xplot, Yplot), ...
    'FaceAlpha', 0.4, 'EdgeColor', 'none', 'FaceColor', 'r');

graf1a3 = plot3(Xg, Yg, Fg, ...
    ".k", MarkerSize=15);

legend([graf1a1 graf1a2 graf1a3(1)], ...
    { ...
        "$f(x,y)$", ...
        "$p(x,y)$", ...
        "Punti nodali" ...
    }, ...
    Interpreter="latex", ...
    Location= 'best' ...
);

xlabel('$x$', Interpreter='latex'); 
ylabel('$y$', Interpreter='latex');
zlabel("$z$", Interpreter="latex");
title({ ...
    "Grafico 1A", ...
    "Funzione e polinomio approssimante di Lagrange" ...
});
grid on; view(3); hold off;

%- Grafico 1B
figure;
graf1b1 = surf(Xplot, Yplot, f(Xplot, Yplot), ...
    FaceColor='r', ...
    FaceAlpha=0.5, ...
    EdgeColor='none' ...
);
hold on;
graf1b2 = surf(Xplot, Yplot, Zinterp, ...
    FaceColor='none', ...
    EdgeColor='b' ...
);
graf1b3 = plot3(Xg, Yg, Fg, '.k', MarkerSize=15);

title({ ...
    "Grafico 1B", ...
    "Funzione e polinomio approssimante di interp2" ...
});
legend( ...
    [graf1b1, graf1b2, graf1b3(1)], ...
    {"Polinomio interp2", "Funzione $f(x,y)$", "Punti nodali"}, ...
    Interpreter= 'latex', ...
    Location= 'best' ...
);

xlabel('$x$', Interpreter='latex'); 
ylabel('$y$', Interpreter='latex');
zlabel("$z$", Interpreter="latex");

hold off;

%- Calcolo dell'errore
erroreLagr = @(x,y) abs(f(x,y) - polLagrangeHandle(x,y));
erroreLagrPlot = erroreLagr(Xplot, Yplot);
erroreLagrMassimo = max(erroreLagrPlot(:));
fprintf('Errore massimo per Lagrange: %.6e\n', erroreLagrMassimo);

erroreInterp2 = @(x,y) abs(f(x,y) - interp2(xNodi, yNodi, Fg.', x, y));
erroreInterp2Plot = erroreInterp2(Xplot, Yplot);
[erroreInterp2Massimo, idxErroreInterp2Max] = max(erroreInterp2Plot(:));

[rMax, cMax] = ind2sub(size(erroreInterp2Plot), idxErroreInterp2Max);
[xMax, yMax] = deal(Xplot(rMax, cMax), Yplot(rMax, cMax));

fprintf('Errore massimo per interp2: %.6e\n', erroreInterp2Massimo);
fprintf('Trovato nel punto (%.3e, %.3e)\n', xMax, yMax);

%-- Visualizzazione dell'errore sull'intera griglia
figure;
graf1c1 = surf(Xplot, Yplot, erroreLagr(Xplot, Yplot), 'EdgeColor', 'none');
hold on;

graf1c2 = surf(Xplot, Yplot, erroreInterp2(Xplot, Yplot), ...
    FaceAlpha=0.3, ...
    FaceColor='r', ...
    EdgeColor='r'...
);
graf1c3 = plot3(Xg, Yg, erroreLagr(Xg, Yg), ".k", MarkerSize=15);

xlabel('$x$', Interpreter='latex'); 
ylabel('$y$', Interpreter='latex'); zlabel('Errori');
title({ ...
    "Grafico 1C", ...
    "Errori di approssimazione" ...
});

legend([graf1c1, graf1c2, graf1c3(1)], ...
    { ...
        sprintf("Errore di $p_{%d, %d}$ (Lagrange)", n, m), ...
        sprintf("Errore di interp2 (Interpolazione lineare sui punti)"), ...
        sprintf("Punti nodali") ...
    }, ...
    Interpreter="latex", ...
    Location="best" ...
);

grid on; hold off;