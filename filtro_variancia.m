
function filtro_variancia = filtro_variancia(imagenoisy, filtradamedia, janela)

% Calcula variância local da imagem de acordo com a janela
% cada pixel da janela recebe o valor do pixel original^2 - valor do pixel
% filtrado(media)^2 e tudo isso dividido pela quantidade de pixels janela
fprintf('\nCalculando Variância...');
filtradavar = zeros(size(imagenoisy));
[lin, col] = size(filtradamedia);
hW = floor(janela/2);
W = janela;

for i = 1 : lin
    for j = 1 : col
        filtradavar(i,j) = abs((imagenoisy(i,j)-filtradamedia(i,j))^2);
    end
end
filtradavar = filtro_media(filtradavar, janela);

fprintf('Cálculo da variância encerrado.');

filtro_variancia = filtradavar;  % Apply Filtro de Variância
