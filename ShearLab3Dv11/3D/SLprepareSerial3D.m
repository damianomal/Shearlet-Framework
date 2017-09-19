function [Xfreq, Xrec, preparedFilters, dualFrameWeightsCurr, shearletIdxs] = SLprepareSerial3D(useGPU,X, nScales, shearLevels, full, directionalFilter, quadratureMirrorFilter)
%SLPREPARESERIAL3D Prepare seriel processing of 3D data.
%
%Usage:
%
% [Xfreq, Xrec, preparedFilters, dualFrameWeightsCurr, shearletIdxs] = SLprepareSerial3D(useGPU, X, nScales)
% [Xfreq, Xrec, preparedFilters, dualFrameWeightsCurr, shearletIdxs] = SLprepareSerial3D(useGPU, X, nScales, shearLevels)
% [Xfreq, Xrec, preparedFilters, dualFrameWeightsCurr, shearletIdxs] = SLprepareSerial3D(useGPU, X, nScales, shearLevels, full)
% [Xfreq, Xrec, preparedFilters, dualFrameWeightsCurr, shearletIdxs] = SLprepareSerial3D(useGPU, X, nScales, shearLevels, full, directionalFilter)
% [Xfreq, Xrec, preparedFilters, dualFrameWeightsCurr, shearletIdxs] = SLprepareSerial3D(useGPU, X, nScales, shearLevels, full, directionalFilter, quadratureMirrorFilter)
%
%Input:
%                 useGPU: Logical value. Determines if the shearlets arcd e constructed on the GPU.
%                      X: 3D data in time domain.
%                nScales: Number of scales of the desired shearlet system.
%                         Has to be >= 1.
%            shearLevels: A 1xnScales sized array, specifying the level of
%                         shearing occuring on each scale. Each entry of
%                         shearLevels has to be >= 0. A shear level of K
%                         means that the generating shearlet is sheared 2^K
%                         times in each direction for each cone. Forc
%                         example: If nScales = 2 and shearLevels = [1 2],
%                         the precomputed filters correspond to a
%                         shearlet system with 3*((2*2^1) + 1)^2 + 3*((2*2^2) + 1)^2 = 318
%                         shearlets (omitting the lowpass shearlet and translation). Note
%                         that it is recommended not to use the full
%                         shearlet system but to omit certain shearlets lying
%                         on the border of the second and third pyramid
%                         as they only slightly differ from shearlets on the border of
%                         the first and second pyramid. The default value is
%                         ceil((1:nScales)/2).
%                   full: Logical value that determines whether the indexes are computed
%                         for a full shearlet system or if shearlets lying on the border of
%                         the second cone are omitted. The default and recommended
%                         value is 0.
%      directionalFilter: A 2D directional filter that serves as the basis
%                         of the directional 'component' of the shearlets.
%                         The default choice is modulate2(dfilters('dmaxflat4','d'),'c').
%                         For small sized inputs or very large systems, the
%                         default directional filter might be too large. In
%                         this case, it is recommended to use
%                         modulate2(dfilters('cd','d'),'c').
% quadratureMirrorFilter: A 1D quadrature mirror filter defining the
%                         wavelet 'component' of the shearlets. The default
%                         choice is [0.0104933261758410,-0.0263483047033631,-0.0517766952966370,
%                         0.276348304703363,0.582566738241592,0.276348304703363,
%                         -0.0517766952966369,-0.0263483047033631,0.0104933261758408].
%                         Other QMF filters can be genereted with MakeONFilter.
%
%Output:
%
%                    Xfreq: X in frequency domain.
%                     Xrec: Array of the size of X that can be used to store intermeediate
%                           results during serial processing.
%          preparedFilters: Structure of 2D shearlet filters that can be used to compute 3D
%                           shearlets. These filters will be needed to
%                           construct the shearlets 'on demand' during serial
%                           processing.
% dualFrameWeightsCurr: Array of the size of X that can be used to store the normalization
%                           weights computed during serial processing.
%             shearletIdxs: Indexes of the shearlets in the shearlet system used during
%                           serial processing. One shearlet is indexed by a
%                           4-tupel with format [cone scale shearing1 shearing2].
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
%See also:
%SLsheardecSerial3D, SLshearrecSerial3D, SLfinishSerial3D

%%check input arguments
if nargin < 3
    error('Too few input arguments!');
end

if nargin < 7
    quadratureMirrorFilter = [0.0104933261758410,-0.0263483047033631,-0.0517766952966370,...
        0.276348304703363,0.582566738241592,0.276348304703363,...
        -0.0517766952966369,-0.0263483047033631,0.0104933261758408];
    
    % fancy Mallat
    quadratureMirrorFilter = [0.01, 0.105, 0.385, 0.385, 0.105, 0.01];
    
    if nargin < 6
        directionalFilter = modulate2(dfilters('dmaxflat4','d')./sqrt(2),'c');
        if nargin < 5
            full = 0;
            if nargin < 4
                shearLevels = ceil((1:nScales)/2);
            end
        end
    end
end



Xfreq = fftshift(fftn(ifftshift(X)));

if useGPU
    preparedFilters = SLfiltersToGPU3D(SLprepareFilters3D(size(X,1),size(X,2),size(X,3),nScales,shearLevels,directionalFilter,quadratureMirrorFilter));
    if verLessThan('distcomp','6.1')
        dualFrameWeightsCurr = parallel.gpu.GPUArray.zeros(size(X));
        Xrec = parallel.gpu.GPUArray.zeros(size(X));
    else
        dualFrameWeightsCurr = gpuArray.zeros(size(X));
        Xrec = gpuArray.zeros(size(X));
    end
else
    preparedFilters = SLprepareFilters3D(size(X,1),size(X,2),size(X,3),nScales,shearLevels,directionalFilter,quadratureMirrorFilter);
    dualFrameWeightsCurr = zeros(size(X));
    Xrec = zeros(size(X));
end
shearletIdxs = SLgetShearletIdxs3D(shearLevels,full);
end

%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material