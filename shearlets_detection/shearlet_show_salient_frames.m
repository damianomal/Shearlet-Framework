function [ output_args ] = shearlet_show_salient_frames( video, coeffs, num_frames)
%SHEARLET_SHOW_SALIENT_FRAMES Summary of this function goes here
%   Detailed explanation goes here

LOWER_THRESHOLD = 0.4;
SPT_WINDOW = 7;
SCALES = [2];
CONE_WEIGHTS = [1 1 1];

% detect spatio-temporal interesting points within the sequence
[COORDINATES] = shearlet_detect_points( video, coeffs, SCALES, [], LOWER_THRESHOLD, SPT_WINDOW, CONE_WEIGHTS, false);

[COUNTS] = comparison_points_over_time(video, COORDINATES, false);

shearlet_frames_with_most_points(video, COUNTS, num_frames, COORDINATES);

end

