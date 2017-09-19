function [ cl_video_idx, cl_video_max ] = shearlet_video_clustering_full( X, centroids, prefix, save_to_mat)
%SHEARLET_VIDEO_CLUSTERING Clusters the descriptors passed w.r.t. the
%chosen centroids
%
% Usage:
%   [idx, maxs] = shearlet_video_clustering_full(X, centroids, prefix)
%           Clusters the content of the video sequence represented in X by
%           using the centroids passed to classify each 2D+T point.
%
% Parameters:
%   X:
%   centroids:
%   prefix:
%
% Output:
%   idx:
%   max:
%
%   See also ...

% 2016 Damiano Malafronte.

if(nargin < 4)
    save_to_mat = false;
end

% initialize the structures needed for this operation
cl_video_idx = zeros(size(X,1), size(X,2), size(X,3));
cl_video_max = zeros(size(X,1), size(X,2), size(X,3));
vidObjs = cell(1,size(centroids,1));

%
for c=1:size(centroids,1)
    vidObjs{c} = VideoWriter([prefix int2str(c) '.avi']);
    vidObjs{c}.Quality = 100;
    vidObjs{c}.FrameRate = 25;
    
    open(vidObjs{c});
end

%
t_start = 2;
t_end= 90;

ind = 46;

T_LIMIT = 0;

%
while true
    
    fprintf('Transform with ind: %d.\n', ind);
    
    %
    start_cut = ind - ((91 - 1)/2);
    %     completed = false;
    
    %
    clear COEFFS idxs;
    [COEFFS,idxs] = shearlet_transform_3D(X,ind,91,[0 1 1], 2, 1);
    %shearlet_transform_3D_fullwindow
    
    
    %
    for t=t_start:t_end
        
        if(T_LIMIT > 0 && t == T_LIMIT)
            break;
        end
        
        %
        if(~(ind == (size(X,3)- 45)) && t + start_cut > size(X,3) - 45)
            fprintf('CUT\n');
            break;
        end
        
        fprintf('Processing frame: %d.\n', t+start_cut-1);
        
        %
        DESCR_MAT = shearlet_descriptor(COEFFS, t, 2, idxs, true);
        CL_IND = shearlet_cluster_by_seeds(DESCR_MAT, COEFFS, centroids);
        CL_SORT = shearlet_cluster_image(CL_IND, size(centroids,1), false, false);
        
        cl_video_idx(:,:,t+start_cut-1) = CL_SORT;
        cl_video_max(:,:,t+start_cut-1) = reshape(DESCR_MAT(:,1), 160, 120)';
        %
        for c=1:size(centroids,1)
            CL_OVERL = shearlet_overlay_cluster(X(:,:,t+start_cut-1), CL_SORT, c, false, false);
            
            writeVideo(vidObjs{c}, CL_OVERL ./ 255);
%             imwrite(CL_OVERL, ['prova_' int2str(c) '.png']);
        end
        
        %         if(t == 91)
        %             completed = true;
        %         end
    end
    
    if(T_LIMIT > 0 && t == T_LIMIT)
        break;
    end
    
    %     if(completed)
    %
    %     end
    
    t_start = 46;
    
    %
    if(ind == (size(X,3)- 45))
        break
    end
    
    %
    ind = min([(ind+45) (size(X,3)- 45)]);
    
    %     if(ind == (size(X,3)- 45))
    %         t_end = 91;
    %     end
    
end

% 
for c=1:size(centroids,1)
    close(vidObjs{c});
end

%
if(save_to_mat)
    SORT_CTRS = centroids;
    VID = X;
    save([prefix '_cl_video_and_vid.mat'], 'VID', 'cl_video_idx', 'cl_video_max', 'SORT_CTRS');
end

% 
for i=1:5
    beep;
    pause(0.5);
end

end

