% function [ cl_video_idx, cl_video_max ] = shearlet_video_clustering_full( X, centroids, prefix, save_to_mat)
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


BACK_OFFSET = 3;

%
t_start = 1;
t_end = 91;

ind = 46;

T_LIMIT = 0;

SIZE = 200; %frames

previous_frame = t_start - 1;

run = true;

%
while run
    
    fprintf('Transform with ind: %d.\n', ind);
    
    %
    start_cut = ind - ((91 - 1)/2);
    %     completed = false;
        
    %
    for t=t_start:t_end-BACK_OFFSET
                
        %
        if(~(ind == (SIZE - 45)) && t + start_cut - 1 > SIZE - 45)
            fprintf('CUT\n');
            BACK_OFFSET = 0;
            break;
        end
        
%         fprintf('Processing frame: %d.\n', t+start_cut-1);
        
        if( t+start_cut-2 ~= previous_frame ) 
            fprintf('---- ERROR at frame: %d.\n', t+start_cut-1);
            run = false;
            break
        end
        
        previous_frame = t+start_cut-1;
        
    end
    
    if(T_LIMIT > 0 && t == T_LIMIT)
        break;
    end
    
    %     if(completed)
    %
    %     end
    
    t_start = 46+1-BACK_OFFSET;
    
    %
    if(ind == (SIZE - 45))
        break
    end
    
    %
    ind = min([(ind+45) (SIZE - 45)]);
    
    %     if(ind == (size(X,3)- 45))
    %         t_end = 91;
    %     end
    
end


