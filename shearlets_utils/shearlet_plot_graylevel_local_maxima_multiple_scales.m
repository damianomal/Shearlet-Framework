function shearlet_plot_graylevel_local_maxima_multiple_scales( VID, cl_video_max, cl_video_max2, min_threshold, window, pause_between_frames, upper_limit, visualization_cmap, save_filename)
%SHEARLET_PLOT_GRAYLEVEL_LOCAL_MAXIMA Summary of this function goes here
%   Detailed explanation goes here

%
if(~exist('cluster_map'))
    cluster_map = shearlet_init_cluster_map;
end



% vidOut1 = VideoWriter(['outbox2_' save_filename]);
% vidOut.Quality = 100;
% vidOut.FrameRate = 25;
% open(vidOut1);


%
if(nargin == 9)
    vidOut = VideoWriter(save_filename);
    vidOut.Quality = 100;
    vidOut.FrameRate = 25;
    open(vidOut);
    outimg = 255*ones(size(VID(:,:,1),1),20+size(VID(:,:,1),2)*2,3); 
end

if(nargin < 7)
    upper_limit = 3;
    if(nargin < 6)
        pause_between_frames = true;
        if(nargin < 5)
            window = 3;
        end
    end
end


%
% CURMAT = cl_video_max;
% CURMAT(CURMAT < min_threshold) = 0;
% 
% %
% Amin=minmaxfilt(CURMAT,window,'max','same'); % alternatively use imerode in image processing
% [i, j, k]=ind2sub(size(CURMAT),find(Amin==CURMAT & CURMAT > 0)); % <- index of local minima
% 
% %
% idxkeep=find(i>window & i<size(VID,1)-window & j>window & j<size(VID,2)-window & k>window & k<size(VID,3)-window);
% 
% %
% i=i(idxkeep);
% j=j(idxkeep);
% k=k(idxkeep);

[i, j, k] = shearlet_local_maxima_in_3D_matrix(cl_video_max, min_threshold, window, size(VID));
[i2, j2, k2] = shearlet_local_maxima_in_3D_matrix(cl_video_max2, 0.7, window, size(VID));


fprintf('Found local maxima: %d.\n', size(i,1));
fprintf('Found local maxima2: %d.\n', size(i2,1));

c=2;

%
titles = {'background', 'background', 'background (higher)', 'far edges', ...
    'corner(ish)', 'edges', 'edges', 'dyn. corners'};

%
figure('Position', [755 217 1024 214]);

%
while true
    
    %
    id = find(k==c);
    id2 = find(k2==c);
    
    %
    subplot(1,3,1);
    imshow(VID(:,:,c), []);
    
    subplot(1,3, 2);
    
    if(nargin >= 8)
        
        ttemp = cl_video_max(:,:,c);
        ttemp(ttemp > upper_limit) = upper_limit;
        ttemp = gray2ind(ttemp, 256);
        ttemp = ind2rgb(ttemp, visualization_cmap);
        
        imshow(ttemp);
        
        if(nargin >= 9)
           outimg(:, 1:size(VID(:,:,1),2), :) = cat(3, VID(:,:,c),VID(:,:,c),VID(:,:,c));
           outimg(:,size(VID(:,:,1),2)+20+1:end, :) = ttemp * 255;
           writeVideo(vidOut, outimg / 255.); 
        end
    else
        imshow(cl_video_max(:,:,c), [0 upper_limit]);
    end
    
    
    %
    if(size(id,1) > 0 || size(id2,1) > 0)
        
        subplot(1,3,1);
        hold on
        
        plot(j(id), i(id), 'ro', 'MarkerSize', 20, 'LineWidth', 5);
        plot(j(id2), i(id2), 'bo', 'MarkerSize', 20, 'LineWidth', 5);
        
        for ind=1:size(id,1)
            
            
            
            
            subplot(1,3, 3);
            imshow(imresize(VID(i(id(ind))-window:i(id(ind))+window, ...
                j(id(ind))-window:j(id(ind))+window,c), 13), []);
            
            if(pause_between_frames)
                waitforbuttonpress;
            end
            
        end
        
                
        for ind=1:size(id2,1)
            
            subplot(1,3, 3);
            imshow(imresize(VID(i(id2(ind))-window:i(id2(ind))+window, ...
                j(id2(ind))-window:j(id2(ind))+window,c), 13), []);
            
            if(pause_between_frames)
                waitforbuttonpress;
            end
            
        end
        
        hold off
        
    end
    
%         fig = getframe(gcf);
%         writeVideo(vidOut1, fig.cdata);
%         writeVideo(vidOut1, fig.cdata);
%         writeVideo(vidOut1, fig.cdata);
%         writeVideo(vidOut1, fig.cdata);
%         writeVideo(vidOut1, fig.cdata);
%         writeVideo(vidOut1, fig.cdata);
%         writeVideo(vidOut1, fig.cdata);
%         writeVideo(vidOut1, fig.cdata);
%         writeVideo(vidOut1, fig.cdata);
%         writeVideo(vidOut1, fig.cdata);
    
    pause(0.0001);
    
    c = c + 1;
    
    if(c == 91)
        c=2;
%                 break;
    end
end

% close(vidOut1);

end



