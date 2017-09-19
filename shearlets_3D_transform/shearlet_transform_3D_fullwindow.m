function [ big_coeffs, shearletIdxs, start_index] = shearlet_transform_3D_fullwindow( VID, central_frame, neigh_window, shearLevels, scales, useGPU )
%SHEARLET_TRANSFORM_3D Calculates the 3D Shearlet Transform for the passed
%video sequence
%
% Usage:
%   [coeffs, shearletIdxs] = shearlet_transform_3D(video, 68, 91, [0 1 1], 3, 1)
%           Calculates the transform for the 3D matrix 'video', considering
%           only a subset of all the time interval centered in frame 46 and
%           wide 91 time frames (so, actually, only considering frames from
%           23 to 113 in the sequence). The number of scales chosen is 3,
%           with shearing levels equal to 0, 1 and 1. The last '1' in
%           this function tells ShearLab3D to use the GPU for all the
%           calculations (to increase the speed of all the process).
%
% Parameters:
%   VID: the 3D matrix representing the video sequence to process
%   central_frame: the central frame of the temporal interval we want to
%                  consider
%   neigh_window: the number of total frames to consider
%   shearLevels: the shearing levels for the different scales
%   scales: the number of scales in the transform
%   useGPU: use the GPU to make all the calculations (1 equals to TRUE)
%
% Output:
%   coeffs: the four-dimensional structure representing all the
%           coefficients calculated for the shearlet transform
%   shearletIdxs: the auxiliary matrix representing a 1-1 correspondence
%                 between the fourth index in the 'coeffs' matrix and the
%                 scale/shearing parameters corresponding to the unique
%                 shearlet which gave the corresponding coefficients as a
%                 result
%
%   See also ...
%
% 2016 Damiano Malafronte.

% default setup for the shearing levels, in this way there are going to be
% 3x3, 5x5, 5x5 shearings across the three scales used, for each pyramid
if(isempty(shearLevels))
    shearLevels = [0 1 1];
end

% if not specified by the user, does not use the GPU
if(nargin < 5)
    useGPU = 0;
end

% parameters controls
if(central_frame < 1 || central_frame > size(VID,3))
    ME = MException('shearlet_transform_3D:invalid_central_frame', ...
        'The central frame of the subsequence must be between 1 and the number of total frames.');
    throw(ME);
end

if(neigh_window < 51)
    ME = MException('shearlet_transform_3D:neigh_window_value', ...
        'Specify a bigger value for the neighborhood window, you could incur into problems with the ShearLab3D implementation.');
    throw(ME);
end

if(scales < 1)
    ME = MException('shearlet_transform_3D:scales_too_low', ...
        'Specify a number of scales greater than zero.');
    throw(ME);
end

if(scales > 5)
    warning('shearlet_transform_3D:scales_too_high', ...
        'The number of scales is high, you could incur into memory issues while loading the corresponding shearlet system.');
end

if(numel(shearLevels) ~= scales)
    ME = MException('shearlet_transform_3D:wrong_shearlevels_number', ...
        'The number of shearLevels must be equal to the number of scales.');
    throw(ME);
end

% index of the first frame (and of the last one) to consider
start_ind = central_frame - (neigh_window-1)/2;
end_ind = central_frame + (neigh_window-1)/2;

if(start_ind < 1 && end_ind > size(VID,3))
    ME = MException('shearlet_transform_3D:window_size_too_big', ...
        'The video slice must be reduced (case 1).');
    throw(ME);
end


% fixes possible invalid values for the two indexes

if(start_ind < 1)
    end_ind = neigh_window;
    start_ind = 1;
    
    if(end_ind > size(VID,3))
        ME = MException('shearlet_transform_3D:window_size_too_big', ...
            'The video slice must be reduced (case 3).');
        throw(ME);
    end
    
else
    if(end_ind > size(VID,3))
        end_ind = size(VID,3);
        start_ind = end_ind - neigh_window + 1;
        
        if(start_ind < 1)
            ME = MException('shearlet_transform_3D:window_size_too_big', ...
                'The video slice must be reduced (case 4).');
            throw(ME);
        end

    end
end


% outputs the start index
start_index = start_ind;

% extracts from the video sequence only the frames to consider
Xactual = VID(:,:,start_ind:end_ind);

% prepares the structures for the calculation of the transform
st = tic;
[Xfreq, ~, preparedFilters, dualFrameWeightsCurr, shearletIdxs] = SLprepareSerial3D(useGPU,Xactual,scales,shearLevels, true);
fprintf('-- Time for Serial Preparation: %.4f seconds\n', toc(st));

st = tic;

% initializes the resulting object containing all the coefficients
big_coeffs = zeros(size(Xactual,1), size(Xactual,2), size(Xactual,3), size(shearletIdxs,1));

% calculates the coefficients for each shearlet within the system
for j = 1:size(shearletIdxs,1)
    shearletIdx = shearletIdxs(j,:);
    
    % executes the shearlet decomposition
    [coeffs,~, dualFrameWeightsCurr,~] = SLsheardecSerial3D(Xfreq,shearletIdx,preparedFilters,dualFrameWeightsCurr);
    
    if(~useGPU)
        big_coeffs(:,:,:,j) = coeffs;
    else
        big_coeffs(:,:,:,j) = gather(coeffs);
    end
    
end

% prints the total execution time for this routine
fprintf('-- Time for Serial Decomposition: %.4f seconds\n', toc(st));

end

