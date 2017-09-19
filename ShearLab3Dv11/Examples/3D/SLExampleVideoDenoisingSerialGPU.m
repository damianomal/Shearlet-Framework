tic;
fprintf('\n---SLExampleVideoDenoisingSerialGPU---\n');
fprintf('loading video... ');

clear;

%%settings
sigma = 30;
scales = 3;
shearLevels = [1 1 2];
fullSystem = 0;
device = gpuDevice;
useGPU = 1;

%%load data
load 'mobile2_sequence';
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
fprintf('preparing serial processing... ');

%%prepare serial processing
[Xfreq, Xrec, preparedFilters, dualFrameWeightsCurr, shearletIdxs] = SLprepareSerial3D(useGPU,Xnoisy,scales,shearLevels,fullSystem);


wait(device);
elapsedTime = toc;
fprintf([num2str(elapsedTime), ' s\n']);
tic;
fprintf('decomposition, thresholding and reconstruction... ');

for j = 1:size(shearletIdxs,1)
    shearletIdx = shearletIdxs(j,:);
    
    %%shearlet decomposition
    [coeffs,shearlet, dualFrameWeightsCurr,RMS] = SLsheardecSerial3D(Xfreq,shearletIdx,preparedFilters,dualFrameWeightsCurr);
    
    %%put processing of shearlet coefficients here, for example:
    %%thresholding
    coeffs = coeffs.*(abs(coeffs) > 3*RMS*sigma);
    
    %%shearlet reconstruction 
    Xrec = SLshearrecSerial3D(coeffs,shearlet,Xrec);      
end

Xrec = SLfinishSerial3D(Xrec,dualFrameWeightsCurr);


wait(device);
elapsedTime = toc;
fprintf([num2str(elapsedTime), ' s\n']);

%%compute psnr
PSNR = SLcomputePSNR(X,Xrec);

fprintf(['PSNR: ', num2str(PSNR),' db\n']);


%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Thu, 10/11/2014
%  This is Copyrighted Material

