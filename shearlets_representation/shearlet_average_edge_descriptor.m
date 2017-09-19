function shearlet_average_edge_descriptor( image, big_coeffs, idxs, time_ind, scale)
% Summary of this function goes here
%   Detailed explanation goes here

%
edge_mask = edge(image, 'canny', 0.9);

%
avg_desr = shearlet_average_descriptor( big_coeffs, edge_mask, idxs, time_ind, scale, 1);

figure('Position', [161 555 546 417]);
imshow(edge_mask, []);

%
shearlet_show_descriptor(avg_desr);

end

