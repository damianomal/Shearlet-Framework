function shearlet_plot_cluster_local_maxima( VID, cl_video_idx, cl_video_max, min_threshold, target_cluster, window, pause_between_frames)
%SHEARLET_PLOT_CLUSTER_LOCAL_MAXIMA Summary of this function goes here
%   Detailed explanation goes here


% cluster_map =  [0 0 1; 1 0 0; 0 1 0; ...
%     1 1 0; 0 0 0; 0 1 1; ...
%     1 0 1; 1 1 1; 0.5 0.5 0.5; ...
%     0.6 0.6 0; 1 0.4 0.4; 0.2 1 0.3; ...
%     0.9 0.8 0.1; 0.2 0.2 1];

if(~exist('cluster_map'))
    cluster_map = shearlet_init_cluster_map;
end


if(nargin < 7)
    pause_between_frames = true;
    if(nargin < 6)
        window = 3;
    end
end

% CURMAT = cl_video_max(:,:,2:99);
% CURMAT(cl_video_idx(:,:,2:99) ~= target_cluster) = 0;

CURMAT = cl_video_max;

CURMAT(CURMAT < min_threshold) = 0;

Amin=minmaxfilt(CURMAT,window,'max','same'); % alternatively use imerode in image processing
[i, j, k]=ind2sub(size(CURMAT),find(Amin==CURMAT & CURMAT > 0)); % <- index of local minima

win = 5;

% idxkeep=find(i>1 & i<100 & j>1 & j<100 & k>1 & k<100);
% idxkeep=find(i>win & i<100-win & j>win & j<100-win & k>win & k<100-win);
idxkeep=find(i>window & i<=size(VID,1)-window & j>window & j<=size(VID,2)-window & k>window & k<=size(VID,3)-window);

i=i(idxkeep);
j=j(idxkeep);
k=k(idxkeep);

fprintf('Found local maxima: %d.\n', size(i,1));

% figure; imshow(CURMAT(:,:,22), []);

% figure(1);

% for c=2:99

c=2;

figure('Position', [9 451 1100 545]);

% titles = {'background', 'dyn. corners', 'far edges', 'background (higher)', ...
%     'background', 'edges', 'edges', ''};

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
            
            temp = cl_video_idx(i(id(ind))-window:i(id(ind))+window, ...
                j(id(ind))-window:j(id(ind))+window, ...
                k(id(ind))-window:k(id(ind))+window);
            
            for cl=1:8
%                 %                 count = temp == cl;
%                 %                 bard(cl) = sum(count(:));
                bard(cl) = nnz(temp == cl);
                
            end
            
            bard([1 2 3]) = 0;
            
            subplot(1,3,3);
            imshow(imresize(VID(i(id(ind))-window:i(id(ind))+window, ...
                j(id(ind))-window:j(id(ind))+window,c), 13), []);
            
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
    end
end

end

