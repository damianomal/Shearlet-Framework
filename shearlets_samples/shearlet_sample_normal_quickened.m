
clear VID

% video_filename = 'line_l.mp4';
% VID = load_video_to_mat(video_filename,160,400,500, true);

% video_filename = 'person04_boxing_d1_uncomp.avi';
% VID = load_video_to_mat(video_filename,160,1,100, true);

video_filename = 'mixing_cam1.avi';
VID = load_video_to_mat(video_filename,160,1,100, true);

% video_filename = 'TRUCK.mp4';
% VID = load_video_to_mat(video_filename,160,1300,1400, true);

% video_filename = 'eating_cam0.avi';
% VID = load_video_to_mat(video_filename,160,1,100, true);

% video_filename = 'Sample0001_color.mp4';
% VID = load_video_to_mat(video_filename,160,1238,1338, true);
% calculate the 3D Shearlet Transform

clear COEFFS idxs
[COEFFS,idxs] = shearlet_transform_3D(VID,46,91,[0 1 1], 3, 1, [2 3]);

%%
% 
% scale_chosen = 2;
% 
% dummy_matrix = zeros(size(COEFFS,1),size(COEFFS,2),size(COEFFS,4));
% 
% for i = 1:3
%     for j = 1:3
%         dummy_matrix(i,j,:) = 1:size(dummy_matrix, 3);
%     end
% end
% 
% 
% %%
% 
% 
% [c1, c2, c3] = shearlet_dummy_calculate_grids(dummy_matrix, 2, 2, 2, scale_chosen, idxs, 0);
% 
% 
% Z = zeros(5,5);
% 
% res_v = shearlet_create_indexes_matrix;
% 
% cc1 = c1';
% cc2 = c2';
% cc3 = c3';
% 
% real_indexes = [cc1(:); cc2(:); cc3(:)];
% 
% cc1 = flip(c1, 2)';
% cc2 = flip(c2, 2)';
% cc3 = flip(c3, 2)';
% 
% fake_indexes = [cc1(:); cc2(:); cc3(:)];
% 
% mask = zeros(15,15);
% 
% mask(6:10, 3:13) = 1;
% mask(3:13, 6:10) = 1;
% 
% %%
% 
% global MEGAMAP_ANGLES
% 
% MEGAMAP_ANGLES = zeros(75,3);
% 
% %%
% 
% for cone=1:3
%     for i=1:5
%         for j=1:5
%             index = (cone-1)*25+(i-1)*5+j;
%             MEGAMAP_ANGLES(index,:) = shearlet_shearings_to_angle([i j], [5 5], 2, cone);
%         end
%     end
% end
%

%%

global MEGAMAP_ANGLES

if(isempty(MEGAMAP_ANGLES))
    shearlet_initialize_megamap_angle(size(COEFFS), idxs);
end


%%
scale = 2;
th = 0.1;

st = tic;

% eating cam0
START_IND = 2;
END_LIM = 90;

shearlet_global_reset_coeffs_shift;

cone_map = zeros(size(COEFFS,1), size(COEFFS,2), END_LIM-START_IND+1);

velocity_map = zeros(size(COEFFS,1), size(COEFFS,2), END_LIM-START_IND+1, 3);

for t=START_IND:END_LIM
    
       velocity_map(:, :, t-START_IND+1, :) = shearlet_normal_fast(COEFFS, idxs, t, scale, th);
 
    
%     COEFFS_SHIFT = shearlet_average_shifted_coeffs(COEFFS, idxs, t, 1);
%     COEFFS_SHIFT = shearlet_global_coeff_shift(COEFFS, idxs, t, 1);
%     
%     for xx=2:size(COEFFS,1)-1
%         
%         for yy=2:size(COEFFS,2)-1
%             
%             [mx, ii] = max(abs(COEFFS_SHIFT(xx, yy, idxs(:,2) == scale)));
%             
%             if(mx < th)
%                 continue;
%             end
%             
%             
%             ii = find(fake_indexes == real_indexes(ii));
%             
%                   cone_map(xx,yy,t-START_IND+1) = floor((ii-1)/25)+1;
%       
%             velocity_map(xx,yy,t-START_IND+1, :) = MEGAMAP_ANGLES(ii,:);
%                                     
%             if(MEGAMAP_ANGLES(ii,3) == 0)
%                 continue;
%             end
%             
% 
%         end
%     end
    
end


fprintf('Time elapsed: %.4f sec.\n', toc(st));

for i=1:5
    beep
    pause(0.25);
end


%% run only to update the color_map object, in case it's needed

color_map = zeros(size(COEFFS,1), size(COEFFS,2), END_LIM-START_IND+1, 3);

for t=START_IND:END_LIM
    
%     fprintf('Processing frame: %d..\n', t);
    
    for xx=2:size(COEFFS,1)-1
        
        for yy=2:size(COEFFS,2)-1
            
            angle = velocity_map(xx,yy,t-START_IND+1, :);
            
            if(angle(3) == 0)
                continue
            end
            
            cone = cone_map(xx,yy,t-START_IND+1);
            
            cur_angle = atan2(angle(2), angle(1));
            
            if(cur_angle < 0)
                h_value = cur_angle + 2*pi;
            else
                h_value = cur_angle;
            end
            
            h_value = h_value / (2*pi);
            
            if(h_value < 0 || h_value > 1)
                fprintf('Inside IF, angle: [%.4f %.4f %.4f], h_value: %.4f.\n', angle(1), angle(2), angle(3), h_value);
                h_value = 1;
            end
            
            color_map(xx,yy,t-START_IND+1, :) = hsv2rgb([h_value  1 1]);
            
        end
        
    end
    
end

%%

figure('Position', [568 220 1352 713]);

% frames_to_save = [66 71 79 80 81];
% frames_to_pause = [71 80];
% frames_to_save = [27 28 29 30 46 47 48 49 50];
% frames_to_save = [3 8 10 15 21];
frames_to_save = [];
% frames_to_pause = [];
savename = 'eating_cam0';


count = 1;

while true
    
    count
    subplot(1,3,1);
    imshow(VID(:,:,START_IND-1+count), []);
    imshow(cat(3,VID(:,:,START_IND-1+count),VID(:,:,START_IND-1+count),VID(:,:,START_IND-1+count))./255);
    subplot(1,3,2);
    imshow(abs(velocity_map(:,:,count, 3)), [0 1]);
    colormap(hot);
    colorbar;
    subplot(1,3,3);
    imshow(squeeze(color_map(:,:,count, :)));
    
    title(['Frame ' int2str(START_IND-1+count)]);
    
    pause(0.01);
    
%         if(ismember(START_IND-1+count, frames_to_save))
%             imwrite(VID(:,:,START_IND-1+count)./255, ['frame_' savename '_' int2str(START_IND-1+count) '.png']);
%             imwrite(squeeze(color_map(:,:,count, :)), ['frame_color_' savename '_' int2str(START_IND-1+count) '.png']);
%         end
    
    %     if(ismember(START_IND-1+count, frames_to_pause))
    %         pause;
    %     end
    
    count = count + 1;
    
    %     if(count == 6)
    %         count = 25;
    %     else
    %         count = 6;
    %     end
    
    % skipping last frames
    %     if(count > size(velocity_map,3) - 4)
    if(count > size(velocity_map,3))
        count = 1;
        %         break;
    end
    
end
