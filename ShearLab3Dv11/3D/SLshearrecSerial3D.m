function XrecNew = SLshearrecSerial3D(coeffs,shearlet,Xrec)
%SLshearrecSerial3D 3D reconstruction of shearlet coefficients during serial processing.
%
%Usage:
%
% XrecNew = SLshearrecSerial3D(coeffs,shearlet,Xrec)
%
%Input:
%
%   coeffs: XxYxZ array of shearlet coefficients.
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
%See also: SLprepareSerial3D, SLsheardecSerial3D, SLfinishSerial3D

    if nargin < 3
        error('Not enough input parameters!');
    end 
    XrecNew = Xrec + fftshift(fftn(ifftshift(coeffs))).*shearlet;
end

%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material