function [coordinates] = shearlet_plot_graylevel_local_maxima( video, change_map, min_threshold, window, pause_between_frames, upper_limit, visualization_cmap, save_filename)
%SHEARLET_PLOT_GRAYLEVEL_LOCAL_MAXIMA Detects a set of spatio-temporal interest points in
%the sequence passed as a parameter (more precisely, using the
%corresponding shearlet coefficients, previously calculated)
%
% Usage:
%   [coordinates, change_map] = shearlet_detect_points(video, coeffs, [2 3], [], 0.1, 9, false)
%           Detects points in the 'video' matrix passed by considering the
%           values inside the 'coeffs' object, only keeping into account of
%           the values corresponding to the second and third scales.
%           Values below 0.1 will not be considered for the non-maxima
%           supression process, as they will be set to zero, and the local
%           window within which a value has to be the maximum to be
%           considered as a detected point is a cube of side 2*9+1 pixels.
%
% Parameters:
%   video: the matrix representing the video sequence
%   change_map: the change map representing the interest measure to use 
%               to extract spatio-temporal points
%   min_threshold: the minumum value for a candidate point
%   window: the neighborhood to consider while searching for local maxima
%   pause_between_frames: whether to pause or not during
%   upper_limit: XXX
%   visualization_cmap: the colormap to use to visualize the change_map
%   save_filename: XXX
%
% Output:
%   coordinates: a matrix containing a set of triples (x,y,t) representing
%                the coordinates of the spatio-temporal interest points
%                that have been found by the process.
%
%   See also ...
%
% 2016 Damiano Malafronte.

%
if(nargin == 8)
    vidOut = VideoWriter(save_filename);
    vidOut.Quality = 100;
    vidOut.FrameRate = 25;
    open(vidOut);
    outimg = 255*ones(size(video(:,:,1),1),20+size(video(:,:,1),2)*2,3);
end

%
if(nargin < 7)
    visualization_cmap = colormap(jet(256));
    if(nargin < 6)
        upper_limit = 3;
        if(nargin < 5)
            pause_between_frames = false;
            if(nargin < 4)
                window = 3;
            end
        end
    end
end

% parameters controls
if(window < 1)
    ME = MException('shearlet_plot_graylevel_local_maxima:invalid_window_size', ...
        'You have to specify a window size greater than 1.');
    throw(ME);
end

if(min_threshold < 0)
    warning('shearlet_plot_graylevel_local_maxima:negative_min_threshold', ...
        'A negative threshold is meaningless, value set to 0.');
    min_threshold = 0;
end

% if the user specified it, pauses between each frame and
% shows a slice corresponding to the current spatio-temporal point
if(pause_between_frames)
    num_plots = 3;
else
    num_plots = 2;
end

% extract points which are local maxima within a spatio-temporal
% cube of size (2*window)+1, which value is higher than min_threshold
[i, j, k] = shearlet_local_maxima_in_3D_matrix(change_map, min_threshold, window, size(video));
% [i, j, k] = shearlet_local_maxima_in_3D_matrix(cl_video_max, 0, window, size(VID));

% saves the coordinates in the output object
coordinates = [i j k];

fprintf('-- Found local maxima: %d.\n', size(i,1));

% index used in the while loop to cycle over all the
% frames of the sequence considered
c=2;

% change to 5
repeated_frames = 1;

% figure('Position', [-1320 184 1266 594]);
figure;

% cycle over the whole sequence
while true
    
    % selects the points found in the current frame
    id = find(k==c);
    
    % showing the current frame in the sequence
    subplot(1,num_plots,1);
    imshow(video(:,:,c), []);
    
    subplot(1,num_plots, 2);
    
    % if the user specifies a colormap, uses it to visualize the 
    % change map, otherwise shows the map in grayscale
    if(nargin >= 7)
        
        ttemp = change_map(:,:,c);
        ttemp(ttemp > upper_limit) = upper_limit;
        ttemp = gray2ind(ttemp, 256);
        ttemp = ind2rgb(ttemp, visualization_cmap);
        
        imshow(ttemp);
        
    else
        imshow(change_map(:,:,c), [0 upper_limit]);
    end
    
    
    %
    if(size(id,1) > 0)
        
        subplot(1,num_plots,1);
        
        hold on
        
        % plots the points found for this time frame
        plot(j(id), i(id), 'ro', 'MarkerSize', 20, 'LineWidth', 5);
        
        % if specified, shows the spatial neighborhood around every 
        % spatio-temporal point found in this frame, asking the user to 
        % click a button between every point shown
        if(pause_between_frames)
            for ind=1:size(id,1)
                
                subplot(1,num_plots, 3);
                imshow(imresize(xvideo(i(id(ind))-window:i(id(ind))+window, ...
                    j(id(ind))-window:j(id(ind))+window,c), 13), []);
                
                if(pause_between_frames)
                    waitforbuttonpress;
                end
                
            end
        end
        hold off
        
        
    end
    
    % if a filename is specified, saves the current figure content
    % to a new frame of the video sequence (the lines still commented
    % are meant to be used in some scenarios)
    if(nargin >= 8)
        %             outimg(:, 1:size(VID(:,:,1),2), :) = cat(3, VID(:,:,c),VID(:,:,c),VID(:,:,c));
        %             outimg(:,size(VID(:,:,1),2)+20+1:end, :) = ttemp * 255;
        %             writeVideo(vidOut, outimg / 255.);
        
        ff = getframe(gcf);
        data = ff.cdata(134:264, 81:515, :);
        
        for rep=1:repeated_frames
            writeVideo(vidOut, data);
        end
        
    end
        
    % sets a small pause, then increases the
    % current frame counter
    pause(0.0001);
    c = c + 1;
    
    % if the end of the sequence has been reached,
    % exits the loop (the commented line should be
    % swapped with the one below it, in case the user
    % wants to see the sequence looping)
    if(c >= size(video,3))
        % c=2;
        break;
    end
    
end

if(nargin == 8)
    close(vidOut);
end

end



