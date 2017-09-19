

close all;
clear all;
% VIDW = load_video_to_mat('person01_walking_d1_uncomp.avi',160, 1,100); %parametri 1 e 7
% BG = VIDW(:,:,3);

load kth_bg_averaged.mat


BG = bg_averaged;

VID = load_video_to_mat('person04_boxing_d1_uncomp.avi',160, 1,200); % parametri 1.5 e 5
% VID = load_video_to_mat('person01_handclapping_d4_uncomp.avi',160, 1,200); % parametri 1.5 e 5
% VID = load_video_to_mat('person01_walking_d1_uncomp.avi',160, 1,100);
% VID = load_video_to_mat('person01_running_d1_uncomp.avi',160, 1,100);
% VID = load_video_to_mat('person01_walking_d1_uncomp.avi',160, 1,100); %parametri 1 e 7

LIMIT = size(VID,3);
LIMIT = 91;

VID(:,:,1) = BG;
VID(:,:,LIMIT) = BG;


VID2 = abs(VID - repmat(BG,1,1,size(VID, 3)));
VID2 = permute(VID2, [2 1 3]);

RES = zeros(size(VID2));

for t=1:size(VID,3)
    %     VID2(:,:,t) = imgaussfilt(VID2(:,:,t), 5);
    RES(:,:,t) = bwareafilt(VID2(:,:,t) > 50,1);
    %        RES(:,:,t) = imgaussfilt(RES(:,:,t), 1);
end

fH = figure('Position', [680 558 1035 420]);



% subplot(1,2,2);
hold on;
% camlight
p = patch(isosurface(RES(:,:,1:LIMIT), 0));
% p = patch(isosurface(RES, 0));
% p.FaceColor = 'cyan';
% p.FaceColor = [0.2 0.2 0.9];
p.FaceColor = [0 0.85 0.55];
p.EdgeColor = 'none';
camlight;

set(gca, 'xticklabels', []);
set(gca, 'yticklabels', []);
set(gca, 'zticklabels', []);
xlabel('y','FontSize',24,'FontWeight','bold');
ylabel('x','FontSize',24,'FontWeight','bold');
zlabel('time','FontSize',24,'FontWeight','bold');

view([58.40 54.00]);

% DEBUG solo per secondo screenshot (quello piu' dal basso)
% view([60.8000 43.6000]);

set(gcf, 'Position', [680 314 762 664]);

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
coords = [(129-80+47) 64 80];

% surface, side (SI3)
coords = [(129-90+34) 84 90];

% surface, side (EI2)
coords = [(129-80+8) 84 80];


% surface, side (SIDE, in t=65)
% coords = [85 84 65];

% surface, end (SI2)
% coords = [64 64 108]

%%

clear COEFFS idxs
[COEFFS,idxs,start_ind] = shearlet_transform_3D_fullwindow(VID,46,91,[0 1 1], 3, 1);

%%

figure(fH);
clf;

% punto anteriore gambe
coords_show = [97 76 54];

% secondo pugno
% coords_show = [72 20 66];

% secondo pugno
% coords_show = [70 20 13];
%
% % seconda ascella
% coords_show = [90 27 23];

% NICE POINTS: to show how similar spatio-temporal behaviour
% is represented similarly in the 3D representation of the two points
% coords_show = [104 84 64];
% coords_show = [64 84 64];


TARGET_SCALE = 2;

% displays the structure

a = RES(:,:,1:91);

p = patch(isosurface(a > 0, 0, a));
p.FaceColor = 'interp';
p.EdgeColor = 'none';

colormap([0 0.85 0.55])

% axis([0 128 0 128 0 92]);
axis([0 128 50 128 0 92]);
xlabel('y','FontSize',24,'FontWeight','bold');
ylabel('x','FontSize',24,'FontWeight','bold');
zlabel('time','FontSize',24,'FontWeight','bold');
grid on;
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
set(gca,'zticklabel',[])

% set size to take a screenshot
set(fH, 'Position', [148 210 961 764]);


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
view([az1 el1]);

hold on;
plot3(coords_show(2), coords_show(1), coords_show(3), 'ro', 'MarkerSize', 5);
plot3(coords_show(2), coords_show(1), coords_show(3), 'ro', 'MarkerSize', 20);
hold off;

view([-50.7000  -65.2000]);
camlight;

view([54.1000   57.2000]);

ratio = 1.9;

[x, y, z] = ellipsoid(0,0,0,ratio*3,ratio*1.7,ratio*3.25,30);
sphere_color = ones(31);

hold on

surf(x+coords_show(2),y+coords_show(1),z+coords_show(3), ...
    sphere_color, ...
    'FaceColor','interp',...
    'EdgeColor','none',...
    'FaceLighting','gouraud');



colormap([0 0.85 0.55;0 0.2 1])




fprintf('Coord(3): %d, Changed coord: %d\n', coords_show(3), coords_show(3)-start_ind+1);

DESCR = shearlet_descriptor_for_point(COEFFS, coords_show(1), coords_show(2), coords_show(3)-start_ind+1, TARGET_SCALE, idxs);
shearlet_show_descriptor(DESCR);

set(gcf, 'Position', [934 208 961 763]);
view([-40.3 25.2]);


%% descrittore medio dei 4 punti sugli edge

edges_coords = [91 91 55;
    91 91 35;
    91 91 25;
    91 91 75];


% edges_coord = [85 84 40; (129-80+47) 64 80];


edges_descr = zeros(121,1);

for i=1:size(edges_coords,1)
    edges_descr = edges_descr + shearlet_descriptor_for_point(COEFFS, edges_coords(i,1), ...
        edges_coords(i,2), edges_coords(i,3)-start_ind+1, 2, idxs);
end

edges_descr = edges_descr ./ size(edges_coords,1);
shearlet_show_descriptor(edges_descr);

set(gcf, 'Position', [934 208 961 763]);
view([-40.3 25.2]);

figure(fH);
clf;

% comparison_3d_visualization_from_points(a < 255, edges_coord, false);
%
% axis([0 128 0 128 0 128]);
% xlabel('y','FontSize',24,'FontWeight','bold');
% ylabel('x','FontSize',24,'FontWeight','bold');
% zlabel('time','FontSize',24,'FontWeight','bold');
%
% view([az1 el1]);


p = patch(isosurface(a > 0, 0, a));
p.FaceColor = 'interp';
p.EdgeColor = 'none';

colormap([0 0.85 0.55])

% axis([0 128 0 128 0 92]);
axis([0 128 50 128 0 92]);
xlabel('y','FontSize',24,'FontWeight','bold');
ylabel('x','FontSize',24,'FontWeight','bold');
zlabel('time','FontSize',24,'FontWeight','bold');
grid on;
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
set(gca,'zticklabel',[])

% set size to take a screenshot
set(fH, 'Position', [148 210 961 764]);


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
view([az1 el1]);

view([-50.7000  -65.2000]);
camlight;

view([54.1000   57.2000]);

ratio = 1.9;

[x, y, z] = ellipsoid(0,0,0,ratio*3,ratio*1.7,ratio*3.25,30);
sphere_color = ones(31);

hold on

% for i=1:size(surface_coords,1)
%     surf(x+surface_coords(i,2),y+surface_coords(i,1),z+surface_coords(i,3), ...
%         sphere_color, ...
%         'FaceColor','interp',...
%         'EdgeColor','none',...
%         'FaceLighting','gouraud');
% end


% colormap([0 0.85 0.55;0 0.2 1])

colormap([0 0.85 0.55])

hold on;
plot3( [92 92], [91 91], [1 91], 'LineWidth', 12, 'Color', [1 0.2 0.3]);
hold off;


%% descrittore medio di 4 punti sui corner

corner_coords = [74 21 15;
    72 21 40;
    74 21 64;
    75 21 85];


% edges_coord = [85 84 40; (129-80+47) 64 80];


corner_descr = zeros(121,1);

for i=1:size(corner_coords,1)
    corner_descr = corner_descr + shearlet_descriptor_for_point(COEFFS, corner_coords(i,1), ...
        corner_coords(i,2), corner_coords(i,3)-start_ind+1, 2, idxs);
end

corner_descr = corner_descr ./ size(corner_coords,1);
shearlet_show_descriptor(corner_descr);

set(gcf, 'Position', [934 208 961 763]);
view([-40.3 25.2]);

figure(fH);
clf;

% comparison_3d_visualization_from_points(a < 255, edges_coord, false);
%
% axis([0 128 0 128 0 128]);
% xlabel('y','FontSize',24,'FontWeight','bold');
% ylabel('x','FontSize',24,'FontWeight','bold');
% zlabel('time','FontSize',24,'FontWeight','bold');
%
% view([az1 el1]);


p = patch(isosurface(a > 0, 0, a));
p.FaceColor = 'interp';
p.EdgeColor = 'none';

colormap([0 0.85 0.55])

% axis([0 128 0 128 0 92]);
axis([0 128 50 128 0 92]);
xlabel('y','FontSize',24,'FontWeight','bold');
ylabel('x','FontSize',24,'FontWeight','bold');
zlabel('time','FontSize',24,'FontWeight','bold');
grid on;
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
set(gca,'zticklabel',[])

% set size to take a screenshot
set(fH, 'Position', [148 210 961 764]);


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
view([az1 el1]);

view([-50.7000  -65.2000]);
camlight;

view([54.1000   57.2000]);

ratio = 1.9;

[x, y, z] = ellipsoid(0,0,0,ratio*3,ratio*1.7,ratio*3.25,30);
sphere_color = ones(31);

hold on

for i=1:size(corner_coords,1)
    surf(x+corner_coords(i,2),y+corner_coords(i,1),z+corner_coords(i,3), ...
        sphere_color, ...
        'FaceColor','interp',...
        'EdgeColor','none',...
        'FaceLighting','gouraud');
end


colormap([0 0.85 0.55;0 0.2 1])

%% descrittore medio di 4 punti sulla superficie

surface_coords = [97 72 14;
    97 69 33;
    97 74 58;
    97 68 74];


% edges_coord = [85 84 40; (129-80+47) 64 80];


surface_descr = zeros(121,1);

for i=1:size(surface_coords,1)
    surface_descr = surface_descr + shearlet_descriptor_for_point(COEFFS, surface_coords(i,1), ...
        surface_coords(i,2), surface_coords(i,3)-start_ind+1, 2, idxs);
end

surface_descr = surface_descr ./ size(surface_coords,1);
shearlet_show_descriptor(surface_descr);

set(gcf, 'Position', [934 208 961 763]);
view([-40.3 25.2]);

figure(fH);
clf;

% comparison_3d_visualization_from_points(a < 255, edges_coord, false);
%
% axis([0 128 0 128 0 128]);
% xlabel('y','FontSize',24,'FontWeight','bold');
% ylabel('x','FontSize',24,'FontWeight','bold');
% zlabel('time','FontSize',24,'FontWeight','bold');
%
% view([az1 el1]);


p = patch(isosurface(a > 0, 0, a));
p.FaceColor = 'interp';
p.EdgeColor = 'none';

colormap([0 0.85 0.55])

% axis([0 128 0 128 0 92]);
axis([0 128 50 128 0 92]);
xlabel('y','FontSize',24,'FontWeight','bold');
ylabel('x','FontSize',24,'FontWeight','bold');
zlabel('time','FontSize',24,'FontWeight','bold');
grid on;
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
set(gca,'zticklabel',[])

% set size to take a screenshot
set(fH, 'Position', [148 210 961 764]);


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
view([az1 el1]);

view([-50.7000  -65.2000]);
camlight;

view([54.1000   57.2000]);

ratio = 1.9;

[x, y, z] = ellipsoid(0,0,0,ratio*3,ratio*1.7,ratio*3.25,30);
sphere_color = ones(31);

hold on

for i=1:size(surface_coords,1)
    surf(x+surface_coords(i,2),y+surface_coords(i,1),z+surface_coords(i,3), ...
        sphere_color, ...
        'FaceColor','interp',...
        'EdgeColor','none',...
        'FaceLighting','gouraud');
end


colormap([0 0.85 0.55;0 0.2 1])


%%

clear COEFFS idxs
[COEFFS,idxs] = shearlet_transform_3D_fullwindow(a,46,127,[0 1 1], 3, 1);


%%

% parameters for the detection process
LOWER_THRESHOLD = 0.2;
SPT_WINDOW = 13;
SCALES = [2];
CONE_WEIGHTS = [1 1 1];

% detect spatio-temporal interesting points within the sequence

close all;
%
% output_name = shearlet_create_video_outname( video_filename, SCALES, LOWER_THRESHOLD, SPT_WINDOW, CONE_WEIGHTS);

[COORDINATES, CHANGE_MAP] = shearlet_detect_points( VID(:,:,1:91), COEFFS, SCALES, [], LOWER_THRESHOLD, SPT_WINDOW, CONE_WEIGHTS, false);


%%

permuted = false;

VIS_FG_MASKS = RES(:,:,1:91);

% if(permuted)
%     VIS_FG_MASKS = permute(VIS_FG_MASKS,[3 2 1]);
% end
%
close all;

VIS_COORDS = COORDINATES;
VIS_COORDS(:,1) = VIS_COORDS(:,2);
VIS_COORDS(:,2) = COORDINATES(:,1);

comparison_3d_visualization_from_points(VIS_FG_MASKS, VIS_COORDS, permuted);

axis([0 128 50 128 0 92]);
xlabel('y','FontSize',24,'FontWeight','bold');
ylabel('x','FontSize',24,'FontWeight','bold');
zlabel('time','FontSize',24,'FontWeight','bold');

view([-39.1000  -70.0000]);
camlight;

view([az1 el1]);


%%

figure;

imshow(VID(:,:,37), []);

TARGET_SCALE = 2;
t = 37;

temp_matrix = zeros(size(VID,1), size(VID,2), 121);

tic;

for xx = 2:size(VID,1)-1
    for yy = 2:size(VID,2)-1
        
        DESCR = shearlet_descriptor_for_point(COEFFS, xx, yy, t, TARGET_SCALE, idxs);
        temp_matrix(xx,yy,:) = DESCR;
        
    end
end
toc;

%%

dist_matrix = zeros(size(VID,1), size(VID,2));

tic;

% surface_descr_n = surface_descr ./ max(surface_descr(:));
% edges_descr_n = edges_descr ./ max(edges_descr(:));
% corner_descr_n = corner_descr ./ max(corner_descr(:));


for xx = 2:size(VID,1)-1
    for yy = 2:size(VID,2)-1
        
        DESCR = squeeze(temp_matrix(xx,yy,:));
        
        %         DESCR = DESCR ./ max(DESCR(:));
        %         res = [norm(DESCR - surface_descr_n) norm(DESCR - edges_descr_n) norm(DESCR - corner_descr_n)];
        
        res = [norm(DESCR - surface_descr) norm(DESCR - edges_descr) norm(DESCR - corner_descr)];
        [~, ind] = min(res);
        
        dist_matrix(xx,yy) = ind;
        
    end
end

ii = VIS_FG_MASKS(:,:,t)';

dist_matrix(ii == 0) = 0;

toc;


figure;

for ind=1:3
    
    subplot(1,3,ind);
    red_overlay = dist_matrix == ind;
    green_overlay = dist_matrix == ind;
    blue_overlay = dist_matrix == ind;
    red = VID(:,:,t) ./ 255;
    green = VID(:,:,t) ./ 255;
    blue = VID(:,:,t) ./ 255;
    red(red_overlay) = 1;
    green(green_overlay) = 0;
    blue(blue_overlay) = 0;
    
    outimg = cat(3, red, green, blue);
    
    
    %     outimg = cat(3, VID(:,:,37)./255, VID(:,:,37)./255, VID(:,:,37)./255);
    %     %     outimg(dist_matrix == ind) = [1 0 0];
    %     outimg(red_overlay) = [1 0 0];
    
    
    imshow(outimg);
    
end
