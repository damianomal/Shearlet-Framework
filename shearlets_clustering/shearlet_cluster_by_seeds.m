function [ cl_image, cl_rgb ] = shearlet_cluster_by_seeds( representation, big_coeffs, seeds)
%SHEARLET_CLUSTER_BY_SEEDS Summary of this function goes here
%   Detailed explanation goes here

cluster_map =  [0 0 1; 1 0 0; 0 1 0; ...
    1 1 0; 0 0 0; 0 1 1; ...
    1 0 1; 1 1 1; 0.5 0.5 0.5; ...
    0.6 0.6 0; 1 0.4 0.4; 0.2 1 0.3; ...
    0.9 0.8 0.1; 0.2 0.2 1];

sz = size(big_coeffs);

%
distances = zeros(sz(1)*sz(2), size(seeds,1));

for j=1:size(seeds,1)
    distances(:, j) = sqrt( sum( (representation - repmat(seeds(j,:), sz(1)*sz(2), 1)).^2, 2));
end

[~, I] = min(distances, [], 2);

cl_image = reshape(I, sz(2), sz(1), 1)';

if(nargout > 1)
    cl_rgb = ind2rgb(reshape(I, sz(2), sz(1), 1)',cluster_map);
end

end

