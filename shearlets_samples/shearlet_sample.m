


%% ESEMPIO CLSUTERING BOXING

close all;
clear VID COEFFS idxs DESCR_MAT CTRS CL_IND CL_SORT

% VID = load_video_to_mat('person01_walking_d1_uncomp.avi',160, 1,100);
% VID = load_video_to_mat('person04_boxing_d1_uncomp.avi',160, 1,100);
VID = load_video_to_mat('line_l.mp4',160, 400,500);
% VID = load_video_to_mat('alessia_rectangle.mp4',160, 1100,1200);
% VID = load_video_to_mat('person09_boxing_d4_uncomp.avi',160, 1,100);
% VID = load_video_to_mat('WALK.avi',160, 1,100);

[COEFFS,idxs] = shearlet_transform_3D(VID,46,91,[0 1 1], 3, 1);
% DESCR_MAT = shearlet_descriptor(COEFFS, 37, 2, idxs, true, true);

%% 

close all;

DESCR_MAT = shearlet_descriptor(COEFFS, 37, 3, idxs, true, true);
[CL_IND, CTRS] = shearlet_cluster_coefficients(DESCR_MAT, 10, [size(COEFFS,1) size(COEFFS,2)]);

[sort_cl_image, SORT_CTRS] = shearlet_cluster_sort( CL_IND, CTRS);

% sort_cl_image = shearlet_cluster_by_seeds(DESCR_MAT, COEFFS, SORT_CTRS);


shearlet_cluster_image(sort_cl_image, 10, true, false);
    
shearlet_overlay_cluster(VID(:,:,37), sort_cl_image, 10, true, true);

%% ESEMPIO CLUSTERING DI UN ALTRO FRAME DEL VIDEO BOXING A PARTIRE DAI CENTROIDI QUI SOPRA

TARGET_FRAME = 35;
DESCR_SCALE = 2;

clear VID;
% VID = load_video_to_mat('person01_handclapping_d1_uncomp.avi',160, 1,100);
% VID = load_video_to_mat('person01_walking_d1_uncomp.avi',160, 1,100);
% VID = load_video_to_mat('person04_boxing_d1_uncomp.avi',160, 1,100);
% VID = load_video_to_mat('person01_running_d2_uncomp.avi',160, 1,100);
VID = load_video_to_mat('person09_boxing_d4_uncomp.avi',160, 1,100);
% VID = load_video_to_mat('person01_handwaving_d1_uncomp.avi',160, 1,100);
% VID = load_video_to_mat('Sample0001_color.mp4',160, 1190,1400);

% VID = load_video_to_mat('WALK.avi',160, 1,100);

clear COEFFS
% [COEFFS,idxs] = shearlet_transform_3D(VID,94,91,[0 1 1], 3, 1);
[COEFFS,idxs] = shearlet_transform_3D(VID,46,91,[0 1 1], 3, 1);
DESCR_MAT = shearlet_descriptor(COEFFS, TARGET_FRAME, DESCR_SCALE, idxs, true);


% DESCR_MAT = shearlet_descriptor(COEFFS, TARGET_FRAME, DESCR_SCALE, idxs, true);
CL_IND = shearlet_cluster_by_seeds(DESCR_MAT, COEFFS, SORT_CTRS);

shearlet_cluster_image(CL_IND, 8, true, false);
shearlet_overlay_cluster(VID(:,:,TARGET_FRAME), CL_IND, 8, true, true);

%% ESEMPIO CLUSTERING VIDEO BALLERINA BRACCIO4
VID = load_video_to_mat('trial_001.mpeg',160, 100, 300);
[COEFFS,idxs] = shearlet_transform_3D(VID,65,91,[0 1 1], 3, 1);
DESCR_MAT = shearlet_descriptor(COEFFS, 46, 2, idxs, true);

[CL_IND, CTRS] = shearlet_cluster_coefficients(DESCR_MAT, 8, [size(COEFFS,1) size(COEFFS,2)]);
[sort_cl_image, SORT_CTRS] = shearlet_cluster_sort( CL_IND, CTRS);

% CL_IND = shearlet_cluster_by_seeds(DESCR_MAT, COEFFS, SORT_CTRS);


% shearlet_cluster_image(CL_IND, 8, true, false);
shearlet_cluster_image(sort_cl_image, 8, true, false);
% shearlet_overlay_cluster(VID(:,:,65), CL_IND, 8, true, true);
shearlet_overlay_cluster(VID(:,:,65), sort_cl_image, 8, true, true);

%% ESEMPIO CLUSTERING VIDEO BALLERINA BRACCIO CON ALTRI CENTROIDI (da scala 2)

VID = load_video_to_mat('trial_001.mpeg',160, 100, 300);
[COEFFS,idxs] = shearlet_transform_3D(VID,65,91,[0 1 1], 3, 1);
DESCR_MAT = shearlet_descriptor(COEFFS, 46, 3, idxs, true);

CL_IND = shearlet_cluster_by_seeds(DESCR_MAT, COEFFS, SORT_CTRS);

shearlet_cluster_image(CL_IND, 8, true, false);
shearlet_overlay_cluster(VID(:,:,65), CL_IND, 8, true, true);


%% ESEMPIO CLUSTERING VIDEO KTH ALTRO GENERE



%% ESEMPIO CLUSTERING BOXING DA CENTROIDI PRE-CALCOLATI

close all;
clear VID COEFFS idxs DESCR_MAT CTRS CL_IND CL_SORT

FRAME_TO_CLUSTER = 37;
TARGET_FRAME = 37;
DESCR_SCALE = 2;

VID = load_video_to_mat('person04_boxing_d1_uncomp.avi',160, 1,100);
[COEFFS,idxs] = shearlet_transform_3D(VID,46,91,[0 1 1], 3, 1);

DESCR_MAT = shearlet_descriptor(COEFFS, FRAME_TO_CLUSTER, DESCR_SCALE, idxs, true, true);
[CL_IND, CTRS] = shearlet_cluster_coefficients(DESCR_MAT, 8, [size(COEFFS,1) size(COEFFS,2)]);

[~, SORT_CTRS] = shearlet_cluster_sort( CL_IND, CTRS);


DESCR_MAT = shearlet_descriptor(COEFFS, TARGET_FRAME, DESCR_SCALE, idxs, true);
CL_IND = shearlet_cluster_by_seeds(DESCR_MAT, COEFFS, SORT_CTRS);

shearlet_cluster_image(CL_IND, 8, true, false);
shearlet_overlay_cluster(VID(:,:,TARGET_FRAME), CL_IND, 8, true, true);


%% ESEMPIO EDGES

close all;
clear VID COEFFS idxs

VID = load_video_to_mat('Sample0001_color.mp4', 160, 1190, 1400);
[COEFFS,idxs] = shearlet_transform_3D(VID,94,91,[0 1 1], 3, 1);
shearlet_average_edge_descriptor( VID(:,:,94), COEFFS, idxs, 46, 3);



