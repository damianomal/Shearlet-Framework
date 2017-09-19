function [coeffs] = SLsheardec2DC(X,shearletSystem,scales)
%SLsheardec2DC Complex shearlet decomposition of 2D data.
%
%Usage:
%
% coeffs = SLsheardec2DC(X,shearletSystem,scales);
%
%Input:
%
%              X: 2D data in time domain.
% shearletSystem: Structure containg a complex shearlet system. Such a system can
%                 be computed with SLgetShearletSystem2DC.
%         scales: An array containing the scales for which the coefficients
%                 are to be computed. If not specified, all scales are
%                 considered.
%Output:
%
% coeffs: XxYxN array of the same size as the shearletSystem.shearlets array (assuming coefficients
%         were to be computed for all scales). coeffs contains all
%         shearlet coefficients, that is all inner products with the given data,
%         of all translates of the shearlets in the specified system. When constructing
%         shearlets with SLgetShearletSystem2DC, each shearlet is centered in the 
%         time domain at floor(size(X)/2) + 1. Hence, the inner
%         product of X and the i-th shearlet in the time domain can be found at
%         coeffs(floor(size(X,1)/2) + 1,floor(size(X,2)/2) + 1,i). 
%
%Example:
%
% X = double(imread('barbara.jpg'));
% useGPU = 0;
% shearletSystem = SLgetShearletSystem2DC(useGPU,size(X,1),size(X,2),4);
% coeffs = SLsheardec2DC(X,shearletSystem);
%
%See also: SLgetShearletSystem2DC, SLshearrec2DC

    %% check input arguments
    if nargin < 2
        error('Not enough input parameters!');
    end
    
    if shearletSystem.useGPU
        if verLessThan('distcomp','6.1')
            coeffs = parallel.gpu.GPUArray.zeros(size(shearletSystem.shearlets));
        else
            coeffs = gpuArray.zeros(size(shearletSystem.shearlets));
        end            
    else
        coeffs = zeros(size(shearletSystem.shearlets));
    end
 
    %get data in frequency domain
    Xfreq = fftshift(fft2(ifftshift(X)));

    %compute shearlet coefficients at each scale
    %not that pointwise multiplication in the fourier domain equals convolution
    %in the time-domain
    if nargin > 2
        for j = 1:shearletSystem.nShearlets
            if ismember(shearletSystem.shearletIdxs(j,2),scales)
                coeffs(:,:,j) = fftshift(ifft2(ifftshift((Xfreq).*(shearletSystem.shearlets(:,:,j)))));                
            end
         end
    else
        for j = 1:shearletSystem.nShearlets
            coeffs(:,:,j) = fftshift(ifft2(ifftshift((Xfreq).*(shearletSystem.shearlets(:,:,j)))));        
        end
    end
    
end

%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material