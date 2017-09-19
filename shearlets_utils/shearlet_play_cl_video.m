function shearlet_play_cl_video( cl_video, VID)
%SHEARLET_PLAY_CL_VIDEO Summary of this function goes here
%   Detailed explanation goes here

close all;

%
% cluster_map =  [0 0 1; 1 0 0; 0 1 0; ...
%     1 1 0; 0 0 0; 0 1 1; ...
%     1 0 1; 1 1 1; 0.5 0.5 0.5; ...
%     0.6 0.6 0; 1 0.4 0.4; 0.2 1 0.3; ...
%     0.9 0.8 0.1; 0.2 0.2 1; 0.8 0 0.5];

if(~exist('cluster_map'))
    cluster_map = shearlet_init_cluster_map;
end


vidOut = VideoWriter('person01_handclapping_d1_uncomp_cl_video_and_vid_cl8.avi');
vidOut.Quality = 100;
vidOut.FrameRate = 25;

open(vidOut);


%
res = shearlet_plot_clusters_over_time(cl_video, 1, 90, true);
figure('Name', 'Clusters Over Time', 'Position', [110 237 909 666]);
imshow(res);

%
figure('Name', 'Cluster Indexes Video', 'Position', [1038 339 652 455]);

i = 1;

%
while true
    
    %     imshow(ind2rgb(cl_video(:,:,i), cluster_map));
    subplot(1,2,1);
    imm = imresize(ind2rgb(cl_video(:,:,i), cluster_map),3,'nearest');
    imshow(imm);
    
    writeVideo(vidOut, imm);
    
    subplot(1,2,2);
    imshow(VID(:,:,i), []);
    
    pause(0.040);
    
    i = i + 1;
    
    if(i > size(cl_video, 3))
        i = 1;
        break;
    end
    
end

close (vidOut);


end

