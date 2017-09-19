function [ img ] = shearlet_plot_profiles_over_time(profiles, profiles_indexes, t_start, only_return_image, profiles_to_show)
 %SHEARLET_PLOT_CLUSTERS_OVER_TIME Summary of this function goes here
 %   Detailed explanation goes here
 
 if(~exist('cluster_map') || isempty(cluster_map))
     cluster_map =  shearlet_init_cluster_map;
 end
 
 %
 if(nargin < 5)
     profiles_to_show = profiles_indexes;
 end
 
 %
 BASELINE = 5;
 
 % fH = figure('Position', [680 277 951 701]);
 
 figure;
 
 hold all;
 
 h = zeros(1,numel(profiles_to_show));
 
 h_index = 1;
 
 for i=profiles_to_show
     
     %
 %     idx = find(profiles_indexes == i);
     d = profiles(profiles_indexes == i, :);
     
     %
     plot(1:numel(d), d, 'LineWidth', BASELINE+1, 'Color', [0 0 0]);
     h(h_index) = plot(1:numel(d), d, 'LineWidth', BASELINE, 'Color', cluster_map(i, :));
     
     %
     %     names{h_index} = titles{i};
     
     %
     h_index = h_index + 1;
 end
 
 %
 % lgd = legend(h, names);
 
 %
 lgd.FontSize = 14;
 lgd.FontWeight = 'bold';
 lgd.Color = [0.8 0.8 0.8];
 
 %
 hold off;
 
 f = getframe(gca);
 img = f.cdata;
 
 %
 if(only_return_image)
     close(fH);
 end
 
 end
 