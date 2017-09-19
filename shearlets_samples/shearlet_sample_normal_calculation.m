
%%

% load the video sequence (contained in the sample_sequences directory)

clear VID

% video_filename = 'line_l.mp4';
% VID = load_video_to_mat(video_filename,160,400,500, true);

% video_filename = 'person04_boxing_d1_uncomp.avi';
% VID = load_video_to_mat(video_filename,160,1,100, true);

% video_filename = 'mixing_cam1.avi';
% VID = load_video_to_mat(video_filename,160,1,100, true);

% video_filename = 'TRUCK.mp4';
% VID = load_video_to_mat(video_filename,160,1300,1400, true);

video_filename = 'eating_cam0.avi';
VID = load_video_to_mat(video_filename,160,1,100, true);

% video_filename = 'Sample0001_color.mp4';
% VID = load_video_to_mat(video_filename,160,1238,1338, true);

% calculate the 3D Shearlet Transform

clear COEFFS idxs
[COEFFS,idxs] = shearlet_transform_3D(VID,46,91,[0 1 1], 3, 1, [2 3]);


%%

time_ind = 37;
scale = 2;
th = 0.1;

% scale = 3;
% th = 0.05;

% START_IND = 32;
% END_LIM = 57;

% truck
% START_IND = 60;
% END_LIM = 85;

% eating cam0
START_IND = 2;
END_LIM = 26;

%
% START_IND = 25;
% END_LIM = 50;

velocity_map = zeros(size(COEFFS,1), size(COEFFS,2), END_LIM-START_IND+1, 3);
color_map = zeros(size(COEFFS,1), size(COEFFS,2), END_LIM-START_IND+1, 3);
cone_map = zeros(size(COEFFS,1), size(COEFFS,2), END_LIM-START_IND+1);

count = zeros(1,3);

c = zeros(5,5,3);

mina = 300;
maxa = -1;

st = tic;

fprintf('Calculated time: %d sec.\n', 17*(END_LIM-START_IND+1));

% for t=[30 49]
for t=START_IND:END_LIM
    
    fprintf('Processing frame: %d..\n', t);
    
    for xx=2:size(COEFFS,1)-1
        
        % fprintf('Processing row: %d..\n', xx);
        
        for yy=2:size(COEFFS,2)-1
            
            [c(:,:,1), c(:,:,2), c(:,:,3)] = shearlet_calculate_grids(COEFFS, xx, yy, t, scale, idxs, 1);
            
            [mx, mi] = max(c(:));
            
            if(mx < th)
                continue;
            end
            
            cone = floor((mi-1)/25)+1;
            
            cone_map(xx,yy,t-START_IND+1) = cone;
            
            %             if(cone == 2)
            %                 continue;
            %             end
            
            [i, j] = find(c(:,:,cone) == mx);
            
            angle = shearlet_shearings_to_angle([i j], [5 5], 2, cone);
            
            velocity_map(xx,yy,t-START_IND+1, :) = angle;
            
%             
%             if(angle(3) == 0)
%                 continue;
%             end
            
            %             angle_not_t = angle;
            %             angle_not_t(3) = 0;
            %             N_minus_n = angle - angle_not_t;
            
            
            %             angle = velocity_map(xx,yy,t-START_IND+1, :);
            
            %             if(angle(3) == 0)
            %                 continue
            %             end
            
            %             h_value = atan2(angle(2), angle(1))+pi/4.0;
            
            %             cur_angle = atan2(angle(2), angle(1));
            %
            %             if(cur_angle < -(pi/4.0))
            %                 cur_angle = cur_angle + pi;
            %             end
            %
            %             h_value = cur_angle+(pi/4.0);
            %
            %             if(cur_angle < mina)
            %                 mina = cur_angle;
            %             end
            %
            %             if(cur_angle > maxa)
            %                 maxa = cur_angle;
            %             end
            
            
            %             if(angle(3) > 0)
            %                 h_value = h_value + pi;
            %             end
            
            %             if(h_value > pi)
            %                 h_value = pi;
            %             end
            %
            %             h_value = h_value / (2*pi);
            %
            %             if(h_value < 0 || h_value > 1)
            %                 %                 angle
            %                 %                 h_value
            %                 %                 fprintf('Inside IF, angle: %.4f, h_value: %.4f, cono: %d.\n', angle, h_value, 2);
            %                 fprintf('Inside IF, angle: [%.4f %.4f %.4f], h_value: %.4f.\n', angle(1), angle(2), angle(3), h_value);
            %                 count(cone) = count(cone) + 1;
            %                 %                 cone
            %                 h_value = 1;
            %             end
            %
            %             color_map(xx,yy,t-START_IND+1, :) = hsv2rgb([h_value  1 1]);
            
            
            
        end
        
    end
    
    %     count
    
end

fprintf('Time elapsed: %.4f sec.\n', toc(st));

for i=1:5
    beep
    pause(0.25);
end

%% draw current color wheel

shearlet_show_color_wheel(true);

%% run only to update the color_map object, in case it's needed

color_map = zeros(size(COEFFS,1), size(COEFFS,2), END_LIM-START_IND+1, 3);

% count = 0;
% mina = 300;
% maxa = -1;

for t=START_IND:END_LIM
    % for t=[30 49]
    
    fprintf('Processing frame: %d..\n', t);
    
    for xx=2:size(COEFFS,1)-1
        
        for yy=2:size(COEFFS,2)-1
            
            angle = velocity_map(xx,yy,t-START_IND+1, :);
            
            if(angle(3) == 0)
                continue
            end
            
            angle_not_t = angle;
            %             angle_not_t(3) = 0;
            %             N_minus_n = angle - angle_not_t;
            
            %             velocity_map(xx,yy,t-START_IND+1, :) = angle;
            
            angle = velocity_map(xx,yy,t-START_IND+1, :);
            cone = cone_map(xx,yy,t-START_IND+1);
            
            %             if(angle(3) == 0)
            %                 continue
            %             end
            
            %             h_value = atan2(angle(2), angle(1))+pi/4.0;
            
            cur_angle = atan2(angle(2), angle(1));
            
            %             if(cur_angle < -(pi/4.0))
            %                 cur_angle = cur_angle + pi;
            %             end
            %
            %             h_value = cur_angle+(pi/4.0);
            
            %             if(cone == 2)
            %                 cur_angle = cur_angle + pi;
            %                 if(cur_angle > 2*pi)
            %                     cur_angle = cur_angle - 2*pi;
            %                 end
            %             end
            
            if(cur_angle < 0)
                h_value = cur_angle + 2*pi;
            else
                h_value = cur_angle;
            end
            
            %             if(cone ~= 2)
            %                 h_value = h_value + pi;
            %             end
            
            %             if(cur_angle < mina)
            %                 mina = cur_angle;
            %             end
            %
            %             if(cur_angle > maxa)
            %                 maxa = cur_angle;
            %             end
            %
            %             if(h_value < mina)
            %                 mina = h_value;
            %             end
            %
            %             if(h_value > maxa)
            %                 maxa = h_value;
            %             end
            %
            
            %             if(angle(3) > 0)
            %                 h_value = h_value + pi;
            %             end
            
            %             if(h_value > pi*0.75)
            % %                 h_value = pi;
            %                 h_value = h_value - pi;
            %             end
            %
            h_value = h_value / (2*pi);
            
            if(h_value < 0 || h_value > 1)
                %                 angle
                %                 h_value
                %                 fprintf('Inside IF, angle: %.4f, h_value: %.4f, cono: %d.\n', angle, h_value, 2);
                fprintf('Inside IF, angle: [%.4f %.4f %.4f], h_value: %.4f.\n', angle(1), angle(2), angle(3), h_value);
                %                 count(cone) = count(cone) + 1;
                %                 cone
                h_value = 1;
            end
            
            color_map(xx,yy,t-START_IND+1, :) = hsv2rgb([h_value  1 1]);
            
        end
        
    end
    
end

%%

figure('Position', [568 220 1352 713]);

count = 1;

% frames_to_save = [66 71 79 80 81];
% frames_to_pause = [71 80];
% frames_to_save = [27 28 29 30 46 47 48 49 50];
frames_to_save = [3 8 10 15 21];
% frames_to_save = [];
frames_to_pause = [];
savename = 'boxing';


count = 1;

while true
    
    
    subplot(1,3,1);
    imshow(VID(:,:,START_IND-1+count), []);
    imshow(cat(3,VID(:,:,START_IND-1+count),VID(:,:,START_IND-1+count),VID(:,:,START_IND-1+count))./255);
    subplot(1,3,2);
    imshow(abs(velocity_map(:,:,count, 3)), []);
    colormap(hot);
    colorbar;
    subplot(1,3,3);
    imshow(squeeze(color_map(:,:,count, :)));
    
    title(['Frame ' int2str(START_IND-1+count)]);
    
    pause(0.04);
    
        if(ismember(START_IND-1+count, frames_to_save))
            imwrite(VID(:,:,START_IND-1+count)./255, ['frame_' savename '_' int2str(START_IND-1+count) '_2.png']);
            imwrite(squeeze(color_map(:,:,count, :)), ['frame_color_' savename '_' int2str(START_IND-1+count) '_2.png']);
        end
    
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
                break;
    end
    
end

%%

fname = 'person04_boxing_scale2_th006';

save([fname '_motion_data.mat'], 'VID', 'velocity_map', 'cone_map', 'color_map', 'START_IND', 'END_LIM');

%%

fname = 'mixing_cam1'; % interessante
% fname = 'truck_scale2';
% fname = 'truck_scale3_th001';
fname = 'truck_scale3_th005'; % interessante per come segmenta
% fname = 'line_l';
% fname = 'line_l_scale2_th_02'; % non male
fname = 'person04_boxing';
% fname = 'person04_boxing_scale3';
% fname = 'person04_boxing_scale2_th002';

load([fname '_motion_data.mat']);


START_IND = 32;
END_LIM = 57;

START_IND = 60;
END_LIM = 85;

% START_IND = 25;
% END_LIM = 50;


