function clusters_idx = shearlet_video_clustering_full( VID, centroids, prefix, save_to_mat, end_offset)
%SHEARLET_VIDEO_CLUSTERING Clusters the descriptors passed w.r.t. the
%chosen centroids
%
% Usage:
%   clusters_idx = shearlet_video_clustering_full(X, centroids, prefix)
%           Clusters the content of the video sequence represented in X by
%           using the centroids passed to classify each 2D+T point.
%
% Parameters:
%   X:
%   centroids:
%   prefix:
%   save_to_mat: 
%   end_offset: 
%
% Output:
%   clusters_idx:
%
%   See also ...
%
% 2016 Damiano Malafronte.

if(nargin < 4 || isempty(save_to_mat))
    save_to_mat = true;
end

if(nargin < 5 || isempty(end_offset))
    end_offset = 3;
end

% initialize the structures needed for this operation
clusters_idx = zeros(size(VID,1), size(VID,2), size(VID,3));
vidObjs = cell(1,size(centroids,1));

%
for c=1:size(centroids,1)
    vidObjs{c} = VideoWriter(['Dataset\clustering_files\' prefix int2str(c) '.avi']);
    vidObjs{c}.Quality = 100;
    vidObjs{c}.FrameRate = 25;
    
    open(vidObjs{c});
end

%
t_start = 2;
t_end= 91;

ind = 46;

T_LIMIT = 0;

run = true;
last_iteration = false;

%
while run
    
    fprintf('Transform with ind: %d.\n', ind);
    
    %
    start_cut = ind - ((91 - 1)/2);
    %     completed = false;
    
    %
    clear COEFFS idxs;
    [COEFFS,idxs] = shearlet_transform_3D(VID,ind,91,[0 1 1], 3, 1);
    
    %
    for t=t_start:t_end-end_offset
        
        if(T_LIMIT > 0 && t == T_LIMIT)
            break;
        end
        
        %
        if(~(ind == (size(VID,3)- 45)) && t + start_cut - 1 > size(VID,3) - 45)
            fprintf('CUT\n');
            end_offset = 1;
            last_iteration = true;
            break;
        end
        
        fprintf('Processing frame: %d.\n', t+start_cut-1);
        
        %
        DESCR_MAT = shearlet_descriptor_fast(COEFFS, t, 2, idxs, true);
        CL_IND = shearlet_cluster_by_seeds(DESCR_MAT, COEFFS, centroids);
        CL_SORT = shearlet_cluster_image(CL_IND, size(centroids,1), false, false);
        
        clusters_idx(:,:,t+start_cut-1) = CL_SORT;

        %
        for c=1:size(centroids,1)
            CL_OVERL = shearlet_overlay_cluster(VID(:,:,t+start_cut-1), CL_SORT, c, false, false);            
            writeVideo(vidObjs{c}, CL_OVERL ./ 255);
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
    
    if(last_iteration)
        t_start = 47;
    else
        t_start = 47-end_offset;
    end
    
    %
    if(ind == (size(VID,3)- 45))
        break
    end
    
    %
    ind = min([(ind+45) (size(VID,3)- 45)]);
    
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
    save(['Dataset\clustering_files\' prefix '_cluster_and_vid.mat'], 'VID', 'clusters_idx', 'centroids');
end

% 
for i=1:5
    beep;
    pause(0.5);
end

end

