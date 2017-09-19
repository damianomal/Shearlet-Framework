function shearletSystem = SLgetShearletSystem2DC(useGPU, rows, cols, nScales, shearLevels, full, directionalFilter, scalingFilter, waveletFilter, scalingFilter2)
%SLgetShearletSystem2D Compute a 2D complex shearlet system. Complex
%shearlets are constructed as Hilbert transform pairs. The real part of the Hilbert
%transform pairs is equal to the shearlet system specified by the same parameters.
%
%Usage:
%
% shearletSystem = SLgetShearletSystem2DC(useGPU, rows, cols, nScales)
% shearletSystem = SLgetShearletSystem2DC(useGPU, rows, cols, nScales, shearLevels)
% shearletSystem = SLgetShearletSystem2DC(useGPU, rows, cols, nScales, shearLevels, full)
% shearletSystem = SLgetShearletSystem2DC(useGPU, rows, cols, nScales, shearLevels, full, directionalFilter)
% shearletSystem = SLgetShearletSystem2DC(useGPU, rows, cols, nScales, shearLevels, full, directionalFilter, scalingFilter)
% shearletSystem = SLgetShearletSystem2DC(useGPU, rows, cols, nScales, shearLevels, full, directionalFilter, scalingFilter, waveletFilter, scalingFilter2)
%
%Input:
%
%                 useGPU: Logical value, determines if the
%                         shearlet system is constructed on the GPU.
%                   rows: Number of rows.
%                   cols: Number of columns.
%                nScales: Number of scales of the desired shearlet system.
%                         Has to be >= 1.
%            shearLevels: A 1xnScales sized array, specifying the level of
%                         shearing occuring on each scale. Each entry of
%                         shearLevels has to be >= 0. A shear level of K
%                         means that the generating shearlet is sheared 2^K
%                         times in each direction for each cone. For
%                         example: If nScales = 3 and shearLevels = [1 1
%                         2], the shearlet system will contain (2*(2*2^1
%                         + 1)) + (2*(2*2^1 + 1)) + (2*(2*2^2 + 1)) = 38
%                         shearlets (omitting the lowpass shearlet and translation). Note
%                         that it is recommended not to use the full
%                         shearlet system but to omit shearlets lying on
%                         the border of the second cone as they are only
%                         slightly different from those on the border of
%                         the first cone. The default value is
%                         ceil((1:nScales)/2).
%                   full: Logical value that determines whether a full shearlet system 
%                         is computed or if shearlets lying on the border of
%                         the second cone are omitted. The default and recommended
%                         value is 0.
%      directionalFilter: A 2D directional filter that serves as the basis
%                         of the directional 'component' of the shearlets.
%                         The default choice is modulate2(dfilters('dmaxflat4','d'),'c').
%                         For small sized inputs or very large systems, the
%                         default directional filter might be too large. In
%                         this case, it is recommended to use
%                         modulate2(dfilters('cd','d'),'c').
%          scalingFilter: A 1D lowpass scaling filter. Typically, scalingFilter is
%                         chosen to form a Quadrature Mirror Filter pair with waveletFilter. The default
%                         choice is [0.0104933261758410,-0.0263483047033631,-0.0517766952966370,
%                         0.276348304703363,0.582566738241592,0.276348304703363,
%                         -0.0517766952966369,-0.0263483047033631,0.0104933261758408].
%                         Other QMF filters can be genereted with MakeONFilter.
%          waveletFilter: A 1D highpass wavelet filter. Typically, waveletFilter is
%                         chosen to form a Quadrature Mirror Filter pair with scalingFilter. The default
%                         choice is waveletFilter = MirrorFilt(scalingFilter).
%                         Other QMF filters can be genereted with MakeONFilter.
%         scalingFilter2: A 1D lowpass scaling filter. scalingFilter2 specifies one part of the tensor product which 
%                         defines the 2D wavelet the shearlet generator is based on. 
%                         Typically, scalingFilter2 is chosen to be equal to scalingFilter.
%                         Other QMF filters can be genereted with MakeONFilter.
%
%Output:
%
%        shearletSystem: A structure containing the specified shearlet system.   
%            .shearlets: A XxYxN array of N 2D shearlets in the frequency domain where X and Y   
%                        denote the size of each shearlet. To get the i-th shearlet in the 
%                        time domain, use fftshift(ifft2(ifftshift(shearletSystem.shearlets(:,:,i)))). 
%                        Each Shearlet is centered at floor([X Y]/2) + 1.
%                 .size: The size of each shearlet in the system.
%          .shearLevels: The respective input argument is stored here.
%                 .full: The respective input argument is stored here.
%           .nShearlets: Number of shearlets in the
%                        shearletSystem.shearlets array. This number
%                        also describes the redundancy of the system.
%        .shearletdIdxs: A Nx3 array, specifying each shearlet in the system
%                        in the format [cone scale shearing] where N
%                        denotes the number of shearlets. The vertical cone in the time 
%                        domain is indexed by 1 while the horizontal cone is indexed by 2.
%                        Note that the values for scale and shearing are limited by 
%                        specified number of scales and shaer levels. The lowpass shearlet is 
%                        indexed by [0 0 0].
%     .dualFrameWeights: A XxY matrix containing the absolute and squared sum over all shearlets
%                        stored in shearletSystem.shearlets. These weights
%                        are needed to compute the dual frame during
%                        reconstruction.
%                  .RMS: A 1xnShearlets array containing the root mean
%                        squares (L2-norm divided by sqrt(X*Y)) of all shearlets stored in
%                        shearletSystem.shearlets. These values can be used to normalize 
%                        shearlet coefficients to make them comparable.
%               .useGPU: Logical value. Tells if the shearlet system
%                        is stored on the GPU.
%            .isComplex: Logical value. Tells if the shearlet system
%                        is complex.
%
%Example 1:
%
% %compute a standard complex shearlet system of four scales
% shearletSystem = SLgetShearletSystem2DC(0,512,512,4);
%
%See also: SLgetShearletIdxs2D,SLsheardec2DC,SLshearrec2DC
    if nargin < 4
        error('Too few input arguments!');
    end
    if nargin < 10
        if nargin < 9
            if nargin < 8
                if nargin < 7     
                    if nargin < 6
                        if nargin < 5                    
                            shearLevels = ceil((1:nScales)/2);
                        end
                        full = 0;
                    end     
                    directionalFilter = modulate2(dfilters('dmaxflat4','d')./sqrt(2),'c');
                end
                scalingFilter = [0.0104933261758410,-0.0263483047033631,-0.0517766952966370,...
                                  0.276348304703363,0.582566738241592,0.276348304703363,...
                                  -0.0517766952966369,-0.0263483047033631,0.0104933261758408];                       
            end
            waveletFilter = MirrorFilt(scalingFilter);
        end
        scalingFilter2 = scalingFilter;
    end
    if useGPU
        preparedFilters = SLfiltersToGPU2D(SLprepareFilters2D(rows,cols,nScales,shearLevels,directionalFilter,scalingFilter,waveletFilter,scalingFilter2));
    else
        preparedFilters = SLprepareFilters2D(rows,cols,nScales,shearLevels,directionalFilter,scalingFilter,waveletFilter,scalingFilter2);
    end
    shearletIdxs = SLgetShearletIdxs2D(shearLevels,full);
    [shearlets, RMS, dualFrameWeights] = SLgetShearlets2D(preparedFilters,shearletIdxs);
    
    dualFrameWeights = zeros(rows,cols);


    for j = 1:(size(shearlets,3)-1)
        idx = shearletIdxs(j,:);
        if idx(1) == 1
            complexShearlet = hilbert(real((ifft2(ifftshift(shearlets(:,:,j)))))')';
        end
        if idx(1) == 2
            complexShearlet = hilbert(real((ifft2(ifftshift(shearlets(:,:,j))))));
        end
        shearlets(:,:,j) = fftshift(fft2(complexShearlet));
        dualFrameWeights = dualFrameWeights + abs(fftshift(fft2(real(complexShearlet)))).^2 + abs(fftshift(fft2(imag(complexShearlet)))).^2;
    end
    dualFrameWeights = dualFrameWeights + abs(shearlets(:,:,end)).^2;
    RMS = squeeze(sqrt(sum(sum(abs(shearlets).^2)))/sqrt(rows*cols))';

    shearletSystem = struct('shearlets',shearlets,'size',preparedFilters.size,'shearLevels',preparedFilters.shearLevels,'full',full,'nShearlets',size(shearletIdxs,1),'shearletIdxs',shearletIdxs,'dualFrameWeights',dualFrameWeights,'RMS',RMS,'useGPU',useGPU,'isComplex',1);


end

%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material