function result = shearlet_video_crop( input_video, max_size, start_frame, end_frame, outputname, path)
%SHEARLET_VIDEO_CLUSTERING Clusters the descriptors passed w.r.t. the
%chosen centroids
%
% Usage:
%   clusters_idx = shearlet_video_clustering_full(X, centroids, prefix)
%           Clusters the content of the video sequence represented in X by
%           using the centroids passed to classify each 2D+T point.
%
% Parameters:
%   input_video: the filename of the input video sequence.
%   max_size: the maximum lateral size of every frame.
%   start_frame: the frame to start loading from.
%   end_frame: the last frame to load.
%
%
% Output:
%   result: mat file for the input video file.
%
%   See also ...
%
% 2017 Gaurvi Goyal.

% creates the object to read all the frames
vidObj = VideoReader(input_video);

i = 1;
count = 1;

% if not specified, does not resize the frames within the sequence
if(nargin < 2)
    max_size = 0;
end

% loads the whole video sequence, if the user does not specify a frame to
% start from
if(nargin < 3)
    start_frame = 1;
end

% loads all the frames up to the end of the sequence, if the user does not
% specify an ending frame
if(nargin < 4)
    end_frame = floor(vidObj.Duration * vidObj.FrameRate);
end
if(nargin < 5)
    outputname = 'default';
end
if(nargin < 6)
    path = '';
end
% parameters controls
% if(max_size < 16)
%         ME = MException('load_video_to_mat:tiny_max_size_for_frames', ...
%         'The max_size parameters must be greater than 16.');
%     throw(ME);
% end

if(start_frame < 1 || start_frame > floor(vidObj.Duration * vidObj.FrameRate))
    ME = MException('load_video_to_mat:negative_frame_index', ...
        'Specify a valid value for the starting frame.');
    throw(ME);
end

if(end_frame < start_frame)
    ME = MException('load_video_to_mat:invalid_end_frame', ...
        'The ending frame cannot be before the staring one.');
    throw(ME);
end

if(end_frame > floor(vidObj.Duration * vidObj.FrameRate))
    warning('load_video_to_mat:end_frame_out_of_bounds', ...
        'The ending frame was out of bound, set to be the last frame in the sequence.');
    end_frame = floor(vidObj.Duration * vidObj.FrameRate);
end


% extracts the height and width of each video frame
frame_h = vidObj.Height;
frame_w = vidObj.Width;

% if specified, calculates the future size of the frames, after the
% resizing process
if(max_size > 0 && max_size < max(frame_h, frame_w))
    ratio = max_size / max(frame_h, frame_w);
    
    
    frame_h = round(frame_h * ratio);
    frame_w = round(frame_w * ratio);
    
    resize_frame = true;
else
    resize_frame = false;
end

% initializes the resulting objects
result = zeros(frame_h, frame_w,end_frame-start_frame+1);

% initialize the structures needed for the output video.
% vidObj_out = cell(1,size(1,1));
% 
vidObj_out = VideoWriter([path outputname '.avi']);
vidObj_out.Quality = 100;
vidObj_out.FrameRate = 25;

open(vidObj_out);

% loads the video sequence
while(hasFrame(vidObj) && count <= end_frame)
    
    % reads the current frame
    color_frame = readFrame(vidObj);
    frame = rgb2gray(color_frame);
    
    % if the user specified to consider the frame
    if(count >= start_frame)
        
        % adds the frame to the resulting matrices, resized or not
        if(resize_frame)
            new_frame = imresize(frame, ratio);
            
            if(size(result,1) ~= size(new_frame,1) || size(result,2) ~= size(new_frame,2))
                result = zeros(size(new_frame,1), size(new_frame,2), end_frame-start_frame+1); 
                color_result = zeros(size(new_frame,1), size(new_frame,2), 3, end_frame-start_frame+1); 
            end
            
            result(:,:,i) = new_frame;
            color_result(:,:,:,i) = imresize(color_frame(:,:,:), ratio);
        else
            result(:,:,i) = frame;
            color_result(:,:,:,i) = color_frame(:,:,:);
        end
        i = i + 1;
        writeVideo(vidObj_out,frame)
        
    end
    count = count + 1;
    
end
%%%%%%%%%%%%%%%%%%%%%

end

