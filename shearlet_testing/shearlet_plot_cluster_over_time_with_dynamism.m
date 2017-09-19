function [flow] = shearlet_plot_cluster_over_time_with_dynamism( vid, res, clusters_idx, t_start, t_end, only_return_image)
%SHEARLET_PLOT_CLUSTERS_OVER_TIME Summary of this function goes here
%   Detailed explanation goes here


close all;

if(~exist('cluster_map') || isempty(cluster_map))
    cluster_map =  shearlet_init_cluster_map;
end
if(nargin < 6)
    only_return_image = false;
end
BASELINE = 2;

if t_end>size(vid,3)
    t_end = size(vid,3);
end

if t_end>size(res,4)+9
    t_end = size(res,4)+9;
end

count=0;
for i = 10:t_end
    count=count+1;
    diff(:,:,count) = res(:,:,1,count)==1 & res(:,:,2,count)==0;
    % Assign relevant cluster values to a new matrix.
end
mat5 = clusters_idx(:,:, 10:t_end).*diff;
hold all;%%%%%%%%%%% why??
%
START_VAL = 1;
END_VAL = 12;
%
h = zeros(1,END_VAL - START_VAL + 1);
% names = cell(1, END_VAL - START_VAL + 1);
%
h_index = 1;
%
% titles = {'background', 'background', 'background (higher)', 'far edges', ...
%     'corner(ish)', 'edges', 'dyn. edges', 'dyn. corners'};
%
% legend_label = {''};
for i=START_VAL:END_VAL
    %
    d = squeeze(sum(sum(mat5 == i,1),2));
    flow(:,i) = d;
    if sum(d)<10 % || (max(d) - min(d)<10)
        continue
    end
    %
    plot(1:numel(d), d, 'LineWidth', BASELINE+1, 'Color', [0 0 0]);
    h(h_index) = plot(1:numel(d), d, 'LineWidth', BASELINE, 'Color', cluster_map(i, :));
    %
    %     names{h_index} = titles{i};
    %
    h_index = h_index + 1;
%     legend_label{h_index} = ['Centroid ' num2str(i)];
end
% legend(legend_label,'Location', 'eastoutside');
% %
% lgd = legend(h, names);

%
lgd.FontSize = 14;
lgd.FontWeight = 'bold';
lgd.Color = [0.8 0.8 0.8];

%
hold off;

%
if(only_return_image)
    f = getframe(gca);
    img = f.cdata;
    close;
end

end

