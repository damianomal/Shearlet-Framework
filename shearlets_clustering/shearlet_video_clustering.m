function [ cl_video ] = shearlet_video_clustering( X, centroids, start_frame, end_frame )
%SHEARLET_VIDEO_CLUSTERING Summary of this function goes here
%   Detailed explanation goes here

cl_video = zeros(size(X,1), size(X,2), 91);

[COEFFS,idxs] = shearlet_transform_3D(X,46,91,[0 1 1], 2, 160, 1);

vidObjs = cell(1,size(centroids,1));

for c=1:size(centroids,1)
    vidObjs{c} = VideoWriter(['file_' int2str(c) '.avi']);
    vidObjs{c}.Quality = 100;
    vidObjs{c}.FrameRate = 25;
    
    open(vidObjs{c});
end

for t=start_frame:end_frame
    
    fprintf('Processing frame %d/%d..\n', t, end_frame);
    
    DESCR_MAT = shearlet_descriptor(COEFFS, t, 2, idxs, true);
    CL_IND = shearlet_cluster_by_seeds(DESCR_MAT, COEFFS, centroids);
    CL_SORT = shearlet_cluster_image(CL_IND, size(centroids,1), false, false);
    
    for c=1:size(centroids,1)
        CL_OVERL = shearlet_overlay_cluster(X(:,:,t), CL_SORT, c, false);
        writeVideo(vidObjs{c}, CL_OVERL ./ 255);
    end
    
end

for c=1:size(centroids,1)
    close(vidObjs{c});
end

end

