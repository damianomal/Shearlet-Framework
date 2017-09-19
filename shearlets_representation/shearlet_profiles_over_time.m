function [ profiles ] = shearlet_profiles_over_time( clusters_idx, t_start, t_end, clusters_to_show)
%SHEARLET_PROFILES_OVER_TIME Summary of this function goes here
%   Detailed explanation goes here

if(nargin < 4)
    clusters_to_show = 1:20;
end

if t_end>size(clusters_idx,3)
    t_end = size(clusters_idx,3);
end

mat5 = clusters_idx(:,:, t_start:t_end);

profiles = zeros(numel(clusters_to_show), t_end-t_start+1);

c=1;

for i=clusters_to_show
    profiles(c,:) = squeeze(sum(sum(mat5 == i,1),2));
    c = c+1;
end


end

