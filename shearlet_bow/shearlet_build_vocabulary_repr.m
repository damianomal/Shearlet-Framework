function [ DICTIONARY_REPR, ALL_CLUSTERS ] = shearlet_build_vocabulary_repr( video_set, frames_per_sequence, detection_th, clusters_repr, words_num, repr_scale_used)
%SHEARLET_BUILD_VOCABULARY Summary of this function goes here
%   Detailed explanation goes here

%
LOWER_THRESHOLD = 0.1;
SPT_WINDOW = 7;
SCALES = [2];
CONE_WEIGHTS = [1 1 1];

%
ALL_CLUSTERS = zeros(100, 121);
cur_cluster = 1;

if(nargin < 6)
    
    %
    repr_scale_used = 2;
end

%
for nn=video_set
    
    n = nn{1};
    
    fprintf('Building vocabulary from video named %s, with W=%d and scale %d \n', n.name, words_num, repr_scale_used);
    
    %
    clear VID
    [VID, ~] = load_video_to_mat(n.name,160, n.start, n.end, true);
    
    % calculate the 3D Shearlet Transform
    clear COEFFS idxs
    [COEFFS,idxs] = shearlet_transform_3D(VID,46,91,[0 1 1], 3, 1, [2 3]);
    
    % detect spatio-temporal interesting points within the sequence
    [COORDINATES, ~] = shearlet_detect_points( VID(:,:,1:91), COEFFS, SCALES, [], LOWER_THRESHOLD, SPT_WINDOW, CONE_WEIGHTS, false);
    
    % counts the presence of spt interest points over time
    [COUNTS] = comparison_points_over_time(VID(:,:,1:91), COORDINATES, false);
    
    % extract the N frames with the most spt ip
    [FRAMES] = shearlet_n_frames_with_most_points(COUNTS, frames_per_sequence, 1);
    
    % for every frame..
    for cur_frame=FRAMES
        
        % calcola la rappresentazione usando i centroidi passati
        clear REPRESENTATION
        [REPRESENTATION] = shearlet_descriptor_fast(COEFFS, cur_frame, repr_scale_used, idxs, true, true);
        
        % clusters the representations for this particular frame in N clusters
        CLUSTER_NUMBER = 8;
        [~, CTRS] = shearlet_cluster_coefficients(REPRESENTATION, CLUSTER_NUMBER, [size(COEFFS,1) size(COEFFS,2)]);
        
        % reallocates the ALL_CLUSTERS structure, in case it gets too big
        % TODO: rewrite this part since the number is ~fixed
        if(cur_cluster + CLUSTER_NUMBER > size(ALL_CLUSTERS,1))
            ALL_CLUSTERS = [ALL_CLUSTERS;
                            zeros(50, 121)];
        end
        
%         % OLD CODE
%         for cl=1:CLUSTER_NUMBER
%             ALL_CLUSTERS(cur_cluster, :) = CTRS(cl, :);
%             cur_cluster = cur_cluster + 1;
%         end
        
        ALL_CLUSTERS(cur_cluster:cur_cluster+CLUSTER_NUMBER-1, :) = CTRS;
        cur_cluster = cur_cluster + CLUSTER_NUMBER;
        
    end
    
end

% cuts out the matrix in excess
ALL_CLUSTERS = ALL_CLUSTERS(1:cur_cluster-1,:);

% 
if(words_num >= cur_cluster-1)
    DICTIONARY_REPR = ALL_CLUSTERS;
else
    
    %
    opts = statset('Display','final', 'MaxIter',200);
    [~, DICTIONARY_REPR] = kmeans(ALL_CLUSTERS, words_num, 'Distance', 'sqeuclidean', 'Replicates',3, 'Options',opts);
    
end


end

