
close all;

% load the video sequence (contained in the sample_sequences directory)

clear VID

% video_filename = 'line_l.mp4';
% VID = load_video_to_mat(video_filename,160,400,500);

video_filename = 'Sample0001_color.mp4';
VID = load_video_to_mat(video_filename,160,1190,1400);

%%

% calculate the 3D Shearlet Transform

clear COEFFS idxs 
[COEFFS,idxs] = shearlet_transform_3D(VID,94,91,[0 1 1], 3, 1);

%%

time_ind = 37;
scale_selected = 2;

% imm = VID(:,:,94-46+time_ind);
imm = VID(:,:,37);

C = corner(imm, 'Harris', 'SensitivityFactor', 0.23);
% C = corner(imm, 'MinimumEigenvalue');

f = figure(1);

imshow(imm, []);
hold on
plot(C(:,1), C(:,2), 'r*');

hold off;

r = getrect;

for i=1:size(C,1)
%    if(C(i,1) >=  r(1) && C(i,1) <=  r(1)+r(3) && C(i,2) >=  r(2) && C(i,2) <=  r(2)+r(4))
   if(~(C(i,1) >=  r(1) && C(i,1) <=  r(1)+r(3) && C(i,2) >=  r(2) && C(i,2) <=  r(2)+r(4)))
       C(i, :) = [-5 -5];
   end
end

clf;

imshow(imm, []);
hold on
plot(C(:,1), C(:,2), 'r*');
hold off;

CORNERS_DESCR = zeros(121,1);
count = 0;

for j=1:size(C,1)
       
    yy = C(j,1);
    xx = C(j,2);
    
    if(xx < 2 || yy < 2 || xx > size(imm,1)-1 || yy > size(imm,2)-1)
        continue;
    end

    temp = shearlet_descriptor_for_point( COEFFS, xx, yy, time_ind, scale_selected, idxs);
    CORNERS_DESCR  = CORNERS_DESCR + temp(1:121);
    count = count + 1;
    
end

CORNERS_DESCR = CORNERS_DESCR ./ count;

lines = [1 9 25 49 81];

figure(2);
bar(CORNERS_DESCR(1:121));

hold on;
for i=1:numel(lines)
    line([lines(i) lines(i)],get(gca,'ylim'),'Color',[1 0 0])
end
hold off;


shearlet_show_descriptor(CORNERS_DESCR);

