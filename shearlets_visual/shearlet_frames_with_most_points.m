function [ counts_ind ] = shearlet_frames_with_most_points( video, counts, number_of_frames, coordinates)
%SHEARLET_FRAMES_WITH_MOST_POINTS Summary of this function goes here
%   Detailed explanation goes here

figure;

[~, counts_ind] = sort(counts,2, 'descend');

for i=1:number_of_frames
    subplot(1,number_of_frames,i);
    
    if(size(video,3) == 3)
        imshow(video(:,:,:,counts_ind(i))./255);
    else
        imshow(video(:,:,counts_ind(i)), []);
    end
    
    if(nargin == 4)
        
        id = find(coordinates(:, 3) == counts_ind(i));
        
        if(size(id,1) > 0)
            hold on;
            plot(coordinates(id,2), coordinates(id,1), 'ro', 'MarkerSize', 20, 'LineWidth', 5);
            hold off;
        end
    end
    
end

end

