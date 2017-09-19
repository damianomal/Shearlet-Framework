function X = SLshearrec2DC(coeffs, shearletSystem)
%SLshearrec2D 2D reconstruction from complex shearlet coefficients.
%
%Usage:
%
% X = SLshearrec2DC(coeffs, shearletSystem);
%
%Input:
%               coeffs: XxYxN array of complex shearlet coefficients.
%       shearletSystem: Structure containing a complex shearlet system. This should be
%                       the same system as the one previously used for decomposition.
%
%Output:
%
% X: Reconstructed 2D data.
%
%Example:
%
% X = double(imread('barbara.jpg'));
% useGPU = 0;
% shearletSystem = SLgetShearletSystem2DC(useGPU,size(X,1),size(X,2),4);
% coeffs = SLsheardec2DC(X,shearletSystem);
% Xrec = SLshearrec2DC(coeffs,shearletSystem);
%
%See also: SLgetShearlets2DC,SLsheardec2DC

    %% check input arguments
    if nargin < 2
        error('Not enough input parameters!');
    end
    
   
    %initialise reconstructed data
    if shearletSystem.useGPU
        if verLessThan('distcomp','6.1')
            X = parallel.gpu.GPUArray.zeros(size(coeffs,1),size(coeffs,2));
        else
            X = gpuArray.zeros(size(coeffs,1),size(coeffs,2));
        end
    else
        X = zeros(size(coeffs,1),size(coeffs,2));
    end
    
    Xreal = X;
    Ximag = X;
    coeffsReal = real(coeffs);
    coeffsImag = imag(coeffs);
    for j = 1:(shearletSystem.nShearlets)
            Xreal = Xreal+conj(fftshift(fft2(ifftshift(coeffsReal(:,:,j))))).*shearletSystem.shearlets(:,:,j);
            Ximag = Ximag+conj(fftshift(fft2(ifftshift(coeffsImag(:,:,j))))).*shearletSystem.shearlets(:,:,j);
    end
    X = fftshift(fft2(real(ifft2(ifftshift(Xreal))))) + fftshift(fft2(imag(ifft2(ifftshift(Ximag)))));
    X = fftshift(ifft2(ifftshift((1./shearletSystem.dualFrameWeights).*conj(X))));
    
end

%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material