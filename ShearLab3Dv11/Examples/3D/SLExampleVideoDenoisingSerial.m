tic;
fprintf('\n---SLExampleVideoDenoisingSerial---\n');
fprintf('loading video... ');

clear;

%%settings
sigma = 30;
scales = 3;
shearLevels = [0 0 1];
fullSystem = 0;
useGPU = 0;

%%load data
load 'missamericaseq';
X = double(X);

%%add noise
Xnoisy = X + sigma*randn(size(X));


elapsedTime = toc;
fprintf([num2str(elapsedTime), ' s\n']);
tic;
fprintf('preparing serial processing... ');

%%prepare serial processing
[Xfreq, Xrec, preparedFilters, dualFrameWeightsCurr, shearletIdxs] = SLprepareSerial3D(useGPU,Xnoisy,scales,shearLevels,fullSystem);


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


elapsedTime = toc;
fprintf([num2str(elapsedTime), ' s\n']);

%%compute psnr
PSNR = SLcomputePSNR(X,Xrec);

fprintf(['PSNR: ', num2str(PSNR),' db\n']);

%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material

