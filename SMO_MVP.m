%
% Implementación de algoritmo SMO
%
% Sequential minimal optimization with maximum
% violating pair working set selection (SMO MVP)
%
% Bottou & Lin - Support Vector Machines Solvers (2006)
%
% Resuelve:     max sum(a_i) - 0.5 sum(y_i a_i y_j a_j K_ij)
%               s.a. 0 <= a_i <= C para toda i
%                    sum_i(y_i a_i) = 0
%
% Notación:
% - a := alpha
% - l := lambda
% - g := gradiente
%
% Entradas:
% - X: matriz de datos                       (R^mxn)
% - y: vector con etiquetas en {-1, 1}       (Z)
% - C: trade-off entre tamaño de violaciones (R)
%
% Salidas:
% - a: coeficientes de solución              (R^n)
% - obj: valor de la función objetivo        (R)
% - brecha: brecha de dualidad               (R)
% - n_iter: número de iteraciones            (Z)
% - t: tiempo de ejecución en segundos       (R)
%
% Omar Trejo Navarro
% Modelos matemáticos y numéricos
% Prof. José Luis Morales Pérez
% ITAM, 2015
%
% TODO:
% - Arreglar condición de brecha
% - Arreglar kernel gaussiano
% - No calcular todo el kernel
% - Probar con varios problemas
%
function [a, obj, brecha, n_iter, t] = SMO_MVP(X, y, C)

    format shortEng;
    format compact;

    % Inicialización
    n = length(y);
    a = zeros(n, 1);
    g = ones(n, 1);

    % Parámetros
    EPS = 10e-6;
    max_iter = n;

    % Calcular kernel
    K = calcular_kernel(X, 'lineal');

    % Calcular A y B con (7)
    A = zeros(n, 1);
    B = zeros(n, 1);
    A(find(y == -1)) = -C;
    B(find(y ==  1)) =  C;

    fprintf('iter      obj           brecha        brecha_diff \n');
    fprintf('---------------------------------------------------\n');

    n_iter = 0;
    brecha = Inf;
    t_inicial = tic;
    terminado = false;

    while ~terminado && n_iter < max_iter

        % Máxima violación
        ya = y.*a;
        yg = y.*g;
        yg_aux_B = yg;
        yg_aux_A = yg;
        yg_aux_B(ya > B) = -Inf;
        yg_aux_A(ya < A) =  Inf;
        [~, i] = max(yg_aux_B);
        [~, j] = min(yg_aux_A);

        brecha_anterior = brecha;
        brecha = yg(i) - yg(j);
        brecha_diff = abs(brecha - brecha_anterior);

        % Revisar optimalidad
        if brecha < EPS || abs(brecha_diff) < EPS
            terminado = true;
        end

        % Búsqueda de dirección
        % (usa información de segundo orden)
        l = min(min(B(i) - ya(i), ya(j) - A(j)), ...
                (yg(i) - yg(j))/(K(i,i) + K(j,j) - 2*K(i,j)));

        % Actualización
        g = g - l*y.*K(:,i) + l*y.*K(:,j);
        a(i) = a(i) + y(i)*l;
        a(j) = a(j) - y(j)*l;

        % Información
        n_iter = n_iter + 1;
        obj = ones(n, 1)'*a - 0.5*ya'*K*ya;
        fprintf('%5d  %15e  %10e  %10e\n', ...
                n_iter, obj, brecha, brecha_diff);
    end

    fprintf('\nDimensión de alpha:       %d\n', n);
    fprintf('Alphas != 0:              %d\n', sum(a ~= 0));

    t = toc(t_inicial);
    fprintf('\nTiempo: %f\n\n', t);
end