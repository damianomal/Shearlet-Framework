function shearlet_play_overlay_points( video, coordinates, pause_between_frames, win)
%SHEARLET_PLAY_OVERLAY_POINTS Summary of this function goes here
%   Detailed explanation goes here



i = coordinates(:,1);
j = coordinates(:,2);
k = coordinates(:,3);

c=2;

%
repeated_frames = 5;

% figure('Position', [-1320 184 1266 594]);
figure;


% cycle over the whole sequence
while true
    
    % selects the points found in the current frame
    if(nargin == 4 && win >= 0)
        id = find(abs(k-c)<=win);
    else
        id = find(k==c);
    end
    
    % showing the current frame in the sequence
    %     subplot(1,num_plots,1);
    if(size(video,3) == 3)
        imshow(video(:,:,:,c), []);
    else
        imshow(video(:,:,c), []);
    end
    
    %     subplot(1,num_plots, 2);
    
    % if the user specifies a colormap, uses it to visualize the
    % change map, otherwise shows the map in grayscale
    %     if(nargin >= 7)
    %
    %         ttemp = change_map(:,:,c);
    %         ttemp(ttemp > upper_limit) = upper_limit;
    %         ttemp = gray2ind(ttemp, 256);
    %         ttemp = ind2rgb(ttemp, visualization_cmap);
    %
    %         imshow(ttemp);
    %
    %     else
    %         imshow(change_map(:,:,c), [0 upper_limit]);
    %     end
    %
    
    %
    if(size(id,1) > 0)
        
        %         subplot(1,num_plots,1);
        
        hold on
        
        % plots the points found for this time frame
        plot(j(id), i(id), 'ro', 'MarkerSize', 20, 'LineWidth', 5);
        
        % if specified, shows the spatial neighborhood around every
        % spatio-temporal point found in this frame, asking the user to
        % click a button between every point shown
        %         if(pause_between_frames)
        %             for ind=1:size(id,1)
        %
        %                 subplot(1,num_plots, 3);
        %                 imshow(imresize(xvideo(i(id(ind))-window:i(id(ind))+window, ...
        %                     j(id(ind))-window:j(id(ind))+window,c), 13), []);
        %
        if(pause_between_frames)
            waitforbuttonpress;
        end
        
        %             end
        %         end
        hold off
        
        
    end
    
    % if a filename is specified, saves the current figure content
    % to a new frame of the video sequence (the lines still commented
    % are meant to be used in some scenarios)
    %     if(nargin >= 8)
    %         %             outimg(:, 1:size(VID(:,:,1),2), :) = cat(3, VID(:,:,c),VID(:,:,c),VID(:,:,c));
    %         %             outimg(:,size(VID(:,:,1),2)+20+1:end, :) = ttemp * 255;
    %         %             writeVideo(vidOut, outimg / 255.);
    %
    %         ff = getframe(gcf);
    %         data = ff.cdata(134:264, 81:515, :);
    %
    %         for rep=1:repeated_frames
    %             writeVideo(vidOut, data);
    %         end
    %
    %     end
    
    % sets a small pause, then increases the
    % current frame counter
    pause(0.04);
    c = c + 1;
    
    % if the end of the sequence has been reached,
    % exits the loop (the commented line should be
    % swapped with the one below it, in case the user
    % wants to see the sequence looping)
    if(((size(video,3) > 3) &&  c >= size(video,3)) || ((size(video,3) == 3) &&  c >= size(video,4)))
        % c=2;
        break;
    end
    
end



end

