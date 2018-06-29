%
% Calcular kernel
%
% Inputs:
% - X: matriz de datos
% - kernel: nombre de kernel
% - gamma: parámetro gamma
%          (polinomal o gaussiano)
% - d: parámetro d
%          (polinomial)
%
% Output:
% - K: Matriz con kernel
%
% Omar Trejo Navarro
% Modelos matemáticos y numéricos
% Prof. José Luis Morales Pérez
% ITAM, 2015
%
% TODO: Arreglar kernel gaussiano
%
function K = calcular_kernel(X, kernel, gamma, d)

    switch kernel

      case 'lineal'
        K = X'*X;

      case 'polinomial'
        K = gamma.*(X'*X + 1).^d;

      case 'gaussiano'
        % TODO: Revisar
        n_cols = size(X, 2);
        suma_cols = sum(X.^2, 1);
        diferencia = -2*X'*X + ...
            (ones(n_cols, 1)*suma_cols)' + ...
            ones(n_cols, 1)*suma_cols;
        K = exp(-gamma.*diferencia);

      otherwise
        error(['Kernel no implementable: ' kernel])
    end
end