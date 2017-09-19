function X = SLfinishSerial2D(Xcurr,dualFrameWeights)
%SLfinishSerial2D Finish serial processing of 2D data.
%
%Usage:
%
% X = SLfinishSerial2D(Xcurr, dualFrameWeights)
%
%Input:
%
%                Xcurr: Current state of the processed data in the frequency-domain.
%     dualFrameWeights: Absolute, squared sum over all shearlets in the respective
%                       shearlet system. Has to be computed during  serial processing.
%
%Output:
%
% X: Normalized version of Xcurr in the time domain.
%
%Description:
%
% Normalizes the current state of the processed data (Xcurr) and
% transforms it back to the time-domain.
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
%SLprepareSerial2D, SLsheardecSerial2D, SLshearrecSerial2D

    % check input
    if nargin < 2
        error('Not enough input parameters!');
    end    
    
    X = fftshift(ifft2(ifftshift((1./dualFrameWeights).*Xcurr)));
end

%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material