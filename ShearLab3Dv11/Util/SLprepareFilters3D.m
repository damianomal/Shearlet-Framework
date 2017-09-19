function filters = SLprepareFilters3D(ndim1,ndim2,ndim3,nscales,shearLevels,directionalFilter,quadratureMirrorFilter)
%SLprepareFilters3D Prepare 2D shearlets for the computation of 3D shearlets.
%
%Usage: 
%
% filters = SLprepareFilters3D(ndim1, ndim2, ndim3, nScales)
% filters = SLprepareFilters3D(ndim1, ndim2, ndim3, nScales, shearLevels)
% filters = SLprepareFilters3D(ndim1, ndim2, ndim3, nScales, shearLevels, directionalFilter)
% filters = SLprepareFilters3D(ndim1, ndim2, ndim3, nScales, shearLevels, directionalFilter, quadratureMirrorFilter)
%
%Input:
%
%                  ndim1: Size of first dimension.
%                  ndim2: Size of second dimension.
%                  ndim3: Size of third dimension.
%                nScales: Number of scales of the desired shearlet system.
%                         Has to be >= 1.
%            shearLevels: A 1xnScales sized array, specifying the level of
%                         shearing occuring on each scale. Each entry of
%                         shearLevels has to be >= 0. A shear level of K
%                         means that the generating shearlet is sheared 2^K
%                         times in each direction for both types of shearing for all three pyramids.
%                         For example: If nScales = 2 and shearLevels = [1 2], 
%                         the precomputed filters correspond to a shearlet system 
%                         with a maximum number of 3*((2*2^1) + 1)^2 + 3*((2*2^2) + 1)^2 = 318
%                         shearlets (omitting the lowpass shearlet and translation). Note
%                         that it is recommended not to use the full
%                         shearlet system but to omit certain shearlets lying on
%                         the border of the second and third pyramid as they are only
%                         slightly different from shearlets on the border of
%                         the first and second pyramid.
%      directionalFilter: A 2D directional filter that serves as the basis
%                         of the directional 'component' of the shearlets.
%                         The default choice is modulate2(dfilters('dmaxflat4','d'),'c').
%                         For small sized inputs, or very large systems the
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
% filters: A structure containing 2D shearlets that can be used to 
%          compute 3D shearlets.
%                  
%
%Example 1:
%
% %Prepare filters for a input of size 128x128x128 and a 1-scale shearlet system
% preparedFilters = SLprepareFilters3D(128,128,128,1);
% shearlets = SLgetShearlets3D(preparedFilters);
%
%Example 2:
%
% %Prepare filters for a input of size 128x128x128 and a 2-scale shearlet system
% %with shear levels [0 0].
% preparedFilters = SLprepareFilters3D(128,128,128,2,[0 0]);
% shearlets = SLgetShearlets3D(preparedFilters);
%
%Example 3:
%
% %Prepare filters for a input of size 128x128x128 and a 1-scale shearlet system
% %with shear level [2] and a small directional filter.
% preparedFilters = SLprepareFilters3D(128,128,128,1,[2],modulate2(dfilters('cd','d'),'c'));
%
%See also: SLgetShearletIdxs3D,SLgetShearlets3D,dfilters,MakeONFilter

    %%check input arguments
    if nargin < 4
        error('Too few input arguments!');
    end
    if nargin < 7
        if nargin < 6
            if nargin < 5
                shearLevels = ceil((1:nscales)/2);
            end
            %directionalFilter = modulate2(dfilters('cd','d')./sqrt(2),'c');
            directionalFilter = modulate2(dfilters('dmaxflat4','d')./sqrt(2),'c');
        end
        quadratureMirrorFilter = [0.0104933261758410,-0.0263483047033631,-0.0517766952966370,...
                                  0.276348304703363,0.582566738241592,0.276348304703363,...
                                  -0.0517766952966369,-0.0263483047033631,0.0104933261758408]; 
 
    end
    
    global filtersa
    
    filters = struct('size',[ndim1 ndim2 ndim3],'shearLevels',shearLevels,'d1d2',[],'d1d3',[],'d3d2',[]);
    preparedFilters2D = SLprepareFilters2D(ndim1,ndim2,nscales,shearLevels,directionalFilter,quadratureMirrorFilter);
    filters.d1d2 = SLgetShearlets2D(preparedFilters2D,SLgetShearletIdxs2D(preparedFilters2D.shearLevels,1));
    if ndim3 == ndim2
        filters.d1d3 = filters.d1d2;
    else
        preparedFilters2D = SLprepareFilters2D(ndim1,ndim3,nscales,shearLevels,directionalFilter,quadratureMirrorFilter);
        filters.d1d3 = SLgetShearlets2D(preparedFilters2D,SLgetShearletIdxs2D(preparedFilters2D.shearLevels,1));
    end
    
    if ndim3 == ndim1
        filters.d3d2 = filters.d1d2;
    else
        preparedFilters2D = SLprepareFilters2D(ndim3,ndim2,nscales,shearLevels,directionalFilter,quadratureMirrorFilter);
        filters.d3d2 = SLgetShearlets2D(preparedFilters2D,SLgetShearletIdxs2D(preparedFilters2D.shearLevels,1));
    end
    filters.useGPU = 0;
    
    filtersa = filters;
end

%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material
