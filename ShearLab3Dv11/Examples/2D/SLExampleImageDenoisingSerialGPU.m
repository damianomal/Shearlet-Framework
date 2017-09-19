tic;
fprintf('\n---SLExampleImageDenoisingSerialGPU---\n');
fprintf('loading image... ');

clear;
%%settings
sigma = 50;
scales = 6;
shearLevels = [3 3 3 3 3 3];
thresholdingFactors = [2 3 3 3 3 3 3];
fullSystem = 0;
useGPU = 1;

%%load data
X = imread('barbara.jpg');
X = gpuArray(double(X));

%%add noise
if verLessThan('distcomp','6.1')
    Xnoisy = X + sigma*parallel.gpu.GPUArray.randn(size(X));
else
    Xnoisy = X + sigma*gpuArray.randn(size(X));
end
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
    coeffs = coeffs.*(abs(coeffs) > thresholdingFactors(shearletIdx(2)+1)*RMS*sigma);
    
    %%shearlet reconstruction 
    Xrec = SLshearrecSerial2D(coeffs,shearlet,Xrec);  
end

Xrec = real(SLfinishSerial2D(Xrec,dualFrameWeightsCurr));

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