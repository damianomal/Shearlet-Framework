
close all;

% load the video sequence (contained in the sample_sequences directory)

clear VID

% video_filename = 'line_l.mp4';
% VID = load_video_to_mat(video_filename,160,400,500);

% video_filename = 'Sample0001_color_160.avi';
% VID = load_video_to_mat(video_filename,160,1190,1400);

% video_filename = 'person04_boxing_d1_uncomp.avi';
% VID = load_video_to_mat(video_filename,160,1,100);

video_filename = 'person01_handwaving_d1_uncomp.avi';
VID = load_video_to_mat(video_filename,160,1,100);

%%

% calculate the 3D Shearlet Transform

clear COEFFS idxs 
[COEFFS,idxs] = shearlet_transform_3D(VID,46,91,[0 1 1], 3, 1);
% [COEFFS,idxs] = shearlet_transform_3D(VID,94,91,[0 1 1], 3, 1);

%%



time_ind = 60;
% time_ind = 46;
scale_selected = 2;

imm = VID(:,:,time_ind);
% imm = VID(:,:,time_ind+45);

points = shearlet_visualize_spatio_temporal_points(VID, 'person01_handwaving_d1_uncomp.txt', time_ind, 3);
% points = shearlet_visualize_spatio_temporal_points(VID, 'Sample0001_color.txt', 1190+45+time_ind, 130);
% points = shearlet_visualize_spatio_temporal_points(VID(:,:,94-45:94+45), 'Sample0001_color.txt', time_ind, 3, 1190+45);

figure;
imshow(imm, []);
hold on
plot(points(:,2), points(:,1), 'r*');
hold off;

if(size(points,1) > 0)

STIPS_DESCR = zeros(121,1);
count = 0;

for j=1:size(points,1)
       
    yy = points(j,2);
    xx = points(j,1);
%     tt = points(j,3);
    tt = time_ind;
    
    if(xx < 2 || yy < 2 || xx > size(imm,1)-1 || yy > size(imm,2)-1)
        continue;
    end

    temp = shearlet_descriptor_for_point( COEFFS, xx, yy, tt, scale_selected, idxs);
    STIPS_DESCR  = STIPS_DESCR + temp(1:121);
    count = count + 1;
    
end

STIPS_DESCR = STIPS_DESCR ./ count;

lines = [1 9 25 49 81];

figure(2);
bar(STIPS_DESCR(1:121));

hold on;
for i=1:numel(lines)
    line([lines(i) lines(i)],get(gca,'ylim'),'Color',[1 0 0])
end
hold off;


shearlet_show_descriptor(STIPS_DESCR);

else
    fprintf('---- No STIPs found for the selected frames!\n');
end
