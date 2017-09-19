tic;
fprintf('\n---SLQExampleImageDenoisingGPU---\n');
fprintf('loading image... ');

clear;
%%settings
sigma = 20;
scales = 4;
thresholdingFactor = 3;
device = gpuDevice;

%%load data
X = imread('barbara.jpg');
X = gpuArray(double(X));

%%add noise
if verLessThan('distcomp','6.1')
    Xnoisy = X + sigma*parallel.gpu.GPUArray.randn(size(X));
else
    Xnoisy = X + sigma*gpuArray.randn(size(X));
end

wait(device);
elapsedTime = toc;
fprintf([num2str(elapsedTime), ' s\n']);
tic;
fprintf('decomposition, thresholding and reconstruction... ');

%%decomposition, thresholding and reconstruction
Xrec = SLQdecThreshRec(Xnoisy,4,sigma*[3 3 3 3 3]);

wait(device);
elapsedTime = toc;
fprintf([num2str(elapsedTime), ' s\n']);

PSNR = SLcomputePSNR(X,Xrec);

fprintf(['PSNR: ' num2str(PSNR) '\n']);
%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material
