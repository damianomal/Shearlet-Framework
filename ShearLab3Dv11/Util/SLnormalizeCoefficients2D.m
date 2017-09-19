function coeffsNormalized = SLnormalizeCoefficients2D(coeffs,shearletSystem)
%SLNORMALIZECOEFFICIENTS Summary of this function goes here
%   Detailed explanation goes here

    useGPU = isa(coeffs,'gpuArray');

    if useGPU
        if verLessThan('distcomp','6.1')
            coeffsNormalized = parallel.gpu.GPUArray.zeros(size(coeffs));
        else
            coeffsNormalized = gpuArray.zeros(size(coeffs));
        end
    else
        coeffsNormalized = zeros(size(coeffs));
    end

    for i = 1:shearletSystem.nShearlets
        coeffsNormalized(:,:,i) = coeffs(:,:,i)./shearletSystem.RMS(i);
    end
end

%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material
