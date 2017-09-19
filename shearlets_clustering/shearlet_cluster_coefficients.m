function [ res_clusters, ctrs ] = shearlet_cluster_coefficients( coeffs_mat, cluster_num, sizes)
%SHEARLET_CLUSTER_COEFFICIENTS Summary of this function goes here
%   Detailed explanation goes here

opts = statset('Display','final', 'MaxIter',200);

% pad = 5;
% coeffs_mat(1:pad*sizes(2), :) = repmat(coeffs_mat(1+pad*sizes(2), :), pad*sizes(2),1);
% coeffs_mat(end-pad*sizes(2)+1:end, :) = repmat(coeffs_mat(end-pad*sizes(2), :),pad*sizes(2) ,1);

[cidx, ctrs] = kmeans(coeffs_mat, cluster_num, 'Distance', 'sqeuclidean', 'Replicates',3, 'Options',opts);

res_clusters = reshape(cidx, sizes(2), sizes(1), 1);
res_clusters = res_clusters';

end

