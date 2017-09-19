function Xrec = SLQdecThreshRec(X,nScales,thresholdingFactors)
%SLQdecThreshRec Shearlet decomposition, thresholding and reconstruction of 2D or 3D data.
%Usage:
%
% Xrec = SLQdecThreshRec(X,nScales,thresholdingFactors)
%
%Input:
%
%                   X: 2D or 3D input data in the time domain.
%             nScales: Number of scales of the shearlet system used for
%                      decomposition.
% thresholdingFactors: 1x(nScales + 1) array. Each thresholding factor
%                      corresponds to one scale of the shearlet system
%                      used for decomposition (including the lowpass
%                      shearlet). The threshold for each coefficient will
%                      be thresholdingFactor(scale)*RMS where RMS is the
%                      root mean squared of the corresponding shearlet in
%                      the frequency domain. The thresholding is hard.
%
%Output:
%
% Xrec: 2D or 3D reconstruction of the thresholded coefficients.
%
%Example:
%
% X = imread('barbara.jpg');
% X = double(X);
% sigma = 30;
% 
% Xnoisy = X + sigma*randn(size(X));
%
% Xrec = SLQdecThreshRec(Xnoisy,4,sigma*[3 3 3 3 3]);

    
%% check input arguments
    if nargin < 3
        error('Not enough input parameters!');
    end
    
    if verLessThan('distcomp','6.1')
        useGPU = isa(X,'parallel.gpu.GPUArray');
    else
        useGPU = isa(X,'gpuArray');
    end
    
    %%2D Data
    if ismatrix(X)
        %%prepare serial processing
        try           
            [Xfreq, Xrec, preparedFilters, dualFrameWeightsCurr, shearletIdxs] = SLprepareSerial2D(useGPU,X,nScales);
        catch err
            [Xfreq, Xrec, preparedFilters, dualFrameWeightsCurr, shearletIdxs] = SLprepareSerial2D(useGPU,X,nScales,ceil((1:nScales)/2),0,modulate2(dfilters('cd','d')./sqrt(2),'c'));
        end
       
       
        for j = 1:size(shearletIdxs,1)
            shearletIdx = shearletIdxs(j,:);
            %%shearlet decomposition
            [coeffs,shearlet, dualFrameWeightsCurr,RMS] = SLsheardecSerial2D(Xfreq,shearletIdx,preparedFilters,dualFrameWeightsCurr);

            %%thresholding
            coeffs = coeffs.*(abs(coeffs) > thresholdingFactors(shearletIdx(2)+1)*RMS);

            %%shearlet reconstruction 
            Xrec = SLshearrecSerial2D(coeffs,shearlet,Xrec);  
        end
        
        Xrec = SLfinishSerial2D(Xrec,dualFrameWeightsCurr);
        
    end
    
    %%3D Data
    if ndims(X) == 3
        %%prepare serial processing
        try           
            [Xfreq, Xrec, preparedFilters, dualFrameWeightsCurr, shearletIdxs] = SLprepareSerial3D(useGPU,X,nScales);
        catch err
            [Xfreq, Xrec, preparedFilters, dualFrameWeightsCurr, shearletIdxs] = SLprepareSerial3D(useGPU,X,nScales,ceil((1:nScales)/2),0,modulate2(dfilters('cd','d')./sqrt(2),'c'));
        end
        

        for j = 1:size(shearletIdxs,1)
            shearletIdx = shearletIdxs(j,:);
            %%shearlet decomposition
            [coeffs,shearlet, dualFrameWeightsCurr,RMS] = SLsheardecSerial3D(Xfreq,shearletIdx,preparedFilters,dualFrameWeightsCurr);

            %%thresholding
            coeffs = coeffs.*(abs(coeffs) > thresholdingFactors(shearletIdx(2)+1)*RMS);

            %%shearlet reconstruction 
            Xrec = SLshearrecSerial3D(coeffs,shearlet,Xrec);  
        end
        
        Xrec = SLfinishSerial3D(Xrec,dualFrameWeightsCurr);
    end
end

%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material

