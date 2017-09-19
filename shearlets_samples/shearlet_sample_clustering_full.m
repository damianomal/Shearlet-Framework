% This file takes a set of .avi files, and using a pre-saved cluster, runs
% the clustering process on each of the videos. The output is saved in
% .mat files, separate for each input file.
filenames = {'robot_1-reaching_a', 'robot_2-transporting_a', 'robot_5-mixing_a', ...
             'robot_8-crank_a', 'canon_1-reaching_a', 'canon_2-transporting_a', ...
             'canon_5-mixing_a', 'canon_8-crank_a','eating_cam0','eating_cam1',...
             'eating_cam2','reaching_cam0','reaching_cam1','reaching_cam2'};

% TO save cropped original videos.
% for i = 1:numel(filenames)
%     shearlet_video_crop( [filenames{i} '.avi'], 160, 300, 391, alt_filenames{i});
% end

% To run the clustering process on all the defined videos
for k = 5      
    load(['G:\Shearlet-Framework\Shearlet_detection_clustering\saved_cluster' num2str(k) '.mat']);
    tic
    for i=9:numel(filenames)
        disp(i);
        
        VID = load_video_to_mat([filenames{i} '.avi'], 160, 1, 200);
        shearlet_video_clustering_full( VID, SORT_CTRS, [filenames{i} '_cluster' num2str(k)], true);
    end
    toc
    beep
    datestr(now)
end