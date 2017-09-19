function shearletSystem = SLgetShearletSystem3D(useGPU, ndim1, ndim2, ndim3, nScales, shearLevels, full, directionalFilter, quadratureMirrorFilter)
%SLgetShearletSystem3D Compute a 3D shearlet system.
%
%Usage:
%
% shearletSystem = SLgetShearletSystem3D(useGPU, ndim1, ndim2, ndim3, nScales)
% shearletSystem = SLgetShearletSystem3D(useGPU, ndim1, ndim2, ndim3, nScales, shearLevels)
% shearletSystem = SLgetShearletSystem3D(useGPU, ndim1, ndim2, ndim3, nScales, shearLevels, full)
% shearletSystem = SLgetShearletSystem3D(useGPU, ndim1, ndim2, ndim3, nScales, shearLevels, full, directionalFilter)
% shearletSystem = SLgetShearletSystem3D(useGPU, ndim1, ndim2, ndim3, nScales, shearLevels, full, directionalFilter, quadratureMirrorFilter)
%
%Input:
%
%                 useGPU: Logical value, determines if the
%                         shearlet system is constructed on the GPU.
%                  ndim1: Size of the first dimension.
%                  ndim2: Size of the second dimension.
%                  ndim3: Size of the third dimension.
%                nScales: Number of scales of the desired shearlet system.
%                         Has to be >= 1.
%            shearLevels: A 1D array, specifying the level of
%                         shearing on each scale. Each entry of
%                         shearLevels has to be >= 0. A shear level of K
%                         means that the generating shearlet is sheared 2^K
%                         times in each direction for both types of shearing for all three pyramids.
%                         For example: If nScales = 2 and shearLevels = [1 2], the shearlet system will
%                         contain 3*((2*2^1) + 1)^2 + 3*((2*2^2) + 1)^2 = 318
%                         shearlets (omitting the lowpass shearlet and translation). Note
%                         that it is recommended not to use the full shearlet system but to 
%                         omit certain shearlets lying on the border of the second and third pyramid 
%                         as they only slightly differ from shearlets on the border of
%                         the first and second pyramid. The default value is
%                         ceil((1:nScales)/2).
%                   full: Logical value that determines whether a full shearlet system
%                         is computed or if certain shearlets lying on the border of
%                         the second and third pyramid are omitted. The default and recommended
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
%        shearletSystem: A structure containing the specified shearlet system.   
%            .shearlets: A XxYxZxN array of N 3D shearlets in the frequency domain where X, Y and Z   
%                        denote the size of each shearlet. To get the i-th shearlet in the 
%                        time domain, use fftshift(ifftn(ifftshift(shearletSystem.shearlets(:,:,:,i)))). 
%                        Each Shearlet is centered at floor([X Y Z]/2) + 1.
%                 .size: The size of each shearlet in the system.
%          .shearLevels: The respective input argument is stored here.
%                 .full: The respective input argument is stored here.
%           .nShearlets: Number of shearlets in the
%                        shearletSystem.shearlets array. This number
%                        also describes the redundancy of the system.
%        .shearletdIdxs: A Nx4 array, specifying each shearlet in the system
%                        in the format [cone scale shearing1 shearing2] where N
%                        denotes the number of shearlets. Note that the values for scale and shearing are limited by 
%                        specified number of scales and shaer levels. The lowpass shearlet is 
%                        indexed by [0 0 0 0].
%     .dualFrameWeights: A XxYxZ matrix containing the absolute and squared sum over all shearlets
%                        stored in shearletSystem.shearlets. These weights
%                        are needed to compute the dual shearlets during reconstruction.
%                  .RMS: A 1xnShearlets array containing the root mean
%                        squares (L2-norm divided by sqrt(X*Y*Z)) of all shearlets stored in
%                        shearletSystem.shearlets. These values can be used to normalize 
%                        shearlet coefficients to make them comparable.
%               .useGPU: Logical value. Tells if the shearlet system is stored on the GPU.
%
%Example 1:
%
% %compute a standard shearlet system of one scale
% shearletSystem = SLgetShearletSystem3D(0,96,96,96,1);
%
%Example 2:
%
% %compute a full shearlet system of one scale
% shearletSystem = SLgetShearletSystem3D(0,96,96,96,1,[1],1);
%
%Example 3:
%
% %compute a shearlet system with 2 scales for small size data
% %using a non-default directional filter.
% directionalFilter = modulate2(dfilters('cd','d'),'c');
% shearletSystem = SLgetShearletSystem3D(0,64,64,64,2,[1 1],0,directionalFilter);
%
%
%
%See also: SLgetShearletIdxs3D,SLsheardec3D,SLshearrec3D,SLgetSubsystem3D

    
    %%check input arguments
    if nargin < 5
        error('Too few input arguments!');
    end
    
    if nargin < 9
        quadratureMirrorFilter = [0.0104933261758410,-0.0263483047033631,-0.0517766952966370,...
                                  0.276348304703363,0.582566738241592,0.276348304703363,...
                                  -0.0517766952966369,-0.0263483047033631,0.0104933261758408]; 
        if nargin < 8     
            directionalFilter = modulate2(dfilters('dmaxflat4','d')./sqrt(2),'c');
            if nargin < 7
                full = 0;
                if nargin < 6                    
                    shearLevels = ceil((1:nScales)/2);
                end
            end            
        end   
    end
    
    if useGPU
        preparedFilters = SLfiltersToGPU3D(SLprepareFilters3D(ndim1, ndim2, ndim3,nScales,shearLevels,directionalFilter,quadratureMirrorFilter));
    else
        preparedFilters = SLprepareFilters3D(ndim1, ndim2, ndim3,nScales,shearLevels,directionalFilter,quadratureMirrorFilter);
    end
    shearletIdxs = SLgetShearletIdxs3D(shearLevels,full);
    [shearlets, RMS, dualFrameWeights] = SLgetShearlets3D(preparedFilters,shearletIdxs);
    
    %% create description
    shearletSystem = struct('shearlets',shearlets,'size',preparedFilters.size,'shearLevels',preparedFilters.shearLevels,'full',full,'nShearlets',size(shearletIdxs,1),'shearletIdxs',shearletIdxs,'dualFrameWeights',dualFrameWeights,'RMS',RMS,'useGPU',useGPU);

end

%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material
