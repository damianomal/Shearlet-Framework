function [ mask_matrix, centroids] = comparison_mask_from_kth_video( video, background, bg_threshold)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

foregroundDetector = vision.ForegroundDetector('NumGaussians', 3, ...
    'NumTrainingFrames', 1, 'LearningRate', 1);

mask_matrix = zeros(size(video));
centroids = zeros(size(video,3),2);

bg = background(:,:,1);

for i = 2:size(background,3)
    %     step(foregroundDetector, background(:,:,i));
    bg = bg .* 0.5 + background(:,:,i) .* 0.5;
end

blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', true, 'CentroidOutputPort', true, ...
    'MinimumBlobArea', 150 , 'MaximumBlobArea', 15000, ...
    'MajorAxisLengthOutputPort' , false, 'MaximumCount', 6);


se = strel('square', 3); % morphological filter for noise removal
se2 = strel('rectangle', [5 2]); % morphological filter for noise removal

for i=1:size(video,3)
    
    frame = video(:,:,i); % read the next video frame
    
    % Detect the foreground in the current video frame
    %     foreground = step(foregroundDetector, frame);
    bg = abs(double(frame) - double(bg)) < bg_threshold;
    
    % Use morphological opening to remove noise in the foreground
    %     filteredForeground = imopen(foreground, se);
    filteredForeground = imopen(bg, se);
    filteredForeground = imclose(filteredForeground, se2);
    
    [areas, centr, ~] = step(blobAnalysis, filteredForeground);
    
    [~, ind] = max(areas(:));
    CENTROID = centr(ind, :);
    
    %     size(centr(ind, :))
    %     size(CENTROID)
    
    
    
    %
    mask_matrix(:,:,i) = filteredForeground;
    
    imshow(filteredForeground);
    
    if(size(centr,1) > 0)
        
        centroids(i, :) = centr(ind, :);
        hold on;
        plot(CENTROID(1), CENTROID(2), 'ro');
        hold off;
        
    end
    
    
    pause(0.04);
end


end

