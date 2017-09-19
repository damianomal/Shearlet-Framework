function [img, flow] = shearlet_plot_clusters_over_time( clusters_idx, t_start, t_end, only_return_image, clusters_to_show, type, normalize)
%SHEARLET_PLOT_CLUSTERS_OVER_TIME Summary of this function goes here
%  Inputs:
%       cluster_idx:
%       .
%       .
%       .
%       type: can have value "all" or "non-zero".

% close all;

mm = shearlet_init_cluster_map;

figure, hold on
if(~exist('cluster_map') || isempty(cluster_map))
    cluster_map =  shearlet_init_cluster_map;
end

%
if(nargin < 5)
    clusters_to_show = 1:20;
    
    if(nargin < 4)
        only_return_image = false;
    end
end

if nargin < 6
    type = 'all';
end

if nargin< 7
    normalize = false;
end
%
BASELINE = 5;

%
if t_end>size(clusters_idx,3)
    t_end = size(clusters_idx,3);
end

mat5 = clusters_idx(:,:, t_start:t_end);

% fH = figure('Position', [680 277 951 701]);

hold all;

%
% START_VAL = 1;
% END_VAL = 8;

%
% h = zeros(1,END_VAL - START_VAL + 1);
h = zeros(1,numel(clusters_to_show));
% names = cell(1, END_VAL - START_VAL + 1);

%
h_index = 0;

%
% titles = {'background', 'background', 'background (higher)', 'far edges', ...
%     'corner(ish)', 'edges', 'dyn. edges', 'dyn. corners'};

% if(~only_return_image)
%     figure;
% end

%
% for i=START_VAL:END_VAL
legendInfo{1} = '';
for i=clusters_to_show
    
    h_index = h_index + 1;
    %
    d = squeeze(sum(sum(mat5 == i,1),2));
    flow(:,i) = d;
   if strcmp(type,'nonzero')
        if sum(d)<10
            continue
        end
   end
   if normalize && sum(d)>0      
        dd = ((d/ max(d))* 2)-1;
        d=dd;
        clear dd
        flow(:,i) = d;
    end
 
        
    %
    plot(1:numel(d), d, 'LineWidth', BASELINE+1, 'Color', [0 0 0]);
    h(h_index) = plot(1:numel(d), d, 'LineWidth', BASELINE, 'Color', cluster_map(i, :));
    
    legendInfo = [legendInfo ['Cluster ' num2str(i)]];
    %
    %     names{h_index} = titles{i};
    
end
% legendInfo = sqeeze(legendInfo);
legend(legendInfo{2:end});
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
    close all %(lgd);
end

end

