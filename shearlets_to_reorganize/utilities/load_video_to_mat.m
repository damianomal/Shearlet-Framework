function [result, color_result] = load_video_to_mat( input_video, max_size, start_frame, end_frame, store)
%LOAD_VIDEO_TO_MAT Loads a video sequence both in grayscale and color
%
% Usage:
%   [result, color_result] = load_video_to_mat('sequence.avi', 128, 100, 200)
%           Loads the video clip represented by the file 'sequence.avi',
%           from frame 100 to frame 200. Moreover, it resizes all the
%           frames so that  the maximum size (height or width) is not
%           greater than 128 pixels.
%
% Parameters:
%   input_video: the filename of the input video sequence.
%   max_size: the maximum lateral size of every frame.
%   start_frame: the frame to start loading from.
%   end_frame: the last frame to load.
%
% Output:
%   result: a 3-dimensional matrix representing the video sequence, with
%           every frame converted to graylevels.
%   color_result: a 3-dimensional matrix representing the original video
%                 sequence
%
%   See also ...
%
% 2016 Damiano Malafronte.

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

%
%
if(nargin < 5)
    store = false;
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

%
%
if(max_size == 0)
    filename = [lower(strrep(input_video, '.', '_')) '_' int2str(start_frame) '_' int2str(end_frame) '.mat'];
else
    filename = [lower(strrep(input_video, '.', '_')) '_' int2str(max_size) '_' int2str(start_frame) '_' int2str(end_frame) '.mat'];
end

if(exist(['shearlet_preloaded_sequences/' filename], 'file') == 2)
    load(['shearlet_preloaded_sequences/' filename]);
    result = VID;
    color_result = COLOR_VID;
    return;
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
color_result = zeros(frame_h, frame_w,3,end_frame-start_frame+1);

% loads the video sequence
while(hasFrame(vidObj) && count <= end_frame)
    
    % reads the current frame
    color_frame = readFrame(vidObj);
    
    % if the user specified to consider the frame
    if(count >= start_frame)
        
        frame = rgb2gray(color_frame);
        
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
    end
    count = count + 1;
end

if(store)
    VID = result;
    COLOR_VID = color_result;
    save(['shearlet_preloaded_sequences/' filename], 'VID', 'COLOR_VID');
end

end

