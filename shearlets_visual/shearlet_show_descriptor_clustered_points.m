function [ output_args ] = shearlet_show_descriptor_clustered_points( descriptors, cidx, num_clusters)
%SHEARLET_SHOW_DESCRIPTOR_CLUSTERED_POINTS Summary of this function goes here
%   Detailed explanation goes here

figure('Position', [581 517 1327 472]);

for i=1:num_clusters
    
   subplot(1,num_clusters,i);
   imshow(imresize(descriptors(cidx == i, :), 4, 'Method', 'nearest'), []);
   
end

end

