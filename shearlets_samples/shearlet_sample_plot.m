

%% PLOT EVOLUZIONE PRESENZA CLUSTER IN OGNI FRAME

shearlet_plot_clusters_over_time(clusters_idx, 2, 99);

% shearlet_plot_clusters_over_time(cl_video_idx, 2, 99);
%% RIPRODUZIONE VIDEO E MASSIMI/MINIMI

% A = rand(100,100,100);
close all;

CURMAT = cl_video_max(:,:,2:99);
CURMAT(cl_video_idx(:,:,2:99) ~= 8) = 0;
CURMAT(CURMAT < 0.1) = 0;

Amin=minmaxfilt(CURMAT,5,'max','same'); % alternatively use imerode in image processing
[i, j, k]=ind2sub(size(CURMAT),find(Amin==CURMAT & CURMAT > 0)); % <- index of local minima
idxkeep=find(i>1 & i<100 & j>1 & j<100 & k>1 & k<100);

i=i(idxkeep);
j=j(idxkeep);
k=k(idxkeep);

fprintf('Found local maxima: %d.\n', size(i,1));

figure(1); imshow(CURMAT(:,:,10), []);

figure(2);

% for c=2:99

c=2;

while true
    
    id = find(k==c);
    
    figure(2);
    imshow(VID(:,:,c), []);
    
    hold on
    %     size(id)
    %     'a'
    if(size(id,1) > 0)
        plot(j(id), i(id), 'ro', 'MarkerSize', 20, 'LineWidth', 5);
    end
    
    hold off
    
    pause(0.04);
    
    c = c + 1;
    
    if(c == 100)
        c=2;
    end
end


%% VISUALIZZAZIONE MASSIMI E ISTOGRAMMA INDICI CLUSTER IN INTORNO SPAZIO-TEMPORALE

close all;
% clear

% load boxing_cl_video_and_vid;
% load walking_cl_video_and_vid;

% shearlet_plot_cluster_local_maxima(VID, cl_video_idx, cl_video_max, 0.3, 7, 5, true); % boxing original?
shearlet_plot_cluster_local_maxima(VID, cl_video_idx, cl_video_max, 0.3, 8, 7, true); % vidoe running person04
% shearlet_plot_cluster_local_maxima(VID, cl_video_idx, cl_video_max, 0.3, 8, 5, true);

%% RIPRODUZIONE VIDEO CON ELEMENTI DEL BACKGROUND

% play_video_mosaic('boxing_full_', [1 4 5]);
% play_video_mosaic('walking_full_', [1 2 3]);
shearlet_play_video_mosaic('handwaving_full_', [1 2 3]);

%% RIPRODUZIONE VIDEO CON ELEMENTI "DINAMICI"

% play_video_mosaic('boxing_full_', [2 3 6]);
% play_video_mosaic('walking_full_', [6 7 8]);
shearlet_play_video_mosaic('handwaving_full_', [6 7 8]);



