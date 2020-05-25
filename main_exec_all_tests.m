%Rodrigo C?sar Evangelista
%rodrigo.evangelista@muz.ifsuldeminas.edu.br

%Before executing the code, make the necessary adjustments for processing and reading the results.

%choose image for processing
string_sinogram = {'shepplogan'}; 
%or
%string_sinogram = {'shepplogan';'homogeneo80';'simetrico80';'assimetrico50';'madeira1';'madeira2'};

%choose algorithm filter for execution
string_dist = {'kleibler'};
%algorithms of this work {'kleibler';'renyi';'hellinger';'bhattacharyya'}

%search folder for synograms and images
path_sinogram = '/Users/rodrigo/Documents/MATLAB/Projeto_NLM_Rodrigo_Final/sinograma/';

%results folder
path_reconstruction = '/Users/rodrigo/Documents/MATLAB/Projeto_NLM_Rodrigo_Final/resultados/';


%Below are separate codes for reading results and processing images / phantoms.

%result reading algorithm. Parameters: Result address, filter algorithm and synogram.
for d=1:length(string_dist)
    read_results('/Users/rodrigo/Documents/MATLAB/Projeto_NLM_Rodrigo_Final/', string_dist(d), string_sinogram);
end 


%image processing algorithm. 
%Parameters: 
%search_window_size (search window)
%patch_size (similarity window)
%sigma
%janelamedia (media filter window size)
%string_dist (filter/algorithm)%
%path_sinogram (image address/folder for synograms and images)
%path_reconstruction (results folder)
%string_sinogram (synogram to be filtered)
for s=1:length(string_sinogram)
  for d=1:length(string_dist)
    exec_test(6, 3, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
  end
end


%Below are some detailed execution examples
for d=1:length(string_dist)
    read_results('/Users/rodrigo/Documents/MATLAB/Projeto_NLM_Rodrigo_Final/', string_dist(d), string_sinogram);
end 

Ti = tic;
for s=1:length(string_sinogram)
  for d=1:length(string_dist)
        distancia = string_dist(d);
        sinograma = string_sinogram(s);
        exec_test(2, 1, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(3, 1, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(3, 2, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(4, 1, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(4, 2, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(4, 3, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(5, 1, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(5, 2, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(5, 3, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(5, 4, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(6, 1, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(6, 2, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(6, 3, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(6, 4, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(6, 5, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
  end
end
time = toc(Ti);

for d=1:length(string_dist)
    read_results('/Users/rodrigo/Documents/MATLAB/Projeto_NLM_Rodrigo_Final/', string_dist(d), string_sinogram);
end 

exec_test(6, 4, 0.1, 3, string_dist(1), path_sinogram, path_reconstruction, string_sinogram(1));


for i=1:length(string_dist)
    for d=1:length(string_sinogram)
        exec_test(7, 3, 2, 3, string_dist(i), path_sinogram, path_reconstruction, string_sinogram(d));
        %exec_test(0, 0, 0, 0, string_dist(1), path_sinogram, path_reconstruction, string_sinogram(d));%at_bm3d
    end
end
%independentemente se o algoritmo utiliza ou n?o janelas, elas devem ser
%passadas por par?metro, mesmo com valor 0



for d=1:length(string_sinogram)
    read_results('/Users/rodrigo/Documents/MATLAB/Projeto_NLM_Rodrigo_Final/', string_dist, string_sinogram(d));
end        

Ti = tic;
for s=1:length(string_sinogram)
  for d=1:length(string_dist)
        distancia = string_dist(d);
        sinograma = string_sinogram(s);
        exec_test(2, 1, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(3, 1, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(3, 2, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(4, 1, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(4, 2, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(4, 3, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(5, 1, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(5, 2, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(5, 3, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(5, 4, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(6, 1, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(6, 2, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(6, 3, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(6, 4, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(6, 5, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
  end
end
time = toc(Ti);

read_results('/Users/rodrigo/Documents/MATLAB/Projeto_NLM_Rodrigo_Final/', string_dist, string_sinogram);

for d=1:length(string_sinogram)
    read_results('/Users/rodrigo/Documents/MATLAB/Projeto_NLM_Rodrigo_Final/', string_dist, string_sinogram(d));
end        



