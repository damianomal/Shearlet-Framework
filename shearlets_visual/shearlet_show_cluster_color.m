function shearlet_show_cluster_color( color_idx )
%SHEARLET_SHOW_CLUSTER_COLOR Summary of this function goes here
%   Detailed explanation goes here

mm = shearlet_init_cluster_map;

% mat255 = double(255*ones(1,1));

figure;

% img = cat(3, mm(color_idx, 1)*mat255, mm(color_idx, 2)*mat255, mm(color_idx, 3)*mat255);
% img = cat(3, mm(color_idx, 1), mm(color_idx, 2), mm(color_idx, 3));
img=reshape(mm(color_idx,:),1,1,3);
% img(1,1,1)


imshow(img, 'InitialMagnification', 50000);

end

