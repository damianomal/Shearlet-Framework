function comparison_local_maxima_in_frame( VID, COLOR_VID, selected_frame, cl_video_max, min_threshold, window, upper_limit, visualization_cmap, save_filename)
%SHEARLET_PLOT_GRAYLEVEL_LOCAL_MAXIMA Summary of this function goes here
%   Detailed explanation goes here

%
[i, j, k] = shearlet_local_maxima_in_3D_matrix(cl_video_max, 0, window, size(VID));
[it, jt, kt] = shearlet_local_maxima_in_3D_matrix(cl_video_max, min_threshold, window, size(VID));

%
figure('Position', [48 335 1636 430]);
size(COLOR_VID)

%
id = find(k==selected_frame);
idt = find(kt==selected_frame);

%
subplot(1,4,1);
imshow(COLOR_VID(:,:,:,selected_frame)./255, []);

subplot(1,4,2);
fprintf('Frame: %d..\n', selected_frame);

if(nargin >= 7)
    
    ttemp = cl_video_max(:,:,selected_frame);
    ttemp(ttemp > upper_limit) = upper_limit;
    ttemp = gray2ind(ttemp, 256);
    ttemp = ind2rgb(ttemp, visualization_cmap);
    
    imshow(ttemp);
    
else
    imshow(cl_video_max(:,:,selected_frame), [0 upper_limit]);
end

%
if(size(id,1) > 0)
    
    %
    
    subplot(1,4,3);
    imshow(COLOR_VID(:,:,:,selected_frame)./255, []);
    
    hold on
    plot(j(id), i(id), 'ro', 'MarkerSize', 20, 'LineWidth', 5);
    hold off
    
    %
    
    subplot(1,4,4);
    imshow(COLOR_VID(:,:,:,selected_frame)./255, []);
    
    hold on
    plot(jt(idt), it(idt), 'ro', 'MarkerSize', 20, 'LineWidth', 5);
    hold off
    
    
end


end

