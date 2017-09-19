function coeffs = SLsheardec3D(X,shearletSystem)
%SLsheardec3D Shearlet decomposition of 3D data.
%
%Usage:
%
% coeffs = SLsheardec3D(X,shearletSytem);
%
%Input:
%
%              X: 3D data in time domain.
% shearletSystem: Structure containing a shearlet system. Such a system can
%                 be computed with SLgetShearletSystem3D or
%                 SLgetSubsystem3D.
%Output:
%
% coeffs: XxYxZxN array of the same size as the shearletSystem.shearlets array. coeffs contains all
%         shearlet coefficients, that is all inner products with the given data,
%         of all translates of the specified shearlets. When constructing
%         shearlets with SLgetShearletSystem3D, each shearlet is centered in the 
%         time domain at floor(size(X)/2) + 1. Hence, the inner
%         product of X and the i-th shearlet in the time domain can be found at
%         coeffs(floor(size(X,1)/2) + 1, floor(size(X,2)/2) + 1, floor(size(X,3)/2) + 1, i). 
%
%Example:
%
% load missamericaseqsmall;
% X = double(X);
% useGPU = 0;
% shearletSystem = SLgetShearletSystem3D(useGPU,size(X,1),size(X,2),size(X,2),2,[0 0]);
% coeffs = SLsheardec3D(X,shearletSystem);
%
%See also: SLgetShearletSystem3D, SLgetSubsystem3D, SLshearrec3D

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
    XFreq = fftshift(fftn(ifftshift(X)));

    %compute shearlet coefficients at each scale
    %note that pointwise multiplication in the fourier domain equals convolution
    %in the time-domain
    for j = 1:shearletSystem.nShearlets
        coeffs(:,:,:,j) = fftshift(ifftn(ifftshift(XFreq.*conj(shearletSystem.shearlets(:,:,:,j)))));        
    end
    
end

%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material
