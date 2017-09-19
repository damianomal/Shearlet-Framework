

close all;
clear all;

% generate the structure
a = shearlets_synthetic_worm( 128, 20, 0.5);

% a = smooth3(a, 'box', 3);

% commented, not needed
% a = permute(a,[2 1 3]);

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
[COEFFS,idxs,start_ind] = shearlet_transform_3D_fullwindow(a,coords(3),128,[0 1 1], 3, 1);

%%

figure(fH);
clf;

% coords_show = [(129-80+16) 64 63];
% coords_show = [104 84 63];
coords_show = [104 64 40];

% NICE POINTS: to show how similar spatio-temporal behaviour
% is represented similarly in the 3D representation of the two points
% coords_show = [104 84 64];
% coords_show = [64 84 64];


TARGET_SCALE = 2;

% displays the structure

[faces,verts, C] = isosurface(a > 0, 0, a);
p = patch('Faces', faces, 'Vertices', verts);

% p = patch(isosurface(a > 0, 0, a));
% p.FaceColor = 'interp';
p.FaceColor = [0 0.85 0.55];
p.EdgeColor = 'none';

set(p, 'Faces', faces, 'Vertices', verts);

colormap([0 0.85 0.55])

% isosurface(a > 0);
axis([0 128 0 128 0 128]);
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

fprintf('Coord(3): %d, Changed coord: %d\n', coords_show(3), coords_show(3)-start_ind+1);

DESCR = shearlet_descriptor_for_point(COEFFS, coords_show(1), coords_show(2), coords_show(3)-start_ind+1, TARGET_SCALE, idxs);
shearlet_show_descriptor(DESCR);

set(gcf, 'Position', [934 208 961 763]);
view([-40.3 25.2]);


%% descrittore medio dei 4 punti indicati (trovati dal detector)

corners_coord =  [64   44  19;
    103  44  19;
    64   83  19;
    103  83  19];

corners_coord = [COORDINATES(1:3, :);
    COORDINATES(8:11,:)];

corners_descr = zeros(121,1);

for i=1:size(corners_coord,1)
    corners_descr = corners_descr + shearlet_descriptor_for_point(COEFFS, corners_coord(i,1), ...
        corners_coord(i,2), corners_coord(i,3)-start_ind+1, 2, idxs);
    
end

corners_descr = corners_descr ./ size(corners_coord,1);
shearlet_show_descriptor(corners_descr);

set(gcf, 'Position', [934 208 961 763]);
view([-40.3 25.2]);

figure(fH);
clf;

comparison_3d_visualization_from_points(a < 255, corners_coord, false);

axis([0 128 0 128 0 128]);
xlabel('y','FontSize',24,'FontWeight','bold');
ylabel('x','FontSize',24,'FontWeight','bold');
zlabel('time','FontSize',24,'FontWeight','bold');

view([az1 el1]);


%% descrittore medio di 4 punti sugli edge

% edges_coord = [65 84 40;
%                   104 84 40;
%                   104 45 40;
%                   65 45 40];

edges_coord = [65 84 40;
    104 84 40;
    104 45 40;
    65 45 40;
    54 84 87;
    93 84 87;
    93 45 87];

edges_descr = zeros(121,1);

for i=1:size(edges_coord,1)
    edges_descr = edges_descr + shearlet_descriptor_for_point(COEFFS, edges_coord(i,1), ...
        edges_coord(i,2), edges_coord(i,3)-start_ind+1, 2, idxs);
    
end

edges_descr = edges_descr ./ size(edges_coord,1);
shearlet_show_descriptor(edges_descr);

set(gcf, 'Position', [934 208 961 763]);
view([-40.3 25.2]);


figure(fH);
clf;

% p = patch(isosurface(a > 0, 0, a));
% p.FaceColor = 'interp';
% p.EdgeColor = 'none';
%
% axis([0 128 0 128 0 128]);
% xlabel('y','FontSize',24,'FontWeight','bold');
% ylabel('x','FontSize',24,'FontWeight','bold');
% zlabel('time','FontSize',24,'FontWeight','bold');
% grid on;
% set(gca,'xticklabel',[])
% set(gca,'yticklabel',[])
% set(gca,'zticklabel',[])
%
% % set size to take a screenshot
% set(fH, 'Position', [148 210 961 764]);
%
%
% % applies two lights
% % view([-132.3000 2.8]);
% % camlight
% %
% % view([101.1 21.2]);
% % camlight
%
% view([154.5000 10.8000]);
% camlight
% lighting phong
%
% % sets the main view of the structure
% % view([109.5 10.98]);
% view([az1 el1]);


comparison_3d_visualization_from_points(VIS_FG_MASKS, edges_coord, permuted);

axis([0 128 0 128 0 128]);
xlabel('y','FontSize',24,'FontWeight','bold');
ylabel('x','FontSize',24,'FontWeight','bold');
zlabel('time','FontSize',24,'FontWeight','bold');

view([az1 el1]);

hold on;
plot3( [84 84], [65 65], [23 60], 'LineWidth', 12, 'Color', [1 0.2 0.3]);
plot3( [84 84], [104 104], [23 60], 'LineWidth', 12, 'Color', [1 0.2 0.3]);
plot3( [45 45], [104 104], [23 60], 'LineWidth', 12, 'Color', [1 0.2 0.3]);
% plot3( [45 45], [65 65], [23 60], 'LineWidth', 8, 'Color', [1 0.2 0.3]);
plot3( [84 84], [63 46], [70 104], 'LineWidth', 12, 'Color', [1 0.2 0.3]);
plot3( [84 84], [102 85], [70 104], 'LineWidth', 12, 'Color', [1 0.2 0.3]);
plot3( [45 45], [102 85], [70 104], 'LineWidth', 12, 'Color', [1 0.2 0.3]);
hold off;




%% descrittore medio di 4 punti sugli edge (altro)

% edges_coord = [65 84 40;
%                   104 84 40;
%                   104 45 40;
%                   65 45 40];

edges_coord2 = [104 64 64];

edges_descr2 = zeros(121,1);

for i=1:size(edges_coord2,1)
    edges_descr2 = edges_descr + shearlet_descriptor_for_point(COEFFS, edges_coord2(i,1), ...
        edges_coord2(i,2), edges_coord2(i,3)-start_ind+1, 2, idxs);
    
end

% edges_descr = edges_descr ./ size(edges_coord,1);
shearlet_show_descriptor(edges_descr2);

set(gcf, 'Position', [934 208 961 763]);
view([-40.3 25.2]);


figure(fH);
clf;

% p = patch(isosurface(a > 0, 0, a));
% p.FaceColor = 'interp';
% p.EdgeColor = 'none';
%
% axis([0 128 0 128 0 128]);
% xlabel('y','FontSize',24,'FontWeight','bold');
% ylabel('x','FontSize',24,'FontWeight','bold');
% zlabel('time','FontSize',24,'FontWeight','bold');
% grid on;
% set(gca,'xticklabel',[])
% set(gca,'yticklabel',[])
% set(gca,'zticklabel',[])
%
% % set size to take a screenshot
% set(fH, 'Position', [148 210 961 764]);
%
%
% % applies two lights
% % view([-132.3000 2.8]);
% % camlight
% %
% % view([101.1 21.2]);
% % camlight
%
% view([154.5000 10.8000]);
% camlight
% lighting phong
%
% % sets the main view of the structure
% % view([109.5 10.98]);
% view([az1 el1]);


comparison_3d_visualization_from_points(VIS_FG_MASKS, edges_coord2, permuted);

axis([0 128 0 128 0 128]);
xlabel('y','FontSize',24,'FontWeight','bold');
ylabel('x','FontSize',24,'FontWeight','bold');
zlabel('time','FontSize',24,'FontWeight','bold');

view([az1 el1]);

hold on;
% plot3( [84 84], [65 65], [23 60], 'LineWidth', 12, 'Color', [1 0.2 0.3]);
% plot3( [84 84], [104 104], [23 60], 'LineWidth', 12, 'Color', [1 0.2 0.3]);
% plot3( [45 45], [104 104], [23 60], 'LineWidth', 12, 'Color', [1 0.2 0.3]);
% % plot3( [45 45], [65 65], [23 60], 'LineWidth', 8, 'Color', [1 0.2 0.3]);
% plot3( [84 84], [63 46], [70 104], 'LineWidth', 12, 'Color', [1 0.2 0.3]);
% plot3( [84 84], [102 85], [70 104], 'LineWidth', 12, 'Color', [1 0.2 0.3]);
% plot3( [45 45], [102 85], [70 104], 'LineWidth', 12, 'Color', [1 0.2 0.3]);
hold off;


%% descrittore medio di 4 punti sulla superficie

% edges_coord = [104 64 40;
%                   104 84 40;
%                   104 45 40;
%                   65 45 40];

surface_coords = [104 64 40;
    85 64 19;
    85 84 40;
    (129-80+47) 64 80;
    85 84 65;
    64 64 108;
    (129-90+34) 84 90];


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

comparison_3d_visualization_from_points(a < 255, surface_coords, false);

axis([0 128 0 128 0 128]);
xlabel('y','FontSize',24,'FontWeight','bold');
ylabel('x','FontSize',24,'FontWeight','bold');
zlabel('time','FontSize',24,'FontWeight','bold');

view([az1 el1]);





%%

clear COEFFS idxs
[COEFFS,idxs] = shearlet_transform_3D_fullwindow(a,46,127,[0 1 1], 3, 1);


%%

VID = a;

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
xlabel('y','FontSize',24,'FontWeight','bold');
ylabel('x','FontSize',24,'FontWeight','bold');
zlabel('time','FontSize',24,'FontWeight','bold');

view([az1 el1]);


%% classificazione dei punti su ogni faccia

figure(fH);
clf;

TARGET_SCALE = 3;

% displays the structure

[faces,verts, C] = isosurface(a > 0, 0, a);
p = patch('Faces', faces, 'Vertices', verts);

% p = patch(isosurface(a > 0, 0, a));
% p.FaceColor = 'interp';
% p.FaceColor = [0 0.85 0.55];
% p.EdgeColor = 'none';

% set(p, 'Faces', faces, 'Vertices', verts);


[nf,nv] = reducepatch(p, 1000);

colors = [0 0 1;
    1 1 1;
    1 1 1;
    1 1 1;
    1 0 0];

cla;

hold on;
for f=1:size(nf,1)
    
    mid_point = nv(nf(f,1),:) + nv(nf(f,2),:) + nv(nf(f,3),:);
    mid_point = round(mid_point ./ 3);
    
    DESCR = shearlet_descriptor_for_point(COEFFS, mid_point(2), mid_point(1), mid_point(3)-start_ind+1, TARGET_SCALE, idxs);
    
    tri=nv(nf(f,:),:);
    
    DESCR(DESCR < DESCR(1) * 0.5) = 0;
    
    vals = nnz(DESCR);
    if(vals > 5)
        vals = 5;
    end
    
    patch('XData',tri(:,1), ...
        'YData',tri(:,2), ...
        'ZData',tri(:,3), ...
        'FaceColor',colors(vals,:),'EdgeColor','none');
end
hold off;

rotate3d on;

% colormap([0 0.85 0.55])

% isosurface(a > 0);
axis([0 128 0 128 0 128]);
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

% hold on;
% plot3(coords_show(2), coords_show(1), coords_show(3), 'ro', 'MarkerSize', 5);
% plot3(coords_show(2), coords_show(1), coords_show(3), 'ro', 'MarkerSize', 20);
% hold off;

% fprintf('Coord(3): %d, Changed coord: %d\n', coords_show(3), coords_show(3)-start_ind+1);

% DESCR = shearlet_descriptor_for_point(COEFFS, coords_show(1), coords_show(2), coords_show(3)-start_ind+1, TARGET_SCALE, idxs);
% shearlet_show_descriptor(DESCR);



% set(gcf, 'Position', [934 208 961 763]);
% view([-40.3 25.2]);



%% classificazione dei punti su ogni faccia

figure(fH);
clf;

tic;
TARGET_SCALE = 3;

% displays the structure

% [faces,verts, C] = isosurface(a > 0, 0, a);
% p = patch('Faces', faces, 'Vertices', verts);

% p = patch(isosurface(a > 0, 0, a));
% p.FaceColor = 'interp';
% p.FaceColor = [0 0.85 0.55];
% p.EdgeColor = 'none';

% set(p, 'Faces', faces, 'Vertices', verts);


% [nf,nv] = reducepatch(p, 1000);

colors = [0 0 1;
    1 1 1;
    1 1 1;
    1 1 1;
    1 0 0];

cla;

% mmap = polarmap(121);
mmap = colormap(gray(121));

POINTS = zeros(50, 3);
COLORS = zeros(50, 3);

cur_ind = 0;

mmap = polarmap(121);

hold on;

for t=20
    % for t=70:78
    for y=2:1:size(COEFFS,2)-1
        for x = 2:1:size(COEFFS,1)-1
            %         for t=2:10:size(COEFFS,3)-1
            %         for t=20:108
            
            if(a(x,y,t) == 1)
                continue;
            end
            
            %     mid_point = nv(nf(f,1),:) + nv(nf(f,2),:) + nv(nf(f,3),:);
            %     mid_point = round(mid_point ./ 3);
            
            DESCR = shearlet_descriptor_for_point(COEFFS, x, y, t, TARGET_SCALE, idxs);
            %     DESCR(1)
            %
            if(DESCR(1) < 0.1)
                continue;
            end
            
            %     tri=nv(nf(f,:),:);
            %
            
            %             DESCR(DESCR < DESCR(1) * 0.6) = 0;
            
            sorted = sort(DESCR, 'descend');
            
            res_sorted = find(sorted <= (sorted(1) * 0.02));
            res_sorted = res_sorted(1);
            
            vals = nnz(DESCR);
            
            cur_ind = cur_ind + 1;
            
            POINTS(cur_ind, :) = [y x t];
            
            %             if(res_sorted > 7)
            %                 %                 plot3(y, x,t+start_ind-1, 'ro', 'MarkerSize', 4, 'LineWidth', 5);
            %                 COLORS(cur_ind, :) = [1 0 0];
            %             else if (res_sorted > 1)
            %                     %                     plot3(y, x,t+start_ind-1, 'wo', 'MarkerSize', 4, 'LineWidth', 5);
            %                     COLORS(cur_ind, :) = [1 1 1];
            %                 else
            %                     %                     plot3(y, x,t+start_ind-1, 'bo', 'MarkerSize', 4, 'LineWidth', 5);
            %                     COLORS(cur_ind, :) = [0 0 1];
            %                 end
            %             end
            
            COLORS(cur_ind, :) = mmap(res_sorted, :);
            
        end
    end
end

pcshow(POINTS, COLORS, 'MarkerSize', 100);

hold off;

rotate3d on;

% colormap([0 0.85 0.55])

% isosurface(a > 0);
axis([0 128 0 128 0 128]);
xlabel('y','FontSize',24,'FontWeight','bold');
ylabel('x','FontSize',24,'FontWeight','bold');
zlabel('time','FontSize',24,'FontWeight','bold');
grid on;
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
set(gca,'zticklabel',[])

% set size to take a screenshot
set(fH, 'Position', [148 210 961 764]);

view([154.5000 10.8000]);
camlight
lighting phong

% sets the main view of the structure
% view([109.5 10.98]);
view([az1 el1]);

toc;



%% clustering dei punti

class_ids = zeros(size(a));

TARGET_SCALE = 2;

tic;

fH = figure('Position', [148 554 560 420]);

figure(fH);
cla;

surface_descr_n = surface_descr ./ max(surface_descr(:));
edges_descr_n = edges_descr ./ max(edges_descr(:));
edges_descr2_n = edges_descr2 ./ max(edges_descr2(:));
corners_descr_n = corners_descr ./ max(corners_descr(:));

% DESCR_LONG = zeros(89*1600, 121);
DESCR_LONG = zeros(16772, 121);

index = 0;

for t=20:108
    
    fprintf('Processing t = %d\n', t);
    
    [II, JJ] = find(a(:,:,t) < 1);
    
    if(t ~= 20 && t ~= 108)
        
        %         [II, JJ] = find(a(:,:,t) < 1);
        
        ZZ = [II JJ];
        
        % size(ZZ)
        
        Zref = ZZ(ZZ(:,1) == max(ZZ(:,1)) | ZZ(:,1) == min (ZZ(:,1)) | ...
            ZZ(:,2) == max(ZZ(:,2)) | ZZ(:,2) == min (ZZ(:,2)),:);
        
        % size(Zref)
        
        % Zref(1,:)
        
        II = Zref(:,1);
        JJ = Zref(:,2);
        
    end
    
    for i=1:numel(II)
        
        
        % ----------------------
        
        DESCR = shearlet_descriptor_for_point(COEFFS, II(i), JJ(i), t, TARGET_SCALE, idxs);
        %
        %         % ----------------------
        %
        DESCR_n = DESCR ./ max(DESCR(:));
        
        %         res = [norm(DESCR - surface_descr) norm(DESCR - edges_descr) norm(DESCR - corners_descr)];
        res = [norm(DESCR_n - surface_descr_n) norm(DESCR_n - edges_descr_n) norm(DESCR_n - edges_descr2_n) norm(DESCR_n - corners_descr_n)];
        [~, ind] = min(res);
        class_ids( II(i), JJ(i), t ) = ind;
        
        % ---------------------
        
        %         index = index + 1;
        %         DESCR_LONG(index, :) = DESCR;
        
    end
    
end


toc;


%%
opts = statset('Display','final', 'MaxIter',200);

% if(~exist('cluster_map'))
cluster_map = shearlet_init_cluster_map;
% end

NUM_CLUSTER = 12;
DESCR_LONG_NORM = zeros(size(DESCR_LONG));

for i =1:size(DESCR_LONG,1)
    DESCR_LONG_NORM(i, :) = DESCR_LONG(i,:) ./ max(DESCR_LONG(i,:));
end


[cidx, ctrs] = kmeans(DESCR_LONG_NORM, NUM_CLUSTER, 'Distance', 'sqeuclidean', 'Replicates', 10, 'Options',opts);

clust_ids = zeros(size(a));


%%

index = 0;

tic;



% for t=20:108
%
%     [II, JJ] = find(a(:,:,t) < 1);
%
%     if(t ~= 20 && t ~= 108)
%
% %         [II, JJ] = find(a(:,:,t) < 1);
%
%         ZZ = [II JJ];
%
%         % size(ZZ)
%
%         Zref = ZZ(ZZ(:,1) == max(ZZ(:,1)) | ZZ(:,1) == min (ZZ(:,1)) | ...
%                   ZZ(:,2) == max(ZZ(:,2)) | ZZ(:,2) == min (ZZ(:,2)),:);
%
%         % size(Zref)
%
%         % Zref(1,:)
%
%         II = Zref(:,1);
%         JJ = Zref(:,2);
%
%     end
%
%
%     for i=1:numel(II)
%
% %         plot3(JJ(i), II(i),(t+start_ind-1)*ones(size(IIw)), 'Color', cluster_map(class_ids(II(i), JJ(i), t+start_ind-1),:), 'MarkerSize', 1, 'LineWidth', 2);
%
%         index = index + 1;
%         clust_ids(II(i), JJ(i), t+start_ind-1) = cidx(index);
%     end
%
% end

toc;

figure(fH);
clf;

% TARGET_SCALE = 2;

% displays the structure

if(false)
    [faces,verts, C] = isosurface(a > 0, 0, a);
    p = patch('Faces', faces, 'Vertices', verts);
    
    p.FaceColor = [0 0.85 0.55];
    p.EdgeColor = 'none';
    
    set(p, 'Faces', faces, 'Vertices', verts);
    
    colormap([0 0.85 0.55])
end

% isosurface(a > 0);
axis([0 128 0 128 0 128]);
xlabel('y','FontSize',24,'FontWeight','bold');
ylabel('x','FontSize',24,'FontWeight','bold');
zlabel('time','FontSize',24,'FontWeight','bold');
grid on;
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
set(gca,'zticklabel',[])

% set size to take a screenshot
set(fH, 'Position', [148 210 961 764]);

view([154.5000 10.8000]);
camlight
lighting phong

% sets the main view of the structure
view([az1 el1]);

% set(gcf, 'Position', [934 208 961 763]);
set(gcf, 'Position', [1343 509 521 416]);

view([az1 el1]);

hold on;

% colors = ['bo';
%     'go';
%     'ro';
%     'yo' ];

for t=20:108
    
    %     for c=1:NUM_CLUSTER
    %         [IIw, JJw] = find(clust_ids(:,:,t) == c);
    %         plot3(JJw, IIw,(t+start_ind-1)*ones(size(IIw)), 'Color', cluster_map(c,:), 'MarkerSize', 1, 'LineWidth', 2);
    %     end
    
    for c=1:4
        [IIw, JJw] = find(class_ids(:,:,t) == c);
        plot3(JJw, IIw,(t+start_ind-1)*ones(size(IIw)), 'Color', cluster_map(c,:), 'MarkerSize', 1, 'LineWidth', 2);
    end
    
end

hold off;


%%

figure(fH);
clf;

TARGET_SCALE = 2;

% displays the structure

[faces,verts, C] = isosurface(a > 0, 0, a);
p = patch('Faces', faces, 'Vertices', verts);

p.FaceColor = [0 0.85 0.55];
p.EdgeColor = 'none';

set(p, 'Faces', faces, 'Vertices', verts);

colormap([0 0.85 0.55])

% isosurface(a > 0);
axis([0 128 0 128 0 128]);
xlabel('y','FontSize',24,'FontWeight','bold');
ylabel('x','FontSize',24,'FontWeight','bold');
zlabel('time','FontSize',24,'FontWeight','bold');
grid on;
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
set(gca,'zticklabel',[])

% set size to take a screenshot
set(fH, 'Position', [148 210 961 764]);

view([154.5000 10.8000]);
camlight
lighting phong

% sets the main view of the structure
view([az1 el1]);

set(gcf, 'Position', [934 208 961 763]);
view([az1 el1]);


% hold on;
% 
% for t=20:108
%     
%     %         [II, JJ] = find(class_ids(:,:,t) == 1); % surfaces
%     [II, JJ] = find(class_ids(:,:,t) == 2 | class_ids(:,:,t) == 3); %edges
%     %     [II, JJ] = find(class_ids(:,:,t) == 4); % corners
%     plot3(JJ, II,(t+start_ind-1)*ones(size(II)), 'ro', 'MarkerSize', 2, 'LineWidth', 3);
%     
% end
% 
% hold off;

%%

hold on;

for t=20:108
    
    [II, JJ] = find(class_ids(:,:,t) == 1); % surfaces
    plot3(JJ, II,(t+start_ind-1)*ones(size(II)), 'bo', 'MarkerSize', 2, 'LineWidth', 3);
    
end

for t=20:108
    
    [II, JJ] = find(class_ids(:,:,t) == 2 | class_ids(:,:,t) == 3); %edges
    plot3(JJ, II,(t+start_ind-1)*ones(size(II)), 'ro', 'MarkerSize', 2, 'LineWidth', 3);
    
end


for t=20:108
    
    [II, JJ] = find(class_ids(:,:,t) == 4); % corners
    plot3(JJ, II,(t+start_ind-1)*ones(size(II)), 'go', 'MarkerSize', 2, 'LineWidth', 3);
    
end

hold off;



%%

new_coords = [COORDINATES(1:3, :);
    COORDINATES(8:11,:);
    104 64 40;
    85 64 19;
    85 84 40;
    (129-80+47) 64 80;
    85 84 65;
    64 64 108;
    (129-90+34) 84 90];



figure(fH);
clf;

% TARGET_SCALE = 2;

% displays the structure

if(true)
    [faces,verts, C] = isosurface(a > 0, 0, a);
    p = patch('Faces', faces, 'Vertices', verts);
    
    p.FaceColor = [0 0.85 0.55];
    p.EdgeColor = 'none';
    
    set(p, 'Faces', faces, 'Vertices', verts);
    
    colormap([0 0.85 0.55])
end

ratio = 1.5;

[x, y, z] = ellipsoid(0,0,0,ratio*3,ratio*3.25,ratio*3.25,30);
sphere_color = ones(31);
sphere_color2 = ones(31)*2;

size(x);
size(sphere_color);

hold on

for i=1:size(new_coords,1)
    
    if(i < 8)
        %     if(~permuted)
        surf(x+new_coords(i,2),y+new_coords(i,1),z+new_coords(i,3), ...
            sphere_color, ...
            'FaceColor',[0.34 1 0.34],...
            'EdgeColor','none',...
            'FaceLighting','gouraud');
    else
        surf(x+new_coords(i,2),y+new_coords(i,1),z+new_coords(i,3), ...
            sphere_color2, ...
            'FaceColor',[0 0.2 1],...
            'EdgeColor','none',...
            'FaceLighting','gouraud');
        
    end
    %     else
    %         surf(x+new_coords(i,2),y+new_coords(i,3),z+new_coords(i,1), ...
    %             sphere_color, ...
    %             'FaceColor','interp',...
    %             'EdgeColor','none',...
    %             'FaceLighting','gouraud');
    %
    %     end
end



colormap([0 0.85 0.55;0 0.2 1; 0.3 1 0.3])

% isosurface(a > 0);
axis([0 128 0 128 0 128]);
xlabel('y','FontSize',24,'FontWeight','bold');
ylabel('x','FontSize',24,'FontWeight','bold');
zlabel('time','FontSize',24,'FontWeight','bold');
grid on;
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
set(gca,'zticklabel',[])


% set size to take a screenshot
set(fH, 'Position', [148 210 961 764]);

view([154.5000 10.8000]);
camlight
lighting phong

% sets the main view of the structure
view([az1 el1]);

set(gcf, 'Position', [934 208 961 763]);
% set(gcf, 'Position', [1343 509 521 416]);

view([az1 el1]);

hold on;
plot3( [84 84], [65 65], [23 60], 'LineWidth', 12, 'Color', [1 0.2 0.3]);
plot3( [84 84], [104 104], [23 60], 'LineWidth', 12, 'Color', [1 0.2 0.3]);
plot3( [45 45], [104 104], [23 60], 'LineWidth', 12, 'Color', [1 0.2 0.3]);
% plot3( [45 45], [65 65], [23 60], 'LineWidth', 8, 'Color', [1 0.2 0.3]);
plot3( [84 84], [63 46], [70 104], 'LineWidth', 12, 'Color', [1 0.2 0.3]);
plot3( [84 84], [102 85], [70 104], 'LineWidth', 12, 'Color', [1 0.2 0.3]);
plot3( [45 45], [102 85], [70 104], 'LineWidth', 12, 'Color', [1 0.2 0.3]);
hold off;


