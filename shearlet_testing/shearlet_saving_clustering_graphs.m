% This script file takes the .mat files that has information regarding the
% evolution of the clusters with time, and saves the resultant graphs into
% .png and .fig formats.
%
%
% Author: Gaurvi Goyal

path1 = 'G:\Dataset\';
for videonum = [1 2 5 8]
    
    switch videonum
        case 1
            filename = '1-reaching';
        case 2
            filename = '2-transporting';
        case 5
            filename = '5-mixing';
        case 8
            filename = '8-crank';
    end
    for camera = 1:2
        for j = 1:8
            if camera == 1
                filename2 = ['robot_' filename];
            else %camera == 2
                filename2 = ['canon_' filename];
            end
            load([path1 'Clustering_files\' filename2(1:5) '\cluster' num2str(j) '\' filename2 '_a_cluster' num2str(j) '_cluster_and_vid.mat']);
            load([path1 'Dynamism_data\Dynamism_' filename2 '_a'], 'res');
            figure(1)
%             shearlet_plot_cluster_over_time(clusters_idx, 2, 99);
%             shearlet_plot_cluster_over_time_with_change(VID, clusters_idx, 2, 99);
            shearlet_plot_cluster_over_time_with_dynamism(VID, res, clusters_idx, 2, 99);
            title(['Evolution of Clusters over time in file ' filename2 ' using cluster ' num2str(j)]);
            print([path1 'Graphs_with_dynamism\' filename2(1:5) '\TimeEvolution_' filename '_cluster_' num2str(j)], '-dpng');
            savefig([path1 'Graphs_with_dynamism\' filename2(1:5) '\TimeEvolution_' filename '_cluster_' num2str(j) '.fig']);
            close all
        end
    end
end
%%
for videonum = 1:2
    
    switch videonum
        case 1
            filename = 'eating';
        case 2
            filename = 'reaching';
    end
    for camera = 0:2
        for j = 5
            load([path1 'Clustering_files\cam' num2str(camera) '\cluster' num2str(j) '\' filename '_cam' num2str(camera) '_cluster' num2str(j) '_cluster_and_vid.mat'])
            load([path1 'Dynamism_data\Dynamism_' filename '_cam' num2str(camera)], 'res');
            figure(1)
%             shearlet_plot_clusters_over_time(clusters_idx, 2, 99);
%             shearlet_plot_cluster_over_time_with_change(VID, clusters_idx, 2, 99);
            shearlet_plot_cluster_over_time_with_dynamism(VID, res, clusters_idx, 2, 99);
            title(['Evolution of Clusters over time in file ' filename ' by camera ' num2str(camera) ' using cluster ' num2str(j)]);
            print([path1 'Graphs_with_dynamism\cam' num2str(camera)  '\TimeEvolution_' filename '_cluster_' num2str(j) '_cam' num2str(camera)], '-dpng');
            savefig([path1 'Graphs_with_dynamism\cam' num2str(camera)  '\TimeEvolution_' filename '_cluster_' num2str(j) '_cam' num2str(camera) '.fig']);

            
%             shearlet_plot_cluster_over_time_with_change(VID, clusters_idx, 2, 99);
%             print([path1 'Graphs_with_change\cam' num2str(camera)  '\TimeEvolution_' filename '_cluster_' num2str(j)], '-dpng');
%             savefig([path1 'Graphs_with_change\cam' num2str(camera)  '\TimeEvolution_' filename '_cluster_' num2str(j) '.fig']);
            close all
        end
    end
end



