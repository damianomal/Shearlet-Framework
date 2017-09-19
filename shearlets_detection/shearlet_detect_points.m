function [ COORDINATES, change_map ] = shearlet_detect_points( video, coeffs, scales, weights, min_threshold, spt_window, cone_weights, pause_between_frames, output_filename)
%SHEARLET_DETECT_POINTS Detects a set of spatio-temporal interest points in
%the sequence passed as a parameter (more precisely, using the
%corresponding shearlet coefficients, previously calculated)
%
% Usage:
%   [coordinates, change_map] = shearlet_detect_points(video, coeffs, [2 3], [], 0.1, 9, [1 1 1], false, 'trial0001.avi')
%           Detects points in the 'video' matrix passed by considering the
%           values inside the 'coeffs' object, only keeping into account of
%           the values corresponding to the second and third scales.
%           Values below 0.1 will not be considered for the non-maxima
%           supression process, as they will be set to zero, and the local
%           window within which a value has to be the maximum to be
%           considered as a detected point is a cube of side 2*9+1 pixels.
%
% Parameters:
%   video: the matrix representing the video sequence
%   coeffs: the four-dimensional matrix containing the shearlet coefficients
%   scales: the set of scales to consider for the detection
%   weights: the weights to use for each scale (not used, until now)
%   min_threshold: the minumum value for a candidate point
%   spt_window: the neighborhood to consider while searching for local
%               maxima
%   cone_weights: the weights for the different cones 
%   pause_between_frames: whether to pause or not during
%   output_filename: the filename to save the video to
%
% Output:
%   coordinates: a matrix containing a set of triples (x,y,t) representing
%                the coordinates of the spatio-temporal interest points
%                that have been found by the process.
%   change_map: a three-dimensional matrix containing the values for the
%               interest measure considered to extract the points.
%
%   See also ...
%
% 2016 Damiano Malafronte.

% if the user did not specify them, initializes the weights object so that
% all the scales contributes in the same way
if(isempty(weights))
    weights = ones(1,numel(scales))/3;
end

% parameters controls
% if(scales ~= numel(weights))
%     ME = MException('shearlet_detect_points:number_of_weights', ...
%         'You have to specify an equal number of weights and scales.');
%     throw(ME);
% end

if(min_threshold < 0)
    warning('shearlet_detect_points:negative_min_threshold', ...
        'A negative threshold is meaningless, value set to 0.');
    min_threshold = 0;
end

if(spt_window < 1)
    ME = MException('shearlet_detect_points:spatiotemp_window_size', ...
        'You must specify a spatio-temporal window of size 1 at least.');
    throw(ME);
end

% initializes the variables and the time counter
st = tic;
i = 1;

% structure to keep the temporary change maps
% for the different scales used
change_map_temp = cell(1, numel(scales));

% for every scale considered...
for scale = scales
    
    % loads the corresponding shearlet coefficient indexes in memory
    load(strcat('cone_indexes_for_5x5_shearings_scale',int2str(scale),'.mat'))
    
    ind_cone1_sc2 = c1(:);
    ind_cone2_sc2 = c2(:);
    ind_cone3_sc2 = c3(:);
    
    % sums up all the contributions from the different shearings,
    % for the different cones
    second_cone_map = sum(abs(coeffs(:,:,:, ind_cone2_sc2)),4);
    first_cone_map = sum(abs(coeffs(:,:,:, ind_cone1_sc2)),4);
    third_cone_map = sum(abs(coeffs(:,:,:, ind_cone3_sc2)),4);
    
%     combined_map = third_cone_map .* first_cone_map;
%     change_map_temp{i} = second_cone_map .* combined_map;
        
    change_map_temp{i} = (cone_weights(1) * first_cone_map) .* ... 
                         (cone_weights(2) * second_cone_map) .*  ...
                         (cone_weights(3) * third_cone_map);

    i = i + 1;
    
end

% calculates the temporary values within the change map,
% by considering only the first of all the scales (or the
% only one, if less than 2 scales are used)
change_map = weights(1) * change_map_temp{1};

% considers also the contributions from the other scales
for i=2:numel(scales)
    change_map = change_map .* (weights(i) * change_map_temp{i});
end

% prints the running time for the procedure
fprintf('-- Time to create the change map from SH coeffs (number of scales %d): %.4f seconds\n', numel(scales), toc(st));

% looks for the spatio-temporal points and saves them
% in the COORDINATES object
if(nargin < 9)
    [COORDINATES] = shearlet_plot_graylevel_local_maxima( video, change_map, min_threshold, spt_window, pause_between_frames, 3, colormap(jet(256)));
else
    [COORDINATES] = shearlet_plot_graylevel_local_maxima( video, change_map, min_threshold, spt_window, pause_between_frames, 3, colormap(jet(256)), output_filename);  
end

end
