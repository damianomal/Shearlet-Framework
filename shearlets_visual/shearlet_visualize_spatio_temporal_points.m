function points = shearlet_visualize_spatio_temporal_points( video, stips_file, frame, t_win, offset )
%SHEARLET_VISUALIZE_SPATIO_TEMPORAL_POINTS Summary of this function goes here
%   Detailed explanation goes here

if(nargin < 5) 
    offset = 0;
end

points = dlmread(stips_file);
% [frame-t_win:frame+t_win]
% offset+[rframe-t_win:frame+t_win]
points = points(ismember(points(:,3), offset+[frame-t_win:frame+t_win]), :);

if(nargout < 1)
    
    figure;
    imshow(video(:,:,frame), []);
    
    hold on;
    plot(points(:,2), points(:,1), 'ro', 'MarkerSize', 20, 'LineWidth', 5);
    hold off;
    
    set(gcf, 'Position', [722 168 675 458]);
    
end

end

