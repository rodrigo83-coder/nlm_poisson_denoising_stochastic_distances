        fprintf('\nGerando imagens Ailton');
        DATA = load('base_sinograma.mat');
        sinogram_reference = DATA.sinogram_reference;
        sinogram_noisy     = DATA.sinogram_noisy;
        filtradamedia = filtro_media(sinogram_noisy, 5);
        originalreconstruido = retroprojecao(sinogram_reference);
        ruidosoreconstruido = retroprojecao(filtradamedia);
        subplot(1,5,1);imshow(sinogram_reference,[]);title('Sin.Original');
        subplot(1,5,2);imshow(sinogram_noisy,[]);title('Sin.Ruidoso');
        subplot(1,5,3);imshow(filtradamedia,[]);title('Sin.Ruidoso Media');
        subplot(1,5,4);imshow(originalreconstruido,[]);title('Shepp Original');
        subplot(1,5,5);imshow(ruidosoreconstruido,[]);title('Shepp Media');
        