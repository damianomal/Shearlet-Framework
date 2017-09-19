function [descriptors, coordinates] = shearlet_extract_descriptor( VID, cl_video_idx, c2_vars, min_threshold, minmax_window, descr_window, pause_between_frames)
%SHEARLET_PLOT_CLUSTER_LOCAL_MAXIMA Summary of this function goes here
%   Detailed explanation goes here

if(~exist('cluster_map'))
    cluster_map = shearlet_init_cluster_map;
end

% debug value
visualization_window = 5;

if(nargin < 7)
    pause_between_frames = true;
    if(nargin < 6)
        minmax_window = 3;
    end
end


st = tic;

[i, j, k] = shearlet_local_maxima_in_3D_matrix(c2_vars, min_threshold, minmax_window, size(VID));

% fprintf('-- Time to sum up cone 2 SH coeffs: %.4f seconds\n', toc(st));
fprintf('-- Found local maxima: %d.\n', size(i,1));

descriptors = zeros(size(i,1), 8*3);
coordinates = zeros(size(i,1), 3);
descr_count = 0;

% figure; imshow(CURMAT(:,:,22), []);

% figure(1);

% for c=2:99

c=2;

figure('Position', [9 451 1100 545]);

titles = {'background', 'background', 'background (higher)', 'far edges', ...
    'corner(ish)', 'edges', 'edges', 'dyn. corners'};


for c=1:8
    subplot(2,4,c); imshow(cl_video_idx(:,:,10) == c, []);
    title(strcat(int2str(c), {': '}, titles(c)));
end

figure('Position', [755 217 1024 214]);

while true
    
    id = find(k==c);
    
    subplot(1,3,1);
    imshow(VID(:,:,c), []);
    
    if(size(id,1) > 0)
        
        hold on
        
        plot(j(id), i(id), 'ro', 'MarkerSize', 20, 'LineWidth', 5);
        
        for ind=1:size(id,1)
            
            bard = zeros(1,8);
            
            
            % DESCRIPTOR BUILDING
            
            descr_window_t = descr_window - 4;
            
            if(descr_window_t < 1)
                descr_window_t = 1;
            end
            
            temp = cl_video_idx(i(id(ind))-descr_window_t:i(id(ind))+descr_window_t, ...
                j(id(ind))-descr_window_t:j(id(ind))+descr_window_t, ...
                k(id(ind))-descr_window_t:k(id(ind))+descr_window_t);
            
            for cl=1:8
                bard(cl) = nnz(temp == cl);
            end
            
            bard([1 2 3]) = 0;
            
            descr_count = descr_count + 1;
            
            coordinates(descr_count, :) = [i(id(ind)) j(id(ind)) k(id(ind))];
            
            descriptors(descr_count, 1:8) = bard;
            
            descr_window_t = descr_window - 2;
            
            if(descr_window_t < 1)
                descr_window_t = 1;
            end
            
            temp = cl_video_idx(i(id(ind))-descr_window_t:i(id(ind))+descr_window_t, ...
                j(id(ind))-descr_window_t:j(id(ind))+descr_window_t, ...
                k(id(ind))-descr_window_t:k(id(ind))+descr_window_t);
            
            for cl=1:8
                bard(cl) = nnz(temp == cl);
            end
            
            bard([1 2 3]) = 0;
            
            descriptors(descr_count, 9:16) = bard;
            descriptors(descr_count, 9:16) = descriptors(descr_count, 9:16) - descriptors(descr_count, 1:8);
            
            descr_window_t = descr_window;
            
            if(descr_window_t < 1)
                descr_window_t = 1;
            end
            
            temp = cl_video_idx(i(id(ind))-descr_window_t:i(id(ind))+descr_window_t, ...
                j(id(ind))-descr_window_t:j(id(ind))+descr_window_t, ...
                k(id(ind))-descr_window_t:k(id(ind))+descr_window_t);
            
            for cl=1:8
                bard(cl) = nnz(temp == cl);
            end
            
            bard([1 2 3]) = 0;
            
            
            descriptors(descr_count, 17:24) = bard;
            descriptors(descr_count, 17:24) = descriptors(descr_count, 17:24) - descriptors(descr_count, 9:16) - descriptors(descr_count, 1:8);
            
            
            
            
            descriptors(descr_count, 1:8) = descriptors(descr_count, 1:8) ./ max(descriptors(descr_count, 1:8));
            descriptors(descr_count, 9:16) = descriptors(descr_count, 9:16) ./ max(descriptors(descr_count, 9:16));
            descriptors(descr_count, 17:24) = descriptors(descr_count, 17:24) ./ max(descriptors(descr_count, 17:24));
            
            
            % END DESCRIPTOR PART
            
            subplot(1,3,3);
            imshow(imresize(VID(i(id(ind))-visualization_window:i(id(ind))+visualization_window, ...
                j(id(ind))-visualization_window:j(id(ind))+visualization_window,c), 13), []);
            
            subplot(1,3,2);
            bar(bard ./max(bard(:)));
            
            cla;
            hold on
            for ind = 1:numel(bard)
                h=bar(ind,bard(ind));
                %                 i
                %                 size(bard)
                set(h,'FaceColor',cluster_map(ind, :));
            end
            hold off
            
            if(pause_between_frames)
                waitforbuttonpress;
            else
                pause(0.04);
            end
        end
        
        hold off
        
    end
    
    
    pause(0.04);
    
    c = c + 1;
    
    if(c == size(VID,3))
        c=2;
        break;
    end
end

end

