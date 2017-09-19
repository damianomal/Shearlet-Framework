

%%

close all;
clear VID COEFFS idxs

% loads the video sequence

[VID, COLOR_VID] = load_video_to_mat('person01_walking_d1.avi',160, 1,100); %parametri 1 e 7

% calculates the 3D Shearlet Transform

[COEFFS,idxs] = shearlet_transform_3D(VID,46,91,[0 1 1], 3, 1);

%%

% parameters for the detection process

LOWER_THRESHOLD = 0.2;
SPT_WINDOW = 11;
SCALES = [2];
CONE_WEIGHTS = [1 1 1];

% detect spatio-temporal interesting points within the sequence

close all;
[COORDINATES, ~] = shearlet_detect_points( VID(:,:,1:91), COEFFS, SCALES, [], LOWER_THRESHOLD, SPT_WINDOW, CONE_WEIGHTS, false);

%%

% size of the spatio-temporal window used to create the descriptor

DESCR_WINDOW = 5;

% loads the .mat file containing the (previously calculated) 
% spatio-temporal structure representing the cluster index associated with 
% each spatio-temporal point (i.e. the kind of spatio-temporal primitive 
% each (x,y,t) point belongs to).
% 
% the only important element within the .mat file is the "cl_video_idx"
% object

load('person01_walking_d1.mat');

% extracts the descriptors on the basis of the indexes in the cl_video_idx
% structure loaded

POINTS_DESCRIPTORS = shearlet_descriptors_for_coordinates(VID(:,:,1:91), cl_video_idx, COORDINATES, DESCR_WINDOW, false);

%%

% clusters the extracted descriptors via k-means

NUM_CLUSTERS = 4;

opts = statset('Display','final', 'MaxIter',200);
[CLUSTERS_IDS, ~] = kmeans(POINTS_DESCRIPTORS, NUM_CLUSTERS, 'Distance', 'sqeuclidean', 'Replicates',5, 'Options',opts);

%%

% ONLY FOR DEBUG PURPOSES:
%
% shows graphically the shape of the extracted points

close all;
shearlet_show_descriptor_clustered_points(POINTS_DESCRIPTORS, CLUSTERS_IDS, 4);

%%

% shows a subset of the clusters created (in this case, clusters 2 and 4)

shearlet_play_video_clustered_descriptors(VID(:,:,1:91), POINTS_DESCRIPTORS, COORDINATES, CLUSTERS_IDS, [2 4]);
