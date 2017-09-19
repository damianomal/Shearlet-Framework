% This file takes a set of video files as input, crops them (and saves them),
% extacts or loads a cluster set, and using it, clusters all the video
% files, and saves the output, then generates and saves graphs depicting
% flow of the clusters through each of the video sequence in the areas
% which have dynamic motion (dynamism.)

%% Part 1: Cropping initial videos
% Inputs.....   filenames_in: files to crop.
%               filenames_out: corresponding output filenames.
%               
%


% This file takes a set of .avi files, and using a pre-saved cluster, runs
% the clustering process on each of the videos. The output is saved in
% .mat files, separate for each input file.
% input_path = 'Dataset\video_files';
output_path = 'Dataset\video_files\';

% filenames_in = {'TABLE_TR_0','TABLE_TR_1','TABLE_TR_2','MIXING_TR_0',...
%     'MIXING_TR_1','MIXING_TR_2'};
% filenames_out = {'table_cam0','table_cam1','table_cam2','mixing_cam0',...
%     'mixing_cam1','mixing_cam2'};
filenames_in = {'EATING_TR_0','EATING_TR_1','EATING_TR_2','REACHING2_TR_0',...
    'REACHING2_TR_0','REACHING2_TR_0'};
filenames_out = {'eating2_cam0','eating2_cam1','eating2_cam2','reaching2_cam0',...
    'reaching2_cam1','reaching2_cam2'};

% TO save cropped original videos.
for i = 4:numel(filenames_in)
    shearlet_video_crop( [filenames_in{i} '.avi'], 160, 600, 691, filenames_out{i},output_path);
end
clear all

%% Part 2: Extract/Load Cluster set
% This section makes a new cluster set or loads a pre-saved cluster from
% system memory.

load('G:\Shearlet-Framework\Shearlet_detection_clustering\centroids_sets.mat')
SORT_CTRS = KTH_12_centroids_scale2;
cluster = 'KTH_12_scale2';
% cluster = 8;
% 
% path = 'Shearlet-Framework\Shearlet_detection_clustering\saved_cluster';
% if exist('cluster','var')==0
%     cluster = 9;
%     filename = 'robot_2-transporting_a_original_cropped.avi';
%     VID = load_video_to_mat(filename,160);
%     SCALE = 3;
%     CLUSTER_NUMBER = 10;
%     FRAME = 32;
%     [COEFFS,idxs] = shearlet_transform_3D(VID,46,91,[0 1 1], 3, 1);
%     [~, SORT_CTRS] = shearlet_cluster_single_frame(COEFFS,idxs,FRAME,SCALE,CLUSTER_NUMBER);
%     save([path cluster],'SORT_CTRS')
%     clear filename VID SCALE CLUSTER_NUMBERS FRAMES COEFFS idxs 
% else
%     load([path num2str(cluster)]);
%     clear path
% end

%% Database
filenames = {'robot_1-reaching_a', 'robot_2-transporting_a', 'robot_5-mixing_a', ...
             'robot_8-crank_a', 'canon_1-reaching_a', 'canon_2-transporting_a', ...
             'canon_5-mixing_a', 'canon_8-crank_a',... % first 8
             'eating2_cam0','eating2_cam1','eating2_cam2',... %11
             'reaching2_cam0','reaching2_cam1','reaching2_cam2',... %14
             'mixing_cam0','mixing_cam1','mixing_cam2',... %17
             'table_cam0','table_cam1','table_cam2'}; %20
actions = {'reaching','transporting','mixing','crank','reaching','transporting','mixing','crank',...
             'eating','eating','eating','reaching','reaching','reaching',...
             'mixing','mixing','mixing','table','table','table'};
cameras = {'robot','robot','robot','robot','canon','canon','canon','canon',...
             'cam0','cam1','cam2','cam0','cam1','cam2','cam0','cam1','cam2','cam0','cam1','cam2'};
         
files = 9:14; %files being used in this code.

%% Part 3: Clustering
% To run the clustering process on all the defined videos
% 
% for k = 8      % define the clusters IDs to be used.
%     load(['G:\Shearlet-Framework\Shearlet_detection_clustering\saved_cluster' num2str(k) '.mat']);
    tic
    for i=files(2) %:14 %numel(filenames) % files to be clustered
        disp(i);
        datestr(now)
        if exist(['Dataset\clustering_files\' cameras{i} '\' cluster],'dir')~=7
            mkdir(['Dataset\clustering_files\' cameras{i} '\' cluster])
        end
        VID = load_video_to_mat([filenames{i} '.avi'], 160, 1, 200);
        shearlet_video_clustering_full( VID, SORT_CTRS, [cameras{i} '\' cluster '\' filenames{i} '_' cluster], true);
        clear VID
    end
    toc
    beep
    datestr(now)
% end
clear i 

%     tic
%     for i=files %:14 %numel(filenames) % files to be clustered
%         disp(i);
%         if exist(['Dataset\clustering_files\' cameras{i} '\cluster' num2str(cluster)],'dir')~=7
%             mkdir(['Dataset\clustering_files\' cameras{i} '\cluster' num2str(cluster)])
%         end
%         VID = load_video_to_mat([filenames{i} '.avi'], 160, 1, 200);
%         shearlet_video_clustering_full( VID, SORT_CTRS, [cameras{i} '\cluster' num2str(cluster) '\' filenames{i} '_cluster' num2str(k)], true);
%         clear VID
%     end
%     toc
%     beep
%     datestr(now)
% % end
% clear i k

%% Part 4: Extracting dynamism data from videos         
%          
scale = 2;
end_frame = 90;
tic
for i=files(2:end) %1:numel(filenames) %define the files to be used.
    disp(i);
    filename = filenames{i};
    res = shearlet_dynamism_measure_save_for_testing([filename '.avi' ], scale , end_frame);
    save(['Dataset\Dynamism_data\Dynamism_' filenames{i}], 'filename', 'res');
    clear filename
%     load(['Dataset\Dynamism_data\Dynamism_' filenames{i}],'res');
    load([path1 'Clustering_files\' cameras{i} '\' cluster '\' filenames{i} '_' cluster '_cluster_and_vid.mat'])
    shearlet_plot_cluster_over_time_with_dynamism(VID, res, clusters_idx, 2, 99);
    title(['Evolution of Clusters over time in file ' actions{i} ' by camera ' cameras{i} ' using cluster ' cluster]);
    print([path1 'Graphs_with_dynamism\' cameras{i}  '\TimeEvolution_' actions{i} '_cluster_' cluster '_' cameras{i}], '-dpng');
    savefig([path1 'Graphs_with_dynamism\' cameras{i}  '\TimeEvolution_' actions{i} '_cluster_' cluster '_' cameras{i} '.fig']);
close all
end
toc
datestr(now)

%% Part 5: Saving the flow of each cluster
path1 = 'Dataset\';
for i = files(2)
    load(['Dataset\Dynamism_data\Dynamism_' filenames{i}],'res');
    load([path1 'Clustering_files\' cameras{i} '\' cluster '\' filenames{i} '_' cluster '_cluster_and_vid.mat'])
    shearlet_plot_cluster_over_time_with_dynamism(VID, res, clusters_idx, 2, 99);
    title(['Evolution of Clusters over time in file ' actions{i} ' by camera ' cameras{i} ' using cluster ' cluster]);
    print([path1 'Graphs_with_dynamism\' cameras{i}  '\TimeEvolution_' actions{i} '_cluster_' cluster '_' cameras{i}], '-dpng');
    savefig([path1 'Graphs_with_dynamism\' cameras{i}  '\TimeEvolution_' actions{i} '_cluster_' cluster '_' cameras{i} '.fig']);
close all
end
