function shearletIdxs = SLgetShearletIdxs3D(shearLevels,full,varargin)
%SLgetShearletIdxs3D Compute a index set describing a 3D shearlet system.
%
% Usage:    
%  
%   shearletIdxs = SLgetShearletIdxs3D(shearLevels)
%   shearletIdxs = SLgetShearletIdxs3D(shearLevels, full)
%   shearletIdxs = SLgetShearletIdxs3D(shearLevels, full, 'NameRestriction1', ValueRestriction1,...)
%
%Input:
%   
%        shearLevels: A 1D array, specifying the level of
%                     shearing on each scale. Each entry of
%                     shearLevels has to be >= 0. A shear level of K
%                     means that the generating shearlet is sheared 2^K
%                     times in each direction for both types of shearing for all three pyramids.
%                     For example: If shearLevels = [1 2], the computed indexes correspond 
%                     to a shearlet system with a maximum number of 3*((2*2^1) + 1)^2 + 3*((2*2^2) + 1)^2 = 318
%                     shearlets (omitting the lowpass shearlet and translation). Note
%                     that it is recommended not to use the full shearlet system but to 
%                     omit certain shearlets lying on the border of the second and third pyramid 
%                     as they only slightly differ from shearlets on the border of
%                     the first and second pyramid.
%               full: Logical value that determines whether the indexes are computed
%                     for full shearlet system, or if certain shearlets lying on the border of
%                     the second and third pyramid are omitted. The default and recommended
%                     value is 0.
% 'TypeRestriction1': Possible restrictions: 'cones', 'scales', 'shearings1',
%                     'shearings2'.
%  ValueRestriction1: Numerical value or Array specifying a
%                     restriction. If the type of the restriction is
%                     'scales' the value 1:2 ensures that only indexes
%                     corresponding the shearlets on the first two
%                     scales are computed. Note that the index of the
%                     lowpass shearlet [0 0 0 0] will always be included.
%
%Output:
%
% shearletIdxs: Nx4 matriss, where each row describes one shearlet in the
%               format [cone scale shearing1 shearing2].
%
%Example 1:
%
% %Compute the indexes, describing a 3D shearlet system with 3 scales
% shearletIdxs = SLgetShearletIdxs3D([1 1 2]);
%
%Example 2:
%
% %Compute the indexes of all shearlets on the second scale of a 2 scale shearlet system
% shearletIdxs = SLgetShearletIdxs3D([1 1],0,'scales',2);
%
%See also: SLgetShearletSystem3D, SLgetSubsystem3D


    if nargin < 1
     error('Not enough input parameters!');
    end
    if nargin < 2
        full = 0;
    end

    shearletIdxs = [];
    includeLowpass = 1;
    
    scales = 1:length(shearLevels);
    shearings1 = -2^(max(shearLevels)):2^(max(shearLevels));
    shearings2 = -2^(max(shearLevels)):2^(max(shearLevels));
%     shearings1 = -2:2;
%     shearings2 = -2:2;
    pyramids = 1:3;

    for i = 1:2:length(varargin)
        includeLowpass = 0;
        if strcmp(varargin{i},'scales')
            scales = varargin{i+1};
        elseif strcmp(varargin{i},'shearings1')
            shearings1 = varargin{i+1};             
        elseif strcmp(varargin{i},'shearings2')
            shearings2 = varargin{i+1}; 
        elseif strcmp(varargin{i},'pyramids')
            pyramids = varargin{i+1}; 
        end
    end

    for pyramid = intersect(1:3,pyramids)
        for scale = intersect(1:length(shearLevels),scales)
            for shearing1 = intersect(-2^shearLevels(scale):2^shearLevels(scale),shearings1)
                for shearing2 = intersect(-2^shearLevels(scale):2^shearLevels(scale),shearings2)
                    if full || pyramid == 1 || (pyramid == 2 && abs(shearing2) < 2^shearLevels(scale)) ||(abs(shearing1) < 2^shearLevels(scale) && abs(shearing2) < 2^shearLevels(scale))
                        shearletIdxs = [shearletIdxs; [pyramid scale shearing1 shearing2]];
                    end     
                end
            end
        end
    end
    if includeLowpass || ismember(0,scales) || ismember(0,pyramids)
        shearletIdxs = [shearletIdxs; [0 0 0 0]];
    end
    
%     shearletIdxs
end

%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material