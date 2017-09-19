function [ sort_cl_image, sort_centroids, sort_bar_diagram ] = shearlet_cluster_sort( cluster_idx, centroids )
%SHEARLET_CLUSTER_SORT Summary of this function goes here
%   Detailed explanation goes here

sort_bar_diagram = zeros(size(centroids,1),1);

%
for j=1:size(centroids,1)
    MASK = cluster_idx == j;
    sort_bar_diagram(j) = sum(MASK(:));
end

%
[SRT, IN] = sort(sort_bar_diagram, 1, 'descend');

if(~isempty(centroids))
    sort_centroids = centroids(IN, :);
else
    sort_centroids = [];
end

sort_bar_diagram = SRT;

%
sort_cl_image = zeros(size(cluster_idx));

%
for j=1:size(centroids,1)
    sort_cl_image(cluster_idx == IN(j)) = j;
end

end

