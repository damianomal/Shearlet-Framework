function [coeffs, shearlet, dualFrameWeightsNew, RMS]  = SLsheardecSerial2D(Xfreq,shearletIdx,preparedFilters,dualFrameWeightsCurr)
%SLsheardecSerial2D Shearlet decomposition of 2D data during serial processing.
%
%Usage:
%
% [coeffs, shearlet, dualFrameWeightsNew, RMS]  = SLsheardecSerial2D(Xfreq,shearletIdx,preparedFilters,dualFrameWeightsCurr)
%
%Input:
%
%                    Xfreq: 2D data in frequency domain.
%              shearletIdx: Index of the shearlet for which the decomposition is to be
%                           computed. Format: [cone scale shearing].
%          preparedFilters: Structure of filters that can be used to compute 2D
%                           shearlets. These filters are constructed when
%                           calling SLprepareSerial2D.
%     dualFrameWeightsCurr: Current state of the dual frame weights.
%
%Output:
%
%                  coeffs: A matrix containing all coefficients, that is all inner  
%                          products with X in the time domain, of all translates of the
%                          shearlet specified by shearletIdxs. When constructing
%                          shearlets with SLgetShearlets2D, each shearlet is centered in the 
%                          time domain at floor(size(X)/2) + 1. Hence, the inner
%                          product of X and the shearlet specified by shearletIdx can be found at
%                          coeffs(floor(size(X,1)/2) + 1,floor(size(X,2)/2) + 1).
%                shearlet: The 2D shearlet specified by shearletIdx in the
%                          frequency domain.
%     dualFrameWeightsNew: Updated dual frame weights.
%                     RMS: The root mean square of the shearlet specified
%                          shearletIdx in the frequency domain.
%
%Example:
%
% useGPU = 0;
% [Xfreq, Xrec, preparedFilters, dualFrameWeightsCurr, shearletIdxs] = SLprepareSerial2D(useGPU,X,4);
% 
% for j = 1:size(shearletIdxs,1)
%     shearletIdx = shearletIdxs(j,:);
% 
%     %shearlet decomposition
%     [coeffs,shearlet, dualFrameWeightsCurr,RMS] = SLsheardecSerial2D(Xfreq,shearletIdx,preparedFilters,dualFrameWeightsCurr);
%     
%     %put processing of shearlet coefficients here
%     
%     %shearlet reconstruction 
%     Xrec = SLshearrecSerial2D(coeffs,shearlet,Xrec);  
% end
% 
% Xrec = SLfinishSerial2D(Xrec,dualFrameWeightsCurr);
%
%See also:
%SLprepareSerial2D, SLshearrecSerial2D, SLfinishSerial2D

    if nargin < 4
        error('Not enough input parameters!');
    end
    [shearlet, RMS, dualFrameWeights] = SLgetShearlets2D(preparedFilters,shearletIdx);
    dualFrameWeightsNew = dualFrameWeightsCurr + dualFrameWeights; 
    coeffs = fftshift(ifft2(ifftshift(conj(shearlet).*Xfreq)));
end

%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material