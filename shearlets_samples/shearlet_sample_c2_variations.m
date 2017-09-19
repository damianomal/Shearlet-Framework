



%% ESEMPIO CLSUTERING BOXING

close all;

load('cone_indexes_for_5x5_shearings.mat')
% load('cone_indexes_for_5x5_shearings_scale3.mat')
ind_cone1 = c1(:);
ind_cone2 = c2(:);
ind_cone3 = c3(:);


close all;
clear VID COEFFS idxs



% VID = load_video_to_mat('person01_walking_d1_uncomp.avi',160, 1,100); %parametri 1 e 7
% VID = load_video_to_mat('person01_handclapping_d4_uncomp.avi',160, 1,100); %parametri 1 e 7
% VID = load_video_to_mat('person04_boxing_d1_uncomp.avi',160, 1,100); % parametri 1.5 e 5
% VID = load_video_to_mat('person02_boxing_d2_uncomp.avi',160, 1,100); % parametri 1.5 e 5
% VID = load_video_to_mat('line_l.mp4',160, 400,500);
VID = load_video_to_mat('WALK.avi',160, 1,100);
% VID = load_video_to_mat('person05_handwaving_d3_uncomp.avi',160, 1,100);
% VID = load_video_to_mat('person01_running_d1_uncomp.avi',160, 1,100);
% VID = load_video_to_mat('Sample0001_color.mp4', 160, 1190, 1400);

%
[COEFFS,idxs] = shearlet_transform_3D(VID,46,91,[0 1 1], 3, 1);
% [COEFFS,idxs] = shearlet_transform_3D(VID,94,91,[0 1 1], 3, 1);

% 
st = tic;
BC = sum(abs(COEFFS(:,:,:, ind_cone2)),4);

% considers also the changes in the spatial dimensions (cone 1 and cone 3)

first_cone_map = sum(abs(COEFFS(:,:,:, ind_cone1)),4);
third_cone_map = sum(abs(COEFFS(:,:,:, ind_cone3)),4);

% combined_map = third_cone_map + first_cone_map;
combined_map = third_cone_map .* first_cone_map;

% change_map(change_map < 1) = 0;
BC = BC .* combined_map;

%
fprintf('-- Time to create the change map from SH coeffs: %.4f seconds\n', toc(st));


% load('cone_indexes_for_5x5_shearings_scale3.mat')
% ind_cone1 = c1(:);
% ind_cone2 = c2(:);
% ind_cone3 = c3(:);
% 
% BBC = sum(abs(COEFFS(:,:,:, ind_cone2)),4);
% 
% % considers also the changes in the spatial dimensions (cone 1 and cone 3)
% 
% first_cone_map = sum(abs(COEFFS(:,:,:, ind_cone1)),4);
% third_cone_map = sum(abs(COEFFS(:,:,:, ind_cone3)),4);
% 
% % combined_map = third_cone_map + first_cone_map;
% combined_map = third_cone_map .* first_cone_map;
% 
% % change_map(change_map < 1) = 0;
% BBC = BBC .* combined_map;
% 
% BC = BC .* BBC;

% shearlet_save_matrix_to_video( VID(:,:,1:100) ./ 255., 'person05_handwaving_d3_uncomp_vid.avi', 25 );
% shearlet_save_matrix_to_video( BCS, 'person05_handwaving_d3_uncomp_c2.avi', 25 );

% fprintf('-- Time to create the change map from SH coeffs: %.4f seconds\n', toc(st));


% shearlet_plot_graylevel_local_maxima( VID(:,:,1:91), BC, 1, 5, false);  % buono boxing? centrato in 46
% shearlet_plot_graylevel_local_maxima( VID(:,:,1:91), BC, 2, 9, false);  % buono line_l? SCALA 2
shearlet_plot_graylevel_local_maxima( VID(:,:,1:91), BC, 0.5, 9, false);  % buono boxing? centrato in 46, SCALA 2
% shearlet_plot_graylevel_local_maxima( VID(:,:,1:91), BC, 0.1, 9, false);  % buono boxing? centrato in 46, SCALA 3
% shearlet_plot_graylevel_local_maxima( VID(:,:,49:139), BC, 0.5, 5, false); % buono video Sample_0001 gesture ok, centrato in 94


%%

close all;

% shearlet_plot_cluster_local_maxima( VID(:,:,1:91), cl_video_idx, BC, 1, -1, 5, true);
[POINTS_DESCRIPTORS, COORDINATES] = shearlet_extract_descriptor( VID(:,:,1:91), cl_video_idx, BC, 1, 5, 5, false);


%%

opts = statset('Display','final', 'MaxIter',200);
[CIDX, ~] = kmeans(POINTS_DESCRIPTORS, 4, 'Distance', 'sqeuclidean', 'Replicates',3, 'Options',opts);

shearlet_play_video_clustered_descriptors(VID(:,:,1:91), POINTS_DESCRIPTORS, COORDINATES, CIDX, 4);


%%

c = 1;

%
msg = '';

%
while true
    
    % 
    fprintf(repmat('\b',1, numel(msg)));
    msg = ['---- Processing frame ' int2str(c) '/' int2str(size(COEFFS,3)) ' '];
    fprintf(msg);
    
    %
    imshow(imresize(BC(:,:,c), 3, 'nearest'), [0 3]);
    
    pause(0.04);
    pause(0.00001);
    
    c = c + 1;
    
    %
    if(c == 92)
        c=1;
    end
    
end
