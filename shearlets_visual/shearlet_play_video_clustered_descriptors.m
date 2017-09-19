function shearlet_play_video_clustered_descriptors( video, descriptors, coordinates, cidx, target_cluster )
%SHEARLET_PLAY_VIDEO_CLUSTERED_DESCRIPTORS Summary of this function goes here
%   Detailed explanation goes here

c=2;

if(numel(target_cluster) > 1)
        
    mask = cidx == target_cluster(1);

    for i=2:numel(target_cluster)
        mask = mask | cidx == target_cluster(i);
    end
else
    mask = cidx == target_cluster;
end

target_coordinates = coordinates(mask, :);

% figure('Position', [9 451 1100 545]);

% titles = {'background', 'dyn. corners', 'far edges', 'background (higher)', ...
%     'background', 'edges', 'edges', ''};
% 
% titles = {'background', 'background', 'background (higher)', 'far edges', ...
%     'corner(ish)', 'edges', 'edges', 'dyn. corners'};
% 
% 
% for c=1:8
%     subplot(2,4,c); imshow(cl_video_idx(:,:,10) == c, []);
%     title(strcat(int2str(c), {': '}, titles(c)));
% end
% 
fHand = figure('Name', 'Points', 'Position', [31 521 531 387]);

times = 0;

vidOut1 = VideoWriter('outvidall_box_4.avi');
vidOut.Quality = 100;
vidOut.FrameRate = 25;
open(vidOut1);



while true
    
    id = find(target_coordinates(:, 3) == c);
    
%     subplot(1,3,1);
    imshow(video(:,:,c), []);
    set(fHand, 'Position', [31 521 531 387]);
    
             fig = getframe(gcf);
        img = fig.cdata;

    if(size(id,1) > 0)
%         
        hold on
        
        plot(target_coordinates(id, 2), target_coordinates(id,1), 'ro', 'MarkerSize', 20, 'LineWidth', 5);
        
            fig = getframe(gcf);
        img = fig.cdata;
%         
%         for ind=1:size(id,1)
%             
%             bard = zeros(1,8);
%             
%             
%             % DESCRIPTOR BUILDING
%             
%             descr_window_t = descr_window - 4;
%             
%             if(descr_window_t < 1)
%                 descr_window_t = 1;
%             end
%             
%             temp = cl_video_idx(i(id(ind))-descr_window_t:i(id(ind))+descr_window_t, ...
%                 j(id(ind))-descr_window_t:j(id(ind))+descr_window_t, ...
%                 k(id(ind))-descr_window_t:k(id(ind))+descr_window_t);
%             
%             for cl=1:8
%                 bard(cl) = nnz(temp == cl);
%             end
%             
%             bard([1 2 3]) = 0;
%             
%             descr_count = descr_count + 1;
%             
%             coordinates(descr_count, :) = [i(id(ind)) j(id(ind)) k(id(ind))];
%             
%             descriptors(descr_count, 1:8) = bard;
%             
%             descr_window_t = descr_window - 2;
%             
%             if(descr_window_t < 1)
%                 descr_window_t = 1;
%             end
%             
%             temp = cl_video_idx(i(id(ind))-descr_window_t:i(id(ind))+descr_window_t, ...
%                 j(id(ind))-descr_window_t:j(id(ind))+descr_window_t, ...
%                 k(id(ind))-descr_window_t:k(id(ind))+descr_window_t);
%             
%             for cl=1:8
%                 bard(cl) = nnz(temp == cl);
%             end
%             
%             bard([1 2 3]) = 0;
%             
%             descriptors(descr_count, 9:16) = bard;
%             descriptors(descr_count, 9:16) = descriptors(descr_count, 9:16) - descriptors(descr_count, 1:8);
%             
%             descr_window_t = descr_window;
%             
%             if(descr_window_t < 1)
%                 descr_window_t = 1;
%             end
%             
%             temp = cl_video_idx(i(id(ind))-descr_window_t:i(id(ind))+descr_window_t, ...
%                 j(id(ind))-descr_window_t:j(id(ind))+descr_window_t, ...
%                 k(id(ind))-descr_window_t:k(id(ind))+descr_window_t);
%             
%             for cl=1:8
%                 bard(cl) = nnz(temp == cl);
%             end
%             
%             bard([1 2 3]) = 0;
%             
%             
%             descriptors(descr_count, 17:24) = bard;
%             descriptors(descr_count, 17:24) = descriptors(descr_count, 17:24) - descriptors(descr_count, 9:16) - descriptors(descr_count, 1:8);
%             
%             
%             
%             
%             descriptors(descr_count, 1:8) = descriptors(descr_count, 1:8) ./ max(descriptors(descr_count, 1:8));
%             descriptors(descr_count, 9:16) = descriptors(descr_count, 9:16) ./ max(descriptors(descr_count, 9:16));
%             descriptors(descr_count, 17:24) = descriptors(descr_count, 17:24) ./ max(descriptors(descr_count, 17:24));
%             
%             
%             % END DESCRIPTOR PART
%             
%             subplot(1,3,3);
%             imshow(imresize(VID(i(id(ind))-visualization_window:i(id(ind))+visualization_window, ...
%                 j(id(ind))-visualization_window:j(id(ind))+visualization_window,c), 13), []);
%             
%             subplot(1,3,2);
%             bar(bard ./max(bard(:)));
%             
%             cla;
%             hold on
%             for ind = 1:numel(bard)
%                 h=bar(ind,bard(ind));
%                 %                 i
%                 %                 size(bard)
%                 set(h,'FaceColor',cluster_map(ind, :));
%             end
%             hold off
%             
%             if(pause_between_frames)
%                 waitforbuttonpress;
%             else
%                 pause(0.04);
%             end
%         end
%         
        hold off
        
    end
    
    
    pause(0.04);
    
    c = c + 1;
    
    if(c == size(video,3))
        c=2;
            times = times + 1;

%         break;
    end
    
    
    writeVideo(vidOut1, img);
    writeVideo(vidOut1, img);
    writeVideo(vidOut1, img);
    
    if(times==2)
        
       break;
    end
    
end


close(vidOut1);


        
end

