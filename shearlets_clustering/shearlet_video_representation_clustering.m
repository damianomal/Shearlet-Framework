function [ cl_video_idx, cl_video_max ] = shearlet_video_representation_clustering( VID, centroids, scale_used, prefix, save_to_mat)
%SHEARLET_VIDEO_CLUSTERING Clusters the descriptors passed w.r.t. the
%chosen centroids
%
% Usage:
%   [idx, maxs] = shearlet_video_clustering_full(VID, centroids, scale_used, prefix, save_to_mat)
%           Clusters the content of the video sequence represented in VID by
%           using the centroids passed to classify each 2D+T point.
%
% Parameters:
%   VID:
%   centroids:
%   scale_used:
%   prefix:
%   save_to_mat:
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

cl_video_idx = zeros(size(VID,1), size(VID,2), size(VID,3));
cl_video_max = zeros(size(VID,1), size(VID,2), size(VID,3));

% auxiliary variables used to browse over the whole video sequence

t_start = 2;
t_end= 90;
ind = 46;

% debug variable in case it's needed (some checks will be found
% later in this function file)

T_LIMIT = 0;

%

while true
    
    fprintf('Transform with ind: %d.\n', ind);
    
    % calculates the shearlet transform around the currend frame "ind"
    
    clear COEFFS idxs;
    [COEFFS,idxs] = shearlet_transform_3D(VID,ind,91,[0 1 1], scale_used, 1);
    
    % variable used to select which frames have already been processed by 
    % the previous iterations within this while cycle
    
    start_cut = ind - ((91 - 1)/2);
    
    % for every frame to be considered
    
    for t=t_start:t_end
        
        % necessary for debugging purposes, do not remove
        
        if(T_LIMIT > 0 && t == T_LIMIT)
            break;
        end
        
        % necessary for debugging purposes, do not remove
        
        if(~(ind == (size(VID,3)- 45)) && t + start_cut > size(VID,3) - 45)
            fprintf('CUT\n');
            break;
        end
        
        fprintf('Processing frame: %d.\n', t+start_cut-1);
        
        % calculates the descriptor starting from the coefficients for
        % the current frame in position "t"
         
        REPRESENTATION = shearlet_descriptor(COEFFS, t, scale_used, idxs, true);
        
        % clusters the representation matrix for the current frame using 
        % the centroids passed as a parameter
        
        CL_IND = shearlet_cluster_by_seeds(REPRESENTATION, COEFFS, centroids);
        CL_SORT = shearlet_cluster_image(CL_IND, size(centroids,1), false, false);
        
        % stores the results in the structures to be saved in the .mat file
        
        cl_video_idx(:,:,t+start_cut-1) = CL_SORT;
        cl_video_max(:,:,t+start_cut-1) = reshape(REPRESENTATION(:,1), size(VID,2), size(VID,1))';
        
    end
    
    % necessary for debugging purposes, do not remove
    
    if(T_LIMIT > 0 && t == T_LIMIT)
        break;
    end
    
    % specifies that from the second iteration the processing
    % should begin from the index in the "center" of the sequence slice 
    % used for the 3D shearlet transform
    
    t_start = 46;
    
    % exits the while loop if this should have been the last iteration
    
    if(ind == (size(VID,3)- 45))
        break
    end
    
    % moves the index to its next value
    
    ind = min([(ind+45) (size(VID,3)- 45)]);
    
end

% if specified by the user, saves all the meaningful structures to a .mat
% file with a name similar to the input sequence

if(save_to_mat)
    SORT_CTRS = centroids;
    save([prefix '_clustered.mat'], 'VID', 'cl_video_idx', 'cl_video_max', 'SORT_CTRS');
end

% beeps five times to indicate that the process has completed

for i=1:5
    beep;
    pause(0.5);
end

end

