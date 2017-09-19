function X = SLshearrec3D(coeffs, shearletSystem)
%SLshearrec3D 3D reconstruction of shearlet coefficients.
%
%Usage:
%
% X = SLshearrec3D(coeffs, shearletSystem);
%
%Input:
%               coeffs: XxYxZxN array of shearlet coefficients.
%       shearletSystem: Structure containing a shearlet system. This should be
%                       the same system as the one previously used for decomposition.
%
%Output:
%
% X: Reconstructed 3D data.
%
%Example:
%
% load missamericaseqsmall;
% X = double(X);
% useGPU = 0;
% shearletSystem = SLgetShearletSystem3D(useGPU,size(X,1),size(X,2),size(X,2),2,[0 0]);
% coeffs = SLsheardec3D(X,shearletSystem);
% Xrec = SLshearrec3D(coeffs,shearletSystem);
%
%See also: SLgetShearletSystem3D, SLsheardec3D


    %% check input arguments
    if nargin < 2
        error('Not enough input parameters!');
    end
    
    %initialise reconstructed data
    if shearletSystem.useGPU
        if verLessThan('distcomp','6.1')
            X = parallel.gpu.GPUArray.zeros(size(coeffs,1),size(coeffs,2),size(coeffs,3));
        else
            X = gpuArray.zeros(size(coeffs,1),size(coeffs,2),size(coeffs,3));
        end            
    else
        X = zeros(size(coeffs,1),size(coeffs,2),size(coeffs,3));
    end

    for j = 1:shearletSystem.nShearlets
        X = X+fftshift(fftn(ifftshift(coeffs(:,:,:,j)))).*shearletSystem.shearlets(:,:,:,j);
    end
    X = fftshift(ifftn(ifftshift((1./shearletSystem.dualFrameWeights).*X)));
    
end
%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material