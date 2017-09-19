
%% 

% load the video sequence (contained in the sample_sequences directory)

clear VID

% video_filename = 'line_l.mp4';
% VID = load_video_to_mat(video_filename,160,400,500, true);

% video_filename = 'mixing_cam1.avi';
% VID = load_video_to_mat(video_filename,160,1,100, true);

% video_filename = 'person04_running_d1_uncomp.avi';
video_filename = 'person04_boxing_d1_uncomp.avi';
% video_filename = 'person01_handwaving_d1_uncomp.avi';
VID = load_video_to_mat(video_filename,160,1,100, true);


% video_filename = 'TRUCK.mp4';
% VID = load_video_to_mat(video_filename,160,1300,1400, true);


% video_filename = 'Sample0001_color.mp4';
% VID = load_video_to_mat(video_filename,160,1238,1338, true);

% calculate the 3D Shearlet Transform

clear COEFFS idxs 
[COEFFS,idxs] = shearlet_transform_3D(VID,46,91,[0 1 1], 3, 1, [2 3]);

%% CLUSTERING OF A SINGLE FRAME USING THE SHEARLET-BASED REPRESENTATION DEVELOPED

% calculate the representation for a specific frame (frame number 37 of the
% sequence represented in the VID structure)

TARGET_FRAME = 37;
SCALE_USED = 2;

REPRESENTATION = shearlet_descriptor_fast(COEFFS, TARGET_FRAME, SCALE_USED, idxs, true, true);

% clusters the representations for this particular frame in N clusters


%% VISUALIZING THE CLUSTERING RESULTS FOR A FIXED NUMBER OF CLUSTERS

CLUSTER_NUMBER = 8;
[CL_IND, CTRS] = shearlet_cluster_coefficients(REPRESENTATION, CLUSTER_NUMBER, [size(COEFFS,1) size(COEFFS,2)]);

% sorts the clusters with respect to their size, and also rea

[SORTED_CL_IMAGE, SORT_CTRS] = shearlet_cluster_sort(CL_IND, CTRS);

% shows a colormap associated with the clusters found

[~,~,img] = shearlet_cluster_image(SORTED_CL_IMAGE, CLUSTER_NUMBER, false, false);

close all;

figure;
subplot(1,2,1); imshow(VID(:,:,TARGET_FRAME), []);
subplot(1,2,2); imshow(img);

%% VISUALIZING THE CLUSTERING RESULTS FOR SEVERAL SETS OF CLUSTERS

CLUSTERS_FIRST = 2;

figure;

for cl=CLUSTERS_FIRST:CLUSTERS_FIRST+7
    
    [CL_IND, CTRS] = shearlet_cluster_coefficients(REPRESENTATION, cl, [size(COEFFS,1) size(COEFFS,2)]);

    [SORTED_CL_IMAGE, SORT_CTRS] = shearlet_cluster_sort(CL_IND, CTRS);

    [~,~,img] = shearlet_cluster_image(SORTED_CL_IMAGE, cl, false, false);

    subplot(2,4,cl-CLUSTERS_FIRST+1);

    imshow(img);
end

%%

% shows a single cluster as an overlay on the original frame

CLUSTER_TO_SHOW = 8;
[~, mask] = shearlet_overlay_cluster(VID(:,:,TARGET_FRAME), SORTED_CL_IMAGE, CLUSTER_TO_SHOW, true, true);
% shearlet_show_avg_descriptor(COEFFS, 46, 3, idxs, SORTED_CL_IMAGE == CLUSTER_TO_SHOW);


%%

shearlet_show_avg_descriptor(COEFFS, 46, 3, idxs, SORTED_CL_IMAGE == CLUSTER_TO_SHOW);

%% CLUSTERING A NEW SEQUENCE STARTING FROM THE CENTROIDS PREVIOUSLY CALCULATED

% loads the sequence (contained in the sample_sequences directory) and 
% calculates the transform

clear VID;
VID = load_video_to_mat('salt1_cam0.avi',160, 1,100);

clear COEFFS idxs 
[COEFFS,idxs] = shearlet_transform_3D(VID,46,91,[0 1 1], 3, 1);

% calculate the representation for a specific frame (frame number 35 of the
% new sequence selected)

TARGET_FRAME = 35;
SCALE_USED = 3;

REPRESENTATION = shearlet_descriptor_fast(COEFFS, TARGET_FRAME, SCALE_USED, idxs, true);

% clusters the representations for this particular frame using the
% centroids coming from a previous clustering process (here the SORT_CTRS
% object is the one calculated in the previous section of this MATLAB
% script)

%%
close all
% CL_IND = shearlet_cluster_by_seeds(REPRESENTATION, COEFFS, ASLAN_20_centroids_scale2);
% CL_IND = shearlet_cluster_by_seeds(REPRESENTATION, COEFFS, CHALEARN_12_centroids_scale3);
% CL_IND = shearlet_cluster_by_seeds(REPRESENTATION, COEFFS, KTH_20_centroids_scale2);
% CL_IND = shearlet_cluster_by_seeds(REPRESENTATION, COEFFS, EATING2_12_centroids_scale3);
CL_IND = shearlet_cluster_by_seeds(REPRESENTATION, COEFFS, EATING2CAM2_20_centroids_scale3);

% shows a colormap associated with the clusters found
CLUSTER_NUMBER = 12;
shearlet_cluster_image(CL_IND, CLUSTER_NUMBER, true, false);

% shows a single cluster as an overlay on the original frame

% CLUSTER_TO_SHOW = 5;
% shearlet_overlay_cluster(VID(:,:,TARGET_FRAME), CL_IND, CLUSTER_TO_SHOW, true, true);


