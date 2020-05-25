function [] = read_results(in_dir, string_dist, string_sinogram)
%Parameters: 
%Result address
%Filter algorithm
%synogram
%This algorithm must be configured according to the reading needs.

    filename = strcat('results-',string_sinogram{1},'-', string_dist{1},'-6-5','*.mat');
    Files=dir(strcat(in_dir, filename));
    
    for k=1:length(Files)
        fname = strcat(in_dir, Files(k).name);
        fprintf('\n******* PROCESSING <%s> \n', Files(k).name);
        DATA = load(fname); 
        
        if (    ~isfield(DATA, 'fbp') || ~isfield(DATA, 'pocs') || ~isfield(DATA, 'sinogram_denoised') ||...
                ~isfield(DATA, 'sinogram_noisy')|| ~isfield(DATA, 'sinogram_reference'))
            error('Arquivo n??o parece v??lido');
        end
        
        fbp  = DATA.fbp;
        pocs = DATA.pocs;
        sin = DATA;
        
        fprintf('** FBP **');        
        fprintf('\nRuidoso: psnr: %f; ssim: %f; h: %f; by FBP;',fbp.ruidoso.psnr_result, fbp.ruidoso.ssim_result, DATA.sigma); 
        fprintf('\nFiltrado: psnr: %f; ssim: %f; h: %f; by FBP\n;',fbp.filtrado.psnr_result, fbp.filtrado.ssim_result, DATA.sigma); 
        fprintf('** POCS **'); 
        fprintf('\nRuidoso: psnr: %f; ssim: %f; h: %f; by POCS;',pocs.ruidoso.psnr_result, pocs.ruidoso.ssim_result, DATA.sigma); 
        fprintf('\nFiltrado: psnr: %f; ssim: %f; h: %f; by POCS;\n',pocs.filtrado.psnr_result, pocs.filtrado.ssim_result, DATA.sigma); 

        
        subplot(3,3,1);imshow(sin.sinogram_reference,[]);title('Sin.Original');
        subplot(3,3,2);imshow(sin.sinogram_noisy,[]);title('Sin.Ruidoso');
        subplot(3,3,3);imshow(sin.sinogram_denoised,[]);title('Sin.Filtrado');
        subplot(3,3,4);imshow(fbp.phantom_original_retro,[]);title('Imagem Original FBP');
        subplot(3,3,5);imshow(fbp.phantom_original_ruidoso_retro,[]);title('Imagem Ruidosa FBP');
        subplot(3,3,6);imshow(fbp.phantom_ruidoso_filtrado_retro,[]);title('Imagem Filtrada FBP');
        subplot(3,3,7);imshow(pocs.phantom_original_pocs,[]);title('Imgagem Original POCS');
        subplot(3,3,8);imshow(pocs.phantom_original_ruidoso_pocs,[]);title('Imagem Ruidosa POCS');
        subplot(3,3,9);imshow(pocs.phantom_ruidoso_filtrado_pocs,[]);title('Imagem Filtrada POCS');

 
    end
    
 
end