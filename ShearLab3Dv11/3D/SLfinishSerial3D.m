function X = SLfinishSerial3D(Xcurr,dualFrameWeights)
%SLfinishSerial3D Finish serial processing of 3D data.
%
%Usage:
%
% X = SLfinishSerial3D(Xcurr, dualFrameWeights)
%
%Input:
%
%                Xcurr: Current state of the processed data in the frequency-domain.
% dualFrameWeights: Absolute, squared sum over all shearlets in the respective
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
% [Xfreq, Xrec, preparedFilters, dualFrameWeightsCurr, shearletIdxs] = SLprepareSerial3D(useGPU,X,2,[1 1],0,modulate2(dfilters('cd','d'),'c'));
% 
% for j = 1:size(shearletIdxs,1)
%     shearletIdx = shearletIdxs(j,:);
% 
%     %shearlet decomposition
%     [coeffs,shearlet, dualFrameWeightsCurr,RMS] = SLsheardecSerial3D(Xfreq,shearletIdx,preparedFilters,dualFrameWeightsCurr);
%     
%     %put processing of shearlet coefficients here
%     
%     %shearlet reconstruction 
%     Xrec = SLshearrecSerial3D(coeffs,shearlet,Xrec);  
% end
% 
% Xrec = SLfinishSerial3D(Xrec,dualFrameWeightsCurr);
%
%See also: SLprepareSerial3D, SLsheardecSerial3D, SLshearrecSerial3D

    if nargin < 2
        error('Not enough input parameters!');
    end    
    X = fftshift(ifftn(ifftshift((1./dualFrameWeights).*Xcurr)));
end

%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material