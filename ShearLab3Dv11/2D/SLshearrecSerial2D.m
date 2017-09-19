function XrecNew = SLshearrecSerial2D(coeffs,shearlet,Xrec)
%SLshearrecSerial2D 2D reconstruction of shearlet coefficients during serial processing
%
%Usage:
%
% XrecNew = SLshearrecSerial2D(coeffs,shearlet,Xrec)
%
%Input:
%
%   coeffs: Matrix of shearlet coefficients.
% shearlet: The shearlet previously used for decomposition.                       
%     Xrec: Current state of the reconstructed data.
%
%Output:
%
% XrecNew: New state of the reconstructed data.
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
%SLprepareSerial2D, SLsheardecSerial2D, SLfinishSerial2D
    
    if nargin < 3
        error('Not enough input parameters!');
    end 
    XrecNew = Xrec + fftshift(fft2(ifftshift(coeffs))).*shearlet;
end

%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material