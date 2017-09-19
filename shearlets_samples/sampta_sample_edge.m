

a = ones(128,128,127);

for i=1:64
    a(128-i:128, :,i) = 0;
end

a(:,:,65:127) = a(:,:,63:-1:1);


%%

az1 = 121.7000;
el1 = 10.8000;

%%
fH = figure('Position', [148 554 560 420]);

% applies two lights
view([-132.3000 2.8]);
camlight

view([101.1 21.2]);
camlight

%%

% surface, bottom (S1)
coords = [104 64 40];

% surface, front (S2)
coords = [85 64 19];
% 
% % surface, side (S3)
% coords = [85 84 40];
% 
% % still spatial corner (C1)
coords = [65 84 20];
% 
% % still spatial edge (E1)
% coords = [104 64 20];
% 
% % still spatial edge (E2)
% coords = [104 84 40];
% 
% % still spatial edge (E3)
% coords = [85 84 20];

% surface, bottom (SI1)
coords = [(129-90+40) 64 90];

% surface, side (SIDE, weird behaviour)
coords = [85 84 65];

%%

clear COEFFS idxs
[COEFFS,idxs,start_ind] = shearlet_transform_3D_fullwindow(a,coords(3),91,[0 1 1], 3, 1);

%%

figure(fH);
clf;

coords_show = [70 64 64];

% displays the structure

p = patch(isosurface(a > 0, 0, a));
p.FaceColor = 'interp';
p.EdgeColor = 'none';

colormap([0 0.85 0.55])

% isosurface(a > 0);
axis([0 128 0 128 0 128]);
xlabel('y');
ylabel('x');
zlabel('time');

% applies two lights
% view([-132.3000 2.8]);
% camlight
% 
% view([101.1 21.2]);
% camlight

view([154.5000 10.8000]);
camlight
lighting phong 

% sets the main view of the structure
% view([109.5 10.98]);
view([19.3000 31.6000]);
camlight


view([48.1000 -27.6000]);
camlight
camlight

hold on;
plot3(coords_show(2), coords_show(1), coords_show(3), 'ro', 'MarkerSize', 5);
plot3(coords_show(2), coords_show(1), coords_show(3), 'ro', 'MarkerSize', 20);
hold off;

DESCR = shearlet_descriptor_for_point( COEFFS, coords_show(1), coords_show(2), coords_show(3), 2, idxs );
shearlet_show_descriptor(DESCR);

%%

clear COEFFS idxs
[COEFFS,idxs] = shearlet_transform_3D_fullwindow(a,46,127,[0 1 1], 3, 1);


%%

% parameters for the detection process
LOWER_THRESHOLD = 0.3;
SPT_WINDOW = 17;
SCALES = [3];
CONE_WEIGHTS = [1 1 1];

% detect spatio-temporal interesting points within the sequence

close all;
% 
% output_name = shearlet_create_video_outname( video_filename, SCALES, LOWER_THRESHOLD, SPT_WINDOW, CONE_WEIGHTS);

[COORDINATES, CHANGE_MAP] = shearlet_detect_points( VID(:,:,1:127), COEFFS, SCALES, [], LOWER_THRESHOLD, SPT_WINDOW, CONE_WEIGHTS, false);


%% 

permuted = false;

VIS_FG_MASKS = VID < 255;

% if(permuted)
%     VIS_FG_MASKS = permute(VIS_FG_MASKS,[3 2 1]);
% end
% 
close all;

comparison_3d_visualization_from_points(VIS_FG_MASKS, COORDINATES, permuted);

axis([0 128 0 128 0 128]);
xlabel('y');
ylabel('x');
zlabel('time');

view([az1 el1]);
