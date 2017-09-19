tic;
fprintf('\n---SLExampleVideoDenoisingGPU---\n');
fprintf('loading video... ');

clear;

%%settings
sigma = 30;
scales = 2;
shearLevels = [1 1];
thresholdingFactor = 3;
directionalFilter = modulate2(dfilters('cd','d')./sqrt(2),'c');
device = gpuDevice;

%%load data
load missamericaseqsmall;
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
fprintf('generating shearlet system... ');

%%create shearlets
shearletSystem = SLgetShearletSystem3D(1,size(X,1),size(X,2),size(X,3),scales,shearLevels,0,directionalFilter);

wait(device);
elapsedTime = toc;
fprintf([num2str(elapsedTime), ' s\n']);
tic;
fprintf('decomposition, thresholding and reconstruction... ');

%%decomposition
coeffs = SLsheardec3D(Xnoisy,shearletSystem);

%%thresholding
coeffs = coeffs.*(abs(coeffs) > thresholdingFactor*reshape(repmat(shearletSystem.RMS,[size(X,1)*size(X,2)*size(X,3) 1]),[size(X,1),size(X,2),size(X,3),length(shearletSystem.RMS)])*sigma);

%%reconstruction
Xrec = SLshearrec3D(coeffs,shearletSystem);

wait(device);
elapsedTime = toc;
fprintf([num2str(elapsedTime), ' s\n']);

%%compute psnr
PSNR = SLcomputePSNR(X,Xrec);

fprintf(['PSNR: ', num2str(PSNR) , ' db\n']);

%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material