tic;
fprintf('\n---SLExampleImageDenoisingGPU---\n');
fprintf('loading image... ');

clear;
%%settings
sigma = 30;
scales = 4;
thresholdingFactor = 3;
device = gpuDevice;

%%load data
X = imread('barbara.jpg');
X = gpuArray(double(X));

%%add noise
Xnoisy = X + sigma*gpuArray.randn(size(X));

wait(device);
elapsedTime = toc;
fprintf([num2str(elapsedTime), ' s\n']);
tic;
fprintf('generating shearlet system... ');

%%create shearlets
shearletSystem = SLgetShearletSystem2D(1,size(X,1),size(X,2),scales);

wait(device);
elapsedTime = toc;
fprintf([num2str(elapsedTime), ' s\n']);
tic;
fprintf('decomposition, thresholding and reconstruction... ');

%%decomposition
coeffs = SLsheardec2D(Xnoisy,shearletSystem);

%%thresholding
coeffs = coeffs.*(abs(coeffs) > thresholdingFactor*reshape(repmat(shearletSystem.RMS,[size(X,1)*size(X,2) 1]),[size(X,1),size(X,2),length(shearletSystem.RMS)])*sigma);

%%reconstruction
Xrec = real(SLshearrec2D(coeffs,shearletSystem));

wait(device);
elapsedTime = toc;
fprintf([num2str(elapsedTime), ' s\n']);

%%compute psnr
PSNR = SLcomputePSNR(X,Xrec);

fprintf(['PSNR: ', num2str(PSNR) , ' db\n']);

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