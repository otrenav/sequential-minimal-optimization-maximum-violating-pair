%
% Archivo de pruebas para SMO
%
% Omar Trejo Navarro
% Modelos matemáticos y numéricos
% Prof. José Luis Morales Pérez
% ITAM, 2015
%

%
% Prueba aleatoria
%
C = 0.1;
n = 100;
X = 100*rand(n);
y = randi([0 1], n, 1);
y(y == 0) = -1;
[a, obj, brecha, n_iter, t] = SMO_MVP(X, y, C);


%
% Prueba para comparar con Mehrotra
%
C = 0.1;
data_set = 'wdbc';

if strcmp(data_set, 'wdbc')
    data_set = 'wdbc';
    [T, ~, ~, ~] = wdbcData('./data/wdbc.data', 30, 0.0, 1);
elseif strcmp(data_set, 'forest_fires')
    T = csvread('./data/forest_fires/forest_fires_clean.csv');
elseif strcmp(data_set, 'white_wines')
    T = csvread('./data/wine_quality/white_wines_quality_clean.csv');
else
    error(['You must specify a data set (wdbc, forest_fires, ' ...
           'or white_wines) as a string.'])
end

% Obtenemos las dimensiones
% y quitamos el identificador
[n_row, n_col] = size(T);
n_atr = n_col - 1;
X = T(1:n_row, 2:n_atr + 1);

% Escalamos la matriz y la transponemos
% para dejarla en términos del modelo
X = scale(X);
X = X';

% Reetiquetamos los
% valores que tenían 0
ind = T(:, 1) ~= 1;
T(ind, 1) = -1;

% Definimos las matrices
% de acuerdo al modelo
b = T(:, 1);
Y = diag(b);
A = X*Y;

fprintf('\n');
fprintf(' Data set                       %s  \n', data_set);
fprintf(' Number of samples              %3i \n', n_row);
fprintf(' Number of atributes            %3i \n', n_atr);

[a, obj, brecha, n_iter, t] = SMO_MVP(A, b, C);

