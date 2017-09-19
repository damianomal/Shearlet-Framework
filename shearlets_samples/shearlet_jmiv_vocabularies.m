
s1 = struct('name', 'person04_boxing_d1_uncomp.avi', 'start', 1, 'end', 100);
s2 = struct('name', 'person01_walking_d1_uncomp.avi', 'start', 1, 'end', 100);
s3 = struct('name', 'person01_handwaving_d1_uncomp.avi', 'start', 1, 'end', 100);

% KTH_20_centroids_scale2 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 20);
KTH_boxing_12_centroids_scale2 = shearlet_build_vocabulary_repr({s1}, 4, 0, 0, 12, 2);
KTH_walking_12_centroids_scale2 = shearlet_build_vocabulary_repr({s2}, 4, 0, 0, 12, 2);
KTH_handwaving_12_centroids_scale2 = shearlet_build_vocabulary_repr({s3}, 4, 0, 0, 12, 2);


%% BOXING vs HANDWAVING

[TOTALCOST_BvH, ~, ASSIGN_BvH] = shearlet_compare_vocabulary_munkres(KTH_boxing_12_centroids_scale2, ...
    KTH_handwaving_12_centroids_scale2, ...
    false, true);

%% BOXING vs WALKING

[TOTALCOST_BvW, ~, ASSIGN_BvW] = shearlet_compare_vocabulary_munkres(KTH_boxing_12_centroids_scale2, ...
    KTH_walking_12_centroids_scale2, ...
    false, true);

%%

s1 = struct('name', 'Sample0001_color.mp4', 'start', 1238, 'end', 1400);

CHALEARN_12_centroids_scale2 = shearlet_build_vocabulary_repr({s1}, 4, 0, 0, 12, 2);

%% BOXING vs CHALEARN

[TOTALCOST_BvCh, ~, ASSIGN_BvCh] = shearlet_compare_vocabulary_munkres(KTH_boxing_12_centroids_scale2, ...
    CHALEARN_12_centroids_scale2, ...
    false, true);

%%

video_filename = 'person04_boxing_d1_uncomp.avi';
% video_filename = 'person01_walking_d1_uncomp.avi';
% video_filename = 'person01_handwaving_d1_uncomp.avi';
VID = load_video_to_mat(video_filename,160,1,100, true);

clear COEFFS idxs
[COEFFS,idxs] = shearlet_transform_3D(VID,46,91,[0 1 1], 3, 1, [2 3]);

%% CLUSTERING OF A SINGLE FRAME USING THE SHEARLET-BASED REPRESENTATION DEVELOPED

% calculate the representation for a specific frame (frame number 37 of the
% sequence represented in the VID structure)

TARGET_FRAME = 37;
SCALE_USED = 2;

REPRESENTATION_boxing = shearlet_descriptor_fast(COEFFS, TARGET_FRAME, SCALE_USED, idxs, true, true);

%%

% clusters the representations for this particular frame in N clusters

CLUSTER_NUMBER = 8;
[CL_IND_boxing, CTRS_boxing] = shearlet_cluster_coefficients(REPRESENTATION_boxing, CLUSTER_NUMBER, [size(COEFFS,1) size(COEFFS,2)]);

% sorts the clusters with respect to their size, and also rea

[SORTED_CL_IMAGE_boxing, SORT_CTRS_boxing] = shearlet_cluster_sort(CL_IND_boxing, CTRS_boxing);

% shows a colormap associated with the clusters found

[~,~,img_boxing] = shearlet_cluster_image(SORTED_CL_IMAGE_boxing, CLUSTER_NUMBER, false, false);

close all;

figure;
subplot(1,2,1); imshow(VID(:,:,TARGET_FRAME), []);
subplot(1,2,2); imshow(img_boxing);



%%

% video_filename = 'person01_walking_d1_uncomp.avi';
video_filename = 'person01_handwaving_d1_uncomp.avi';
VID = load_video_to_mat(video_filename,160,1,100, true);

clear COEFFS idxs
[COEFFS,idxs] = shearlet_transform_3D(VID,46,91,[0 1 1], 3, 1, [2 3]);

%% CLUSTERING OF A SINGLE FRAME USING THE SHEARLET-BASED REPRESENTATION DEVELOPED

% calculate the representation for a specific frame (frame number 37 of the
% sequence represented in the VID structure)

TARGET_FRAME = 36;
SCALE_USED = 2;

REPRESENTATION_handwaving = shearlet_descriptor_fast(COEFFS, TARGET_FRAME, SCALE_USED, idxs, true, true);

%%

% clusters the representations for this particular frame in N clusters

CLUSTER_NUMBER = 8;
[CL_IND_handwaving, CTRS_handwaving] = shearlet_cluster_coefficients(REPRESENTATION_handwaving, CLUSTER_NUMBER, [size(COEFFS,1) size(COEFFS,2)]);

% sorts the clusters with respect to their size, and also rea

[SORTED_CL_IMAGE_handwaving, SORT_CTRS_handwaving] = shearlet_cluster_sort(CL_IND_handwaving, CTRS_handwaving);

% shows a colormap associated with the clusters found

[~,~,img_handwaving] = shearlet_cluster_image(SORTED_CL_IMAGE_handwaving, CLUSTER_NUMBER, false, false);

close all;

figure;
subplot(1,2,1); imshow(VID(:,:,TARGET_FRAME), []);
subplot(1,2,2); imshow(img_handwaving);




%%

video_filename = 'person01_walking_d1_uncomp.avi';
VID = load_video_to_mat(video_filename,160,1,100, true);

clear COEFFS idxs
[COEFFS,idxs] = shearlet_transform_3D(VID,46,91,[0 1 1], 3, 1, [2 3]);

%% CLUSTERING OF A SINGLE FRAME USING THE SHEARLET-BASED REPRESENTATION DEVELOPED

% calculate the representation for a specific frame (frame number 37 of the
% sequence represented in the VID structure)

TARGET_FRAME = 38;
SCALE_USED = 2;

REPRESENTATION_walking = shearlet_descriptor_fast(COEFFS, TARGET_FRAME, SCALE_USED, idxs, true, true);

%%

% clusters the representations for this particular frame in N clusters

CLUSTER_NUMBER = 8;
[CL_IND_walking, CTRS_walking] = shearlet_cluster_coefficients(REPRESENTATION_walking, CLUSTER_NUMBER, [size(COEFFS,1) size(COEFFS,2)]);

% sorts the clusters with respect to their size, and also rea

[SORTED_CL_IMAGE_walking, SORT_CTRS_walking] = shearlet_cluster_sort(CL_IND_walking, CTRS_walking);

% shows a colormap associated with the clusters found

[~,~,img_walking] = shearlet_cluster_image(SORTED_CL_IMAGE_walking, CLUSTER_NUMBER, false, false);

close all;

figure;
subplot(1,2,1); imshow(VID(:,:,TARGET_FRAME), []);
subplot(1,2,2); imshow(img_walking);



%%

video_filename = 'person04_boxing_d1_uncomp.avi';
% video_filename = 'person01_walking_d1_uncomp.avi';
% video_filename = 'person01_handwaving_d1_uncomp.avi';
VID = load_video_to_mat(video_filename,160,1,100, true);

clear COEFFS idxs
[COEFFS,idxs] = shearlet_transform_3D(VID,46,91,[0 1 1], 3, 1, [2 3]);

%% CLUSTERING OF A SINGLE FRAME USING THE SHEARLET-BASED REPRESENTATION DEVELOPED

% calculate the representation for a specific frame (frame number 37 of the
% sequence represented in the VID structure)

TARGET_FRAME = 74;
SCALE_USED = 2;

REPRESENTATION_boxing2 = shearlet_descriptor_fast(COEFFS, TARGET_FRAME, SCALE_USED, idxs, true, true);

%%

% clusters the representations for this particular frame in N clusters

CLUSTER_NUMBER = 8;
[CL_IND_boxing2, CTRS_boxing2] = shearlet_cluster_coefficients(REPRESENTATION_boxing2, CLUSTER_NUMBER, [size(COEFFS,1) size(COEFFS,2)]);

% sorts the clusters with respect to their size, and also rea

[SORTED_CL_IMAGE_boxing2, SORT_CTRS_boxing2] = shearlet_cluster_sort(CL_IND_boxing2, CTRS_boxing2);

% shows a colormap associated with the clusters found

[~,~,img_boxing2] = shearlet_cluster_image(SORTED_CL_IMAGE_boxing2, CLUSTER_NUMBER, false, false);

close all;

figure;
subplot(1,2,1); imshow(VID(:,:,TARGET_FRAME), []);
subplot(1,2,2); imshow(img_boxing2);


