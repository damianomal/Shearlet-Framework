function preparedFiltersGPU = SLfiltersToGPU3D(preparedFilters)
%SLfiltersToGPU3D Transfer precomputed filters for the construction of 2D shearlets to the graphics card.
%
%Usage:
%
% preparedFiltersGPU = SLfiltersToGPU3D(preparedFilters)
%
%Input:
%
% preparedFilters: A structure containing filters that can be used to construct 3D shearlets.
%                  Such filters can be generated with SLprepareFilters3D.
%
%Output:
%
% preparedFiltersGPU: A copy of preparedFilters with all filters stored on
%                     the memory of the graphics card.
%
%Example:
%
% preparedFilters = SLprepareFilters3D(128,128,128,2);
% preparedFiltersGPU = SLfiltersToGPU3D(preparedFilters);
%
%See also: SLprepareFilters3D
    if nargin < 1
        error('Too few input arguments!');
    end;
    preparedFiltersGPU = struct('size',preparedFilters.size,'shearLevels',preparedFilters.shearLevels,'d1d2',gpuArray(preparedFilters.d1d2),'d1d3',gpuArray(preparedFilters.d1d3),'d3d2',gpuArray(preparedFilters.d3d2),'useGPU',1);
end

%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material
