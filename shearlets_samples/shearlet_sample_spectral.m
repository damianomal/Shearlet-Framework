
%%

cl_sig1 = load('D:\Documents\Dottorato\Nicoletta\clusters_sigma_01_cut_08.txt');
cl_sig1 = reshape(cl_sig1, 160, [])';

cl_sig08 = load('D:\Documents\Dottorato\Nicoletta\clusters_sigma_008_cut_08.txt');
cl_sig08 = reshape(cl_sig08, 160, [])';

cl_sig08_09 = load('D:\Documents\Dottorato\Nicoletta\clusters_sigma_008_cut_09.txt');
cl_sig08_09 = reshape(cl_sig08_09, 160, [])';

cl_sig08_099 = load('D:\Documents\Dottorato\Nicoletta\clusters_sigma_008_cut_099.txt');
cl_sig08_099 = reshape(cl_sig08_099, 160, [])';

%%

figure; 

subplot(1,3,1); imshow(cl_sig1, []);
subplot(1,3,2); imshow(cl_sig08, []);
subplot(1,3,3); imshow(cl_sig08_09, []);

figure; imagesc(cl_sig08_099);

colormap(shearlet_init_cluster_map);

%%

figure; imagesc(cl_sig08_099(SORTED_CL_IMAGE ~= 1 & SORTED_CL_IMAGE ~= 2 & SORTED_CL_IMAGE ~= 3));

% colormap(shearlet_init_cluster_map);