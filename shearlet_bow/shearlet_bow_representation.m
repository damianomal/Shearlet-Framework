function [ bow_repr ] = shearlet_bow_representation(video, dictionary_repr, dictionary_descr)
%SHEARLET_BOW_REPRESENTATION Summary of this function goes here
%   Detailed explanation goes here

%
frames_per_sequence = 4;

%
LOWER_THRESHOLD = 0.2;
SPT_WINDOW = 7;
SCALES = [2];
CONE_WEIGHTS = [1 1 1];

ALL_CLUSTERS = zeros(100, 121);
cur_cluster = 1;

REPR_SCALE_USED = 3;

bow_repr = zeros(1, size(dictionary,1));

%
clear VID
[VID, ~] = load_video_to_mat(video.name,160, video.start, video.end);

% calculate the 3D Shearlet Transform
clear COEFFS idxs
[COEFFS,idxs] = shearlet_transform_3D(VID,46,91,[0 1 1], 3, 1, [REPR_SCALE_USED]);

% detect spatio-temporal interesting points within the sequence
[COORDINATES, ~] = shearlet_detect_points( VID(:,:,1:91), COEFFS, SCALES, [], LOWER_THRESHOLD, SPT_WINDOW, CONE_WEIGHTS, false);

%
[COUNTS] = comparison_points_over_time(VID(:,:,1:91), COORDINATES, false);

%
[FRAMES] = shearlet_n_frames_with_most_points(COUNTS, frames_per_sequence, 1);

%
for cur_frame=FRAMES
    
    % calcola la rappresentazione usando i centroidi passati
    clear REPRESENTATION
    [REPRESENTATION] = shearlet_descriptor(COEFFS, cur_frame, REPR_SCALE_USED, idxs, true, true);
    
    % clusters the representations for this particular frame in N clusters
    [CL_IND] = shearlet_cluster_by_seeds( REPRESENTATION, COEFFS, dictionary_repr);
end


end

