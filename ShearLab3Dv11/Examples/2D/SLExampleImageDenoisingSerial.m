tic;
fprintf('\n---SLExampleImageDenoisingSerial---\n');
fprintf('loading image... ');

clear;
%%settings
sigma = 30;
scales = 4;
shearLevels = [1 1 2 2];
thresholdingFactor = 3;
fullSystem = 0;
useGPU = 0;

%%load data
X = imread('kodim12.jpg');
X = double(X);

%%add noise
Xnoisy = X + sigma*randn(size(X));

elapsedTime = toc;
fprintf([num2str(elapsedTime), ' s\n']);
tic;
fprintf('preparing serial processing... ');

%%prepare serial processing
[Xfreq, Xrec, preparedFilters, dualFrameWeightsCurr, shearletIdxs] = SLprepareSerial2D(useGPU,Xnoisy,scales,shearLevels,fullSystem);


elapsedTime = toc;
fprintf([num2str(elapsedTime), ' s\n']);
tic;
fprintf('decomposition, thresholding and reconstruction... ');

for j = 1:size(shearletIdxs,1)
    shearletIdx = shearletIdxs(j,:);
    %%shearlet decomposition
    [coeffs,shearlet, dualFrameWeightsCurr,RMS] = SLsheardecSerial2D(Xfreq,shearletIdx,preparedFilters,dualFrameWeightsCurr);
    
    %%add processing of shearlet coefficients here, for example:
    %%thresholding
    coeffs = coeffs.*(abs(coeffs) > 3*RMS*sigma);
    
    %%shearlet reconstruction 
    Xrec = SLshearrecSerial2D(coeffs,shearlet,Xrec);  
end

Xrec = SLfinishSerial2D(Xrec,dualFrameWeightsCurr);

elapsedTime = toc;
fprintf([num2str(elapsedTime), ' s\n']);


%%compute psnr
PSNR = SLcomputePSNR(X,Xrec);

fprintf(['PSNR: ', num2str(PSNR),' db\n']);

figure;
colormap gray;
subplot(1,3,1);
imagesc(X);
title('original image');
axis image;

subplot(1,3,2);
imagesc(Xnoisy);
title(['noisy image, sigma = ', num2str(sigma)]);
axis image;

subplot(1,3,3);
imagesc(Xrec);
title(['denoised image, PSNR = ',num2str(PSNR), ' db']);
axis image;

%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material