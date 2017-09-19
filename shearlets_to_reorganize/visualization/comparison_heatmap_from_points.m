function [ blur_points_heatmap, res ] = comparison_heatmap_from_points( video, coordinates )
%COMPARISON_HEATMAP_FROM_POINTS XXX
%
% Usage:
%   [ blur_points_heatmap, res ] = comparison_points_over_time(video, coordinates)
%           Shows some visualizations of the spatio-temporal points found,
%           by displaying all the points on the same frame (and ignoring 
%           their temporal coordinates).
%
% Parameters:
%   video: the matrix representing the video sequence
%   coordinates: the 3D coordinates (x,y,t) of the points found
%
% Output:
%   blur_points_heatmap: XXX
%   res: XXX
%
%   See also ...
%
% 2016 Damiano Malafronte.


% 

figure;
img = zeros(size(video, 1), size(video, 2));

% 

for i=1:size(coordinates,1)
    if(coordinates(i,1) >= 1 && coordinates(i,1) <= size(video,1))
        img(coordinates(i,1),coordinates(i,2)) = img(coordinates(i,1),coordinates(i,2)) + 1;
    end
end

%
Iblur1 = imgaussfilt(img,1);

%
subplot(1,3,1);
imshow(img, []);
subplot(1,3,2);
imshow(Iblur1, []);
subplot(1,3,3);

%
blackimg = zeros(size(video, 1), size(video, 2));
imshow(blackimg, []);

%
hold on 
for i=1:size(coordinates,1)
plot(coordinates(i,2), coordinates(i,1), 'w.','MarkerFaceColor',[1 0 0], 'MarkerEdgeColor',[1 0 0], 'MarkerSize',34);
plot(coordinates(i,2), coordinates(i,1), 'w.', 'LineWidth',2,...
    'MarkerFaceColor',[1 1 1], 'MarkerSize',24);
end
hold off



%
figure;

res = cat(3, video(:,:,1), video(:,:,1), video(:,:,1)) ./ 255;

out_red = res(:,:,1);

Iblurnorm = Iblur1 ./ max(Iblur1(:));

% out_red(Iblur1 > 0.01) = Iblurnorm(Iblur1 > 0.01);
out_red(Iblur1 > 0.01) = 1;

res(:,:,1) = max(res(:,:,1), out_red);

imshow(res);
blur_points_heatmap = Iblur1;

end

