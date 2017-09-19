

%%

close all;
clear VID COEFFS idxs


%%

% loads the indexes for the 5x5 shearing matrices,
% corresponding to the second scale and to the three cones

load('cone_indexes_for_5x5_shearings_scale2.mat')

ind_cone1_sc2 = c1(:);
ind_cone2_sc2 = c2(:);
ind_cone3_sc2 = c3(:);

% loads the indexes for the 5x5 shearing matrices,
% corresponding to the third scale and to the three cones

load('cone_indexes_for_5x5_shearings_scale3.mat')

ind_cone1_sc3 = c1(:);
ind_cone2_sc3 = c2(:);
ind_cone3_sc3 = c3(:);


%%

% loads the video sequence

% [VID, COLOR_VID] = load_video_to_mat('person01_handclapping_d4_uncomp.avi',160, 1,100); %parametri 1 e 7
[VID, COLOR_VID] = load_video_to_mat('person01_walking_d1_uncomp.avi',160, 1,100); %parametri 1 e 7
% [VID, COLOR_VID] = load_video_to_mat('person01_running_d1_uncomp.avi',160, 1,100);
% [VID, COLOR_VID] = load_video_to_mat('person01_running_d2_uncomp.avi',160, 1,100);
% [VID, COLOR_VID] = load_video_to_mat('person03_walking_d1_uncomp.avi',160, 1,100);
% [VID, COLOR_VID] = load_video_to_mat('person02_boxing_d2_uncomp.avi',160, 1,100); % parametri 1.5 e 5
% [VID, COLOR_VID] = load_video_to_mat('person02_jogging_d3_uncomp.avi',160, 1,100); % parametri 1.5 e 5
% [VID, COLOR_VID] = load_video_to_mat('person02_boxing_d3_uncomp.avi',160, 1,100); % parametri 1.5 e 5
% [VID, COLOR_VID] = load_video_to_mat('person02_walking_d3_uncomp.avi',160, 1,100); % parametri 1.5 e 5
% [VID, COLOR_VID] = load_video_to_mat('person04_running_d1_uncomp.avi',160, 1,100); %parametri 1 e 7
% [VID, COLOR_VID] = load_video_to_mat('person04_boxing_d1_uncomp.avi',160, 1,100); % parametri 1.5 e 5
% [VID, COLOR_VID] = load_video_to_mat('person04_jogging_d4_uncomp.avi',160, 1,100);
% [VID, COLOR_VID] = load_video_to_mat('person05_handwaving_d3_uncomp.avi',160, 1,100); %parametri 1 e 7
% [VID, COLOR_VID] = load_video_to_mat('person09_boxing_d4_uncomp.avi',160, 1,100); %parametri 1 e 7



% [VID, COLOR_VID] = load_video_to_mat('line_l.mp4',160, 400,500);
% [VID, COLOR_VID] = load_video_to_mat('pendolo.avi', 160, 200, 300);

% [VID, COLOR_VID] = load_video_to_mat('WALK.avi',160, 1,100);
% [VID, COLOR_VID] = load_video_to_mat('walk-simple.avi',160, 1,100);
% [VID, COLOR_VID] = load_video_to_mat('walk-complex.avi',160, 1,100);

% [VID, COLOR_VID] = load_video_to_mat('Sample0001_color.mp4', 160, 1190, 1400);

% [VID, COLOR_VID] = load_video_to_mat('single_big_triangle_320.avi', 160, 80, 200);
% [VID, COLOR_VID] = load_video_to_mat('single_big_triangle_still_320.avi', 160, 80, 200);

% [VID, COLOR_VID] = load_video_to_mat('trial_001.mpeg', 160, 120, 220);
% [VID, COLOR_VID] = load_video_to_mat('trial_002.mpeg', 160, 120, 220);


% [VID, COLOR_VID] = load_video_to_mat('7-0006.mp4', 160, 1, 100);
% [VID, COLOR_VID] = load_video_to_mat('7-0238.mp4', 160, 80, 180);


% [VID, COLOR_VID] = load_video_to_mat('trial_018.avi', 160, 80, 180);
% [VID, COLOR_VID] = load_video_to_mat('trial_024.avi', 160, 80, 180);

% calculates the 3D Shearlet Transform

[COEFFS,idxs] = shearlet_transform_3D(VID,46,91,[0 1 1], 3, 1);
% [COEFFS,idxs] = shearlet_transform_3D(VID,94,91,[0 1 1], 3, 1); % per gesture ok del video Sample0001

%%

% calculate a "change map" related to the temporal dimension

st = tic;
change_map_sc2 = sum(abs(COEFFS(:,:,:, ind_cone2_sc2)),4);

% considers also the changes in the spatial dimensions (cone 1 and cone 3)

first_cone_map = sum(abs(COEFFS(:,:,:, ind_cone1_sc2)),4);
third_cone_map = sum(abs(COEFFS(:,:,:, ind_cone3_sc2)),4);

% combined_map = third_cone_map + first_cone_map;
combined_map = third_cone_map .* first_cone_map;

% change_map(change_map < 1) = 0;
change_map_sc2 = change_map_sc2 .* combined_map;

%
fprintf('-- Time to create the change map from SH coeffs (scale 2): %.4f seconds\n', toc(st));


%%

% calculate a "change map" related to the temporal dimension

st = tic;
change_map_sc3 = sum(abs(COEFFS(:,:,:, ind_cone2_sc3)),4);

% considers also the changes in the spatial dimensions (cone 1 and cone 3)

first_cone_map = sum(abs(COEFFS(:,:,:, ind_cone1_sc3)),4);
third_cone_map = sum(abs(COEFFS(:,:,:, ind_cone3_sc3)),4);

% combined_map = third_cone_map + first_cone_map;
combined_map = third_cone_map .* first_cone_map;

% change_map(change_map < 1) = 0;
change_map_sc3 = change_map_sc3 .* combined_map;

%
fprintf('-- Time to create the change map from SH coeffs (scale 3): %.4f seconds\n', toc(st));

%%

w_sc2 = 1;
w_sc3 = 1;

change_map_sc23 = (w_sc2*change_map_sc2) .* (w_sc3*change_map_sc3);

%%

change_map_sc23_smooth = smooth3(change_map_sc23,'box',3);
%%

% shows the local maxima

USED_MAP = change_map_sc23;
LOWER_THRESHOLD = 0.01;  % old values was 0.01
SPT_WINDOW = 5;          % old values was 7
PAUSE_BETWEEN_FRAMES = false;

close all;

% shearlet_plot_graylevel_local_maxima( VID(:,:,1:91), change_map_sc2, 0.5, 9, false, 3, colormap(jet(256)), 'person01_walking_d1_uncomp_heatmap_jet_sc2.avi');  % buono boxing? centrato in 46, SCALA 2
[COORDINATES] = shearlet_plot_graylevel_local_maxima( VID(:,:,1:91), USED_MAP, LOWER_THRESHOLD, SPT_WINDOW, PAUSE_BETWEEN_FRAMES, 3, colormap(jet(256)));  % buono boxing? centrato in 46, SCALA 2
% [COORDINATES] = shearlet_plot_graylevel_local_maxima( VID(:,:,49:94+45), USED_MAP, LOWER_THRESHOLD, SPT_WINDOW, PAUSE_BETWEEN_FRAMES, 3, colormap(jet(256)));  % buono boxing? centrato in 46, SCALA 2

% shearlet_plot_graylevel_local_maxima_multiple_scales( VID(:,:,1:91), change_map_sc2, change_map_sc3, 0.5, 9, true, 3, colormap(jet(256)));  % buono boxing? centrato in 46, SCALA 2

%%

comparison_local_maxima_in_frame(VID(:,:,49:94+45), COLOR_VID(:,:,:,49:94+45), USED_MAP, LOWER_THRESHOLD, SPT_WINDOW, PAUSE_BETWEEN_FRAMES, 3, colormap(jet(256)));  % buono boxing? centrato in 46, SCALA 2

%%

close all;

[~, FG_CENTROIDS] = comparison_mask_from_kth_video(VID(:,:,1:91), bg_averaged, 90);
[TRANSLATED] = comparison_translate_points_by_centroid(COORDINATES, FG_CENTROIDS, VID);
comparison_heatmap_from_points(VID, floor(TRANSLATED));

%%

[COUNTS] = comparison_points_over_time(VID(:,:,1:91), COORDINATES);
% [COUNTS] = comparison_points_over_time(VID(:,:,49:94+45), COORDINATES);


%%

[~, COUNTS_IND] = sort(COUNTS,2, 'descend');

close all;
figure;

subplot(1,4,1);
imshow(COLOR_VID(:,:,:,COUNTS_IND(1))./255);

subplot(1,4,2);
imshow(COLOR_VID(:,:,:,COUNTS_IND(2))./255);

subplot(1,4,3);
imshow(COLOR_VID(:,:,:,COUNTS_IND(3))./255);

subplot(1,4,4);
imshow(COLOR_VID(:,:,:,COUNTS_IND(4))./255);


% subplot(1,4,1);
% imshow(COLOR_VID(:,:,:,49+COUNTS_IND(1)-1)./255);
% 
% subplot(1,4,2);
% imshow(COLOR_VID(:,:,:,49+COUNTS_IND(2)-1)./255);
% 
% subplot(1,4,3);
% imshow(COLOR_VID(:,:,:,49+COUNTS_IND(3)-1)./255);
% 
% subplot(1,4,4);
% imshow(COLOR_VID(:,:,:,49+COUNTS_IND(4)-1)./255);

%% 

[POINTS_HEATMAP] = comparison_heatmap_from_points(VID, COORDINATES);

%%

[FG_MASKS, FG_CENTROIDS] = comparison_mask_from_kth_video(VID(:,:,1:91), VID(:,:,1:3));


%% 

[TRANSLATED] = comparison_translate_points_by_centroid(COORDINATES, FG_CENTROIDS, VID(:,:,1));

%%

comparison_heatmap_from_points(VID, floor(TRANSLATED));

%%

% XYZnew = AxelRot(double(FG_MASKS), 90, [1 0 0],[]);

% XYZnew = FG_MASKS;
% 
% for i=1:size(FG_MASKS,3)
%     XYZnew(:,:,i) = FG_MASKS(:,:,end-i+1);
% end

% XYZnew = permute(FG_MASKS,[3 2 1]);

close all;

comparison_3d_visualization_from_points(FG_MASKS, COORDINATES);


%%

close all;

shearlet_visualize_change_map( VID(:,:,1:91), change_map_sc2, 3, colormap(jet(256)));
% shearlet_visualize_change_map( VID(:,:,49:94+45), change_map_sc2, 3, colormap(jet(256)));

%%

% extracts a set of locally interesting points starting from the map
% calculates previously

USED_MAP = change_map_sc2;
LOWER_THRESHOLD = 0.2;
SPT_WINDOW = 11;
PAUSE_BETWEEN_FRAMES = true;


% parametri usati (0.5, 11, 5) lunedi' pomeriggio
% for "person02_jogging_d3" the threshold should be set at 0.45

% [POINTS_DESCRIPTORS, COORDINATES] = shearlet_extract_descriptor( VID(:,:,1:91), cl_video_idx, change_map_sc2, 1, 9, 5, false); % prove originali di lunedi' mattina
[POINTS_DESCRIPTORS, COORDINATES] = shearlet_extract_descriptor( VID(:,:,1:91), cl_video_idx, USED_MAP, LOWER_THRESHOLD, SPT_WINDOW, 5, PAUSE_BETWEEN_FRAMES); % prove lunedi' pomeriggio - SCALA 2
% [POINTS_DESCRIPTORS, COORDINATES] = shearlet_extract_descriptor( VID(:,:,1:91), cl_video_idx, change_map_sc2, 0.1, 9, 5, false); % prove lunedi' pomeriggio - SCALA 3




%% DEBUG

%
shearlet_extract_descriptor_from_single_picture( VID(:,:,1:91), cl_video_idx, change_map_sc2, 37,  0.5, 9, 5, true);


%%

% clusters the extracted descriptors via k-means

opts = statset('Display','final', 'MaxIter',200);
[CIDX, ~] = kmeans(POINTS_DESCRIPTORS, 4, 'Distance', 'sqeuclidean', 'Replicates',5, 'Options',opts);

%%

% shows graphically the shape of the extracted points

close all;
shearlet_show_descriptor_clustered_points(POINTS_DESCRIPTORS, CIDX, 4);

%%

% shows one of the clusters extracted

shearlet_play_video_clustered_descriptors(VID(:,:,1:91), POINTS_DESCRIPTORS, COORDINATES, CIDX, [1 3]);
