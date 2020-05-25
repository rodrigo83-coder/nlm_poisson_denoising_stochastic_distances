function [] = exec_test(search_window_size, patch_size, sigma, janelamedia, string_dist, path_sinogram, path_reconstruction, string_sinogram)

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

    
    if(strcmp(string_sinogram(1),'shepplogan'))
        fprintf('\nGerando imagens simuladas de Shepp-Logan...');
        %[sinogram_reference, sinogram_noisy] = gera_shepplogan(1);
        DATA = load('base_sinograma.mat');
        sinogram_reference = DATA.sinogram_reference;
        sinogram_noisy     = DATA.sinogram_noisy;
        
    else
        fprintf('\nGerando imagens simuladas Gerais...');
        % Reference Synogram (20s)
        sinogram_reference = open_file_proj(char(strcat(path_sinogram, string_sinogram, '_20s.dat')));
        % Noisy Synogram (3s)
        sinogram_noisy = open_file_proj(char(strcat(path_sinogram, string_sinogram, '_3s.dat')));
    end
    %sinogram_reference = sinogram_reference/max(sinogram_reference(:));
    %sinogram_noisy = sinogram_noisy/max(sinogram_noisy(:));
        
    T = tic; %start time
    
    if((strcmp(string_dist,'kleibler'))||(strcmp(string_dist,'renyi'))||(strcmp(string_dist,'hellinger'))||(strcmp(string_dist,'bhattacharyya')))
        %Media Filter
        filtradamedia = filtro_media(sinogram_noisy, janelamedia);
        %Variance Filter
        filtradavar = filtro_variancia(sinogram_noisy, filtradamedia, janelamedia);
        %Alpha Filter
        alpha = filtro_alpha(filtradamedia, filtradavar);
        %AlphaLine Filter
        alphaline = filtro_alphaline(alpha, sinogram_noisy, patch_size);
        %Betha Filter
        betha = filtro_betha(filtradamedia, filtradavar);
        %Bethaline Filter
        bethaline = filtro_bethaline(betha, patch_size);   
    end    
        
    if(strcmp(string_dist,'kleibler'))
        alphaline = alphaline/max(alphaline(:));
        bethaline = bethaline/max(bethaline(:));
        sinogram_denoised = nlm_versao_rodrigo(sinogram_noisy, search_window_size, patch_size, sigma, alphaline, bethaline);
    end
    if(strcmp(string_dist,'renyi'))
        capaline = alphaline;%Capaline Filter -> Capaline = alphaline
        tetaline = filtro_tetaline(bethaline, patch_size);%Tetaline Filter
        capaline = capaline/max(capaline(:));
        tetaline = tetaline/max(tetaline(:));
        sinogram_denoised = nlm_versao_rodrigo_re(sinogram_noisy, search_window_size, patch_size, sigma, capaline, tetaline);
        sinogram_denoised = abs(sinogram_denoised);   
    end
    if(strcmp(string_dist,'hellinger'))
        capaline = alphaline;%Capaline Filter -> Capaline = alphaline
        tetaline = filtro_tetaline(bethaline, patch_size);%Tetaline Filter
        capaline = capaline/max(capaline(:));
        tetaline = tetaline/max(tetaline(:));
        sinogram_denoised = nlm_versao_rodrigo_hellinger(sinogram_noisy, search_window_size, patch_size, sigma, capaline, tetaline);
        sinogram_denoised = abs(sinogram_denoised);   
    end
    if(strcmp(string_dist,'bhattacharyya'))
        capaline = alphaline;%Capaline Filter -> Capaline = alphaline
        tetaline = filtro_tetaline(bethaline, patch_size);%Tetaline Filter
        capaline = capaline/max(capaline(:));
        tetaline = tetaline/max(tetaline(:));
        sinogram_denoised = nlm_versao_rodrigo_battacharyya(sinogram_noisy, search_window_size, patch_size, sigma, capaline, tetaline);
        sinogram_denoised = abs(sinogram_denoised);   
    end
    
    [fbp.phantom_original_retro, fbp.phantom_original_ruidoso_retro,fbp.phantom_ruidoso_filtrado_retro] = fbpreconstruction(sinogram_reference,sinogram_noisy,sinogram_denoised, string_sinogram{1},path_reconstruction);
    fbp.phantom_original_retro = double(fbp.phantom_original_retro);
    fbp.phantom_original_ruidoso_retro = double(fbp.phantom_original_ruidoso_retro);
    fbp.phantom_ruidoso_filtrado_retro = double(fbp.phantom_ruidoso_filtrado_retro);
    
    fbp.ruidoso.psnr_result = psnr(fbp.phantom_original_ruidoso_retro,fbp.phantom_original_retro);
    fbp.ruidoso.ssim_result = ssim(fbp.phantom_original_ruidoso_retro,fbp.phantom_original_retro);
    fbp.ruidoso.epi2_result = EdgePreservationIndex_Laplacian(fbp.phantom_original_ruidoso_retro,fbp.phantom_original_retro);
    
    time = toc(T);
    %name_sinogram = string_sinogram(1);
    fprintf('\nRuidoso:\npsnr: %f; ssim: %f; epi2: %f; time: %f; h: %f; by FBP;',fbp.ruidoso.psnr_result, fbp.ruidoso.ssim_result, fbp.ruidoso.epi2_result, time, sigma); 
    fbp.filtrado.psnr_result = psnr(fbp.phantom_ruidoso_filtrado_retro,fbp.phantom_original_retro);
    fbp.filtrado.ssim_result = ssim(fbp.phantom_ruidoso_filtrado_retro,fbp.phantom_original_retro);
    fbp.filtrado.epi2_result = EdgePreservationIndex_Laplacian(fbp.phantom_ruidoso_filtrado_retro,fbp.phantom_original_retro);
    time = toc(T);
    fbp.time = time;
    fprintf('\nFiltrado:\npsnr: %f; ssim: %f; epi2: %f, time: %f; h: %f; by FBP;',fbp.filtrado.psnr_result, fbp.filtrado.ssim_result, fbp.filtrado.epi2_result, time, sigma); 
    
    [pocs.phantom_original_pocs, pocs.phantom_original_ruidoso_pocs, pocs.phantom_ruidoso_filtrado_pocs] = pocsreconstruction(sinogram_reference,sinogram_noisy,sinogram_denoised,string_sinogram{1},path_reconstruction);
    pocs.phantom_original_pocs = double(pocs.phantom_original_pocs);
    pocs.phantom_original_ruidoso_pocs = double(pocs.phantom_original_ruidoso_pocs);
    pocs.phantom_ruidoso_filtrado_pocs = double(pocs.phantom_ruidoso_filtrado_pocs);    
    
    pocs.ruidoso.psnr_result = psnr(pocs.phantom_original_ruidoso_pocs,pocs.phantom_original_pocs);
    pocs.ruidoso.ssim_result = ssim(pocs.phantom_original_ruidoso_pocs,pocs.phantom_original_pocs);   
    pocs.ruidoso.epi2_result = EdgePreservationIndex_Laplacian(pocs.phantom_original_ruidoso_pocs,pocs.phantom_original_pocs);    
    
    time = toc(T);
    fprintf('\nRuidoso:\npsnr: %f; ssim: %f; epi2: %f, time: %f; h: %f; by POCS;',pocs.ruidoso.psnr_result, pocs.ruidoso.ssim_result, pocs.ruidoso.epi2_result, time, sigma); 
    pocs.filtrado.psnr_result = psnr(pocs.phantom_ruidoso_filtrado_pocs,pocs.phantom_original_pocs);
    pocs.filtrado.ssim_result = ssim(pocs.phantom_ruidoso_filtrado_pocs,pocs.phantom_original_pocs);
    pocs.filtrado.epi2_result = EdgePreservationIndex_Laplacian(pocs.phantom_ruidoso_filtrado_pocs,pocs.phantom_original_pocs);    
    time = toc(T);
    pocs.time = time;
    fprintf('\nFiltrado:\npsnr: %f; ssim: %f; epi2: %f, time: %f; h: %f; by POCS;',pocs.filtrado.psnr_result, pocs.filtrado.ssim_result, pocs.filtrado.epi2_result, time, sigma); 
    
    sigma_str = strrep(num2str(sigma), '.', '');%Remove '.' Not to give problem in the file name
    name = strcat('results-', string_sinogram{1},'-', string_dist{1},'-');
    %out_file_name = strcat('results-', dist_str, '-', sin_str, '-', num2str(search_window_size), '-',num2str(patch_size), '-', sigma_str, '-', num2str(janelamedia), '.mat');
    out_file_name = strcat(name, num2str(search_window_size), '-',num2str(patch_size), '-', sigma_str, '-', num2str(janelamedia), '.mat');
    save(out_file_name, 'sinogram_reference', 'sinogram_noisy', 'sinogram_denoised', 'fbp', 'pocs','sigma');
end
