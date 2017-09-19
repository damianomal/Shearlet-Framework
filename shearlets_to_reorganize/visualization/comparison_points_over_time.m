function [counts] = comparison_points_over_time( video, coordinates, show)
%COMPARISON_POINTS_OVER_TIME Shows a bar diagram representing the
%distribution of spatio-temporal points found over time
%
% Usage:
%   counts = comparison_points_over_time(video, coordinates)
%           Shows a bar diagram representing the distribution of
%           spatio-temporal points (contained in the 'coordinates' object)
%           found over time
%
% Parameters:
%   video: the matrix representing the video sequence
%   coordinates: the 3D coordinates (x,y,t) of the points found
%
% Output:
%   counts: XXX
%
%   See also ...
%
% 2016 Damiano Malafronte.

if(nargin < 3)
    show = true;
end

counts = zeros(1,size(video,3));

% for every point found, adds 1 to the correponding
% bin in the bar diagram
for i=1:size(coordinates,1)
    counts(coordinates(i,3)) = counts(coordinates(i,3)) + 1;
end

if(show)
    % shows the bar diagram
    figure;
    bar(counts);
    
    xlabel('frame')
    ylabel('points found')
    xlim([0 91]);
end

end

