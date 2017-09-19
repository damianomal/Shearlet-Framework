tic;
fprintf('\n---SLQExampleVideoDenoising---\n');
fprintf('loading image... ');

clear;
%%settings
sigma = 30;
scales = 4;
thresholdingFactor = 3;

%%load data
load missamericaseqsmall;
X = double(X);

%%add noise
Xnoisy = X + sigma*randn(size(X));

elapsedTime = toc;
fprintf([num2str(elapsedTime), ' s\n']);
tic;
fprintf('decomposition, thresholding and reconstruction... ');

%%decomposition, thresholding and reconstruction
Xrec = SLQdecThreshRec(Xnoisy,2,sigma*[3 3 3]);

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
