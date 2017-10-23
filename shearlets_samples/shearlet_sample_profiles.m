% load the video sequence (contained in the sample_sequences directory)

clear VID

% video_filename = 'line_l.mp4';
% VID = load_video_to_mat(video_filename,160,400,500, true);

% video_filename = 'mixing_cam1.avi';
% video_filename = 'mixing_cam0.avi';
% video_filename = 'mixing_cam2.avi';
% video_filename = 'potato_cam1.avi';
% video_filename = 'eggs_cam1.avi';
% video_filename = 'eggs_cam2.avi';
% video_filename = 'front_car.mp4';
% VID = load_video_to_mat(video_filename,160,1,100, true);
% VID = load_video_to_mat(video_filename,200,1,100, true);
% VID = load_video_to_mat('Sample0001_color.mp4',160,1239, 1350, true);

video_filename = 'TRUCK.mp4';
VID = load_video_to_mat(video_filename,160,1300,1400, true);

% --- KTH ---

% video_filename = '7-0006.mp4';
% video_filename = 'person01_walking_d1_uncomp.avi';
% video_filename = 'person04_running_d1_uncomp.avi';
% video_filename = 'person04_boxing_d1_uncomp.avi';
% % video_filename = 'person01_handwaving_d1_uncomp.avi';
% VID = load_video_to_mat(video_filename,160,1,100, true);

% --- PER FRANCESCA
% video_filename = 'mixing_cam1.avi';
% VID = load_video_to_mat(video_filename,160,1,100, true);
% -------------

% video_filename = 'carrot_cam2.avi';
% VID = load_video_to_mat(video_filename,160,1,100, true);

% [VID, COLOR_VID] = load_video_to_mat('walk-simple.avi',160, 1,100);
% VISUALIZING THE CLUSTERING RESULTS FOR A FIXED NUMBER OF CLUSTERS

clear COEFFS idxs
[COEFFS,idxs] = shearlet_transform_3D(VID,46,91,[0 1 1], 3, 1, [2 3]);

%% CLUSTERING OF A SINGLE FRAME USING THE SHEARLET-BASED REPRESENTATION DEVELOPED

% calculate the representation for a specific frame (frame number 37 of the
% sequence represented in the VID structure)

TARGET_FRAME = 73; % 72 per truck.mp4
SCALE_USED = 3;
SKIP_BORDER = 5;

REPRESENTATION = shearlet_descriptor_fast(COEFFS, TARGET_FRAME, SCALE_USED, idxs, true, true, SKIP_BORDER);

%%

% REPRESENTATION = shearlet_reduce_representation(REPRESENTATION);



CLUSTER_NUMBER = 8;
[CL_IND, CTRS] = shearlet_cluster_coefficients(REPRESENTATION, CLUSTER_NUMBER, [size(COEFFS,1) size(COEFFS,2)]);

% sorts the clusters with respect to their size, and also rea

[SORTED_CL_IMAGE, SORT_CTRS] = shearlet_cluster_sort(CL_IND, CTRS);

% shows a colormap associated with the clusters found
%


[~,~,img] = shearlet_cluster_image(SORTED_CL_IMAGE, CLUSTER_NUMBER, false, false);

close all;

figure;
subplot(1,2,1); imshow(VID(:,:,TARGET_FRAME), []);
subplot(1,2,2); imshow(img);

%%

st = tic;

scales = [3 3]; % [scale_for_representation scale_for_motion]
th = 0.05;
% th = 0.15;
% th = 0.01;

SKIP_BORDER = 5;

full_motion = zeros(size(COEFFS,1), size(COEFFS,2), size(COEFFS,3));
full_cluster_indexes = zeros(size(COEFFS,1), size(COEFFS,2), size(COEFFS,3));
color_maps = zeros(size(COEFFS,1), size(COEFFS,2), size(COEFFS,3), 3);

% dictionary
CENTROIDS = SORT_CTRS;
% CENTROIDS = SORT_CTRS_3;

for t=2:90
    %     for t=37
    [REPRESENTATION, angle_map, ~, motion_colored] = shearlet_combined_fast(COEFFS, t, scales, idxs, th, false, true, SKIP_BORDER);
%     REPRESENTATION = shearlet_reduce_representation(REPRESENTATION);
    CL_IND = shearlet_cluster_by_seeds(REPRESENTATION, COEFFS, CENTROIDS);
    full_cluster_indexes(:,:,t) = shearlet_cluster_image(CL_IND, size(CENTROIDS,1), false, false);
    full_motion(:,:,t) = angle_map(:,:,3);
    %         full_motion(:,:,t) = abs(atan(angle_map(:,:,3)));
    color_maps(:,:,t,:) = motion_colored;
end

fprintf('-- Time for Full Video Repr./Motion Extraction: %.4f seconds\n', toc(st));


%% PROFILES EXTRACTION

close all;

SELECTED_PROFILES = 1:8;

PROF = shearlet_profiles_over_time(full_cluster_indexes, 1, 90, SELECTED_PROFILES);
clusters_ot_image =  shearlet_plot_profiles_over_time(PROF(:,10:80), SELECTED_PROFILES, 1, false);
% PROF = shearlet_profiles_over_time(full_cluster_indexes, 1, 90, 6:8);
% clusters_ot_image =  shearlet_plot_profiles_over_time(PROF(:,10:80), 6:8, 1, false);

full_cluster_filtered = full_cluster_indexes;
full_cluster_filtered(full_motion == 0) = 0;

PROF_FILT = shearlet_profiles_over_time(full_cluster_filtered, 1, 90, SELECTED_PROFILES);
clusters_ot_image_filt =  shearlet_plot_profiles_over_time(PROF_FILT(:,10:80), SELECTED_PROFILES, 1, false);

% PROF_FILT = shearlet_profiles_over_time(full_cluster_filtered, 1, 90, 6:8);
% clusters_ot_image_filt =  shearlet_plot_profiles_over_time(PROF_FILT(:,10:80), 6:8, 1, false);

PROF_EDIT = PROF;

for i=1:size(PROF_EDIT,1)
    PROF_EDIT(i,:) = PROF_EDIT(i,:) - mean(PROF_EDIT(i,:));
end

% shearlet_plot_profiles_over_time(PROF_EDIT(6:8,10:80), 6:8, 1, false);

%% VISUALIZATION OVER TIME

count = 1;
START_IND = 2;
END_LIM = 90;

cluster_map = shearlet_init_cluster_map;

% cluster_map2 =  [0 0 1; 0 0 1; 0 0 1; ...
%                1 0 0; 1 0 0; 1 0 0; ...
%                0 1 0; 1 1 1; 0.5 0.5 0.5; ...
%                0.6 0.6 0; 1 0.4 0.4; 0.2 1 0.3; ...
%                0.9 0.8 0.1; 0.2 0.2 1; 0.2 0.3 0.2;
%                1 0.7 0.7; 0 1 0.6; 0.2 0 0.8;
%                0.4 0.1 0.7; 0.7 1 0.35];

cwheel = shearlet_show_color_wheel(true);

hand = figure('Position', [1 41 1920 963]);

record = true;

if(record)
    
    vidObjs = cell(1,4);
    prefix = 'highway';
    
    vidObjs{1} = VideoWriter([prefix '_video.avi']);
    vidObjs{1}.Quality = 100;
    vidObjs{1}.FrameRate = 25;
    
    open(vidObjs{1});
    
    vidObjs{2} = VideoWriter([prefix '_motion.avi']);
    vidObjs{2}.Quality = 100;
    vidObjs{2}.FrameRate = 25;
    
    open(vidObjs{2});
    
    vidObjs{3} = VideoWriter([prefix '_direction.avi']);
    vidObjs{3}.Quality = 100;
    vidObjs{3}.FrameRate = 25;
    
    open(vidObjs{3});
    
    vidObjs{4} = VideoWriter([prefix '_clusters.avi']);
    vidObjs{4}.Quality = 100;
    vidObjs{4}.FrameRate = 25;
    
    open(vidObjs{4});
end

while true
    
    %         count = 36;
    
    subplot(2,3,1);
    %     imshow(VID(:,:,START_IND-1+count), []);
    imshow(cat(3,VID(:,:,START_IND-1+count),VID(:,:,START_IND-1+count),VID(:,:,START_IND-1+count))./255);
    title('Current frame');
    
    subplot(2,3,2);
    imshow(abs(full_motion(:,:,START_IND-1+count)), [0 1]);
    %     cmot = ind2rgb(abs(full_motion(:,:,START_IND-1+count)), colormap(hot(256));
    
    colormap(hot);
    %         colorbar;
    title('Magnitude of motion');
    
    subplot(2,3,3);
    %     imshow(squeeze(color_maps(:,:,START_IND-1+count,:)));
    
    % ---------------
    cma = squeeze(color_maps(:,:,START_IND - 1 + count,:));
    CCC = full_motion(:,:,START_IND-1+count) == 0;
    CCC = cat(3, CCC,CCC,CCC);
    cma(CCC) = 255;
    %     CCC2 = full_motion(:,:,START_IND-1+count) ~= 0;
    %     MOT = 1-full_motion(:,:,START_IND-1+count);
    %     cma(CCC2) = min(cma(CCC2) + MOT(CCC2)*5, 255);
    imshow(cma);
    % ---------------
    
    title('Direction of motion');
    
    subplot(2,3,4);
    show_rgb = ind2rgb(full_cluster_indexes(:,:,START_IND-1+count), cluster_map);
    
    % -------------------
    show_rgb(1:5, 1:end, :) = 0;
    show_rgb(1:end, 1:5, :) = 0;
    show_rgb(end-4:end, 1:end, :) = 0;
    show_rgb(1:end, end-4:end, :) = 0;
    % -------------------
    
    imshow(show_rgb);
    
    title('Clusters color coded');
    
    subplot(2,3,5);
    count2 = count*(size(clusters_ot_image_filt,2)/(END_LIM-START_IND+1));
    
    imshow(clusters_ot_image_filt);
    hold on;
    line([count2 count2], [0 size(clusters_ot_image_filt,2)], 'linewidth',4, 'Color',[1 0 0]);
    hold off;
    
    title(['Frame ' int2str(START_IND-1+count)]);
    
    subplot(2,3,6);
    imshow(cwheel);
    
    pause(0.001);
    
    if(record)
        for i=1:4
            subplot(2,3,i);
            fg = getframe();
            writeVideo(vidObjs{i}, fg.cdata);
        end
    end
    
    %     waitforbuttonpress;
    
    
    %         if(ismember(START_IND-1+count, frames_to_save))
    %             imwrite(VID(:,:,START_IND-1+count)./255, ['frame_' savenacme '_' int2str(START_IND-1+count) '.png']);
    %             imwrite(squeeze(color_map(:,:,count, :)), ['frame_color_' savename '_' int2str(START_IND-1+count) '.png']);
    %         end
    
    %     if(ismember(START_IND-1+count, frames_to_pause))
    %         pause;
    %     end
    
    count = count + 1;
    
    % skipping last frames
    if(count > size(full_motion,3) || count > END_LIM)
%         count = 1;
                break;
    end
    
end

if(record)
    
    imwrite(clusters_ot_image_filt, [prefix '_graph.png'], 'png');
    
    close(vidObjs{1});
    close(vidObjs{2});
    close(vidObjs{3});
    close(vidObjs{4});
    
end

close(hand);

%% WINDOW-BASED PROFILES COMPARISON (commento rimosso)

st = 10;
en = 32;
% st = 9;  %% riferimento per eggs
% en = 19;
st = 13;  %% riferimento per walking_01
en = 28;

st = 8;  %% riferimento per walking_01
en = 28;

range = (en-st+1);

PROF_USED = PROF_FILT;

reference = PROF_USED(:,st:en);
% reference = saved_reference;

for j=1:size(reference,1)
    if(max(reference(j,:)) ~= 0)
        reference(j,:) = reference(j,:) / max(reference(j,:));
    end
end

result = zeros(1,size(PROF_USED,2));

% debug
result1 = zeros(1,size(PROF_USED,2));
result2 = zeros(1,size(PROF_USED,2));


for i=1:size(PROF_USED,2)-range
    
    %     err = (double(reference)-double(PROF_USED(:,i:i+range-1))).^2;
    
    temp_norm = PROF_USED(:,i:i+range-1);
    %     temp_norm = PROF_USED(:,i:i+10);
    
    for j=1:size(reference,1)
        if(max(temp_norm(j,:))~= 0)
            temp_norm(j,:) = temp_norm(j,:) ./ max(temp_norm(j,:));
        end
    end
    
    % primo metodo (con Nicoletta)
    
    err = (double(reference)-double(temp_norm)).^2;
    
    %     err = dtw(reference, temp_norm);
    %     result(i) = err;
    
    result(i) =  sqrt(sum(err(:)));
    result1(i) = result(i);
    
    %
    
    
    % --------------------
    
    % altro metodo (venerdi' mattina)
    
    %     mintot = 0;
    %     available = ones(size(reference,1),1);
    %
    %     for j=1:size(reference,1)
    %         minerr = 999999999;
    %         minind = -1;
    %
    %         for z = 1:size(temp_norm,1)
    %             if(available(z) == 0)
    %                 continue
    %             end
    %
    %             err = sum((double(reference(j,:))-double(temp_norm(z,:))).^2);
    %             if(err < minerr)
    %                 minerr = err;
    %                 minind = z;
    %             end
    %         end
    %
    %         available(minind) = 0;
    %
    %         mintot = mintot + minerr;
    %     end
    %
    % %     result(i) = sqrt(mintot);
    %     result2(i) = result(i);
    
    % --------------------
    
    
    %     result(i) = dtw(reference, PROF_USED(:,i:i+4));
    
end

result = result ./ max(result);
result(result == 0) = 1;

result = 1 - result;
result(size(PROF_USED,2)-range+1:end) = 0;

% debug
result1 = 1 - result1 ./ max(result1);
% result2 = 1 - result2 ./ max(result2);
result1(size(PROF_USED,2)-range+1:end) = 0;
% result2(size(PROF_USED,2)-range+1:end) = 0;


% [pks,locs] = findpeaks(result,'MinPeakDistance',10, 'MinPeakHeight',0.1);
[pks,locs] = findpeaks(result1,'MinPeakDistance',10);

meanCycle = mean(diff(locs))

figure('Position', [349 306 1472 573]);
subplot(1,3,1);
plot(result1)

hold on;
plot(numel(result),result,locs,pks,'o')
hold off;

% subplot(1,3,2);
% plot(result2)


% subplot(1,3,3);
% plot(result1.*result2);

% [pks2,locs2] = findpeaks(result1.*result2,'MinPeakDistance',10, 'MinPeakHeight',0.01);

% hold on;
% plot(numel(result2),result2,locs2,pks2,'o')
% hold off;


%%

figure;

c = 1;

while true
    
    imshow(VID(:,:,c), [],'InitialMagnification', 1000);
    
    if(ismember(c,locs))
        waitforbuttonpress;
    end
    
    
    pause(0.1);
    
    c = c + 1;
    
    if(c > size(VID,3))
        break;
    end
    
end


%%


findpeaks(result1,numel(result1),'Annotate','extents','WidthReference','halfheight','MinPeakDistance',0.2)
title('Signal Peak Widths')



