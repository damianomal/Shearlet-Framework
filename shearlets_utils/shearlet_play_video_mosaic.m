function play_video_mosaic( suffix, video_indexes)
%PLAY_VIDEO_MOSAIC Summary of this function goes here
%   Detailed explanation goes here

close all;

%
vidObj = cell(1,numel(video_indexes));
videos = cell(1,numel(video_indexes));

%
for c=1:numel(video_indexes)
    vidObj{c} = VideoReader(strcat(suffix, int2str(video_indexes(c)),'.avi'));
    videos{c} = zeros(vidObj{c}.Height, vidObj{c}.Width, 3, vidObj{c}.Duration * vidObj{c}.FrameRate);
    
    i=1;
    while(hasFrame(vidObj{c}))
        videos{c}(:,:,:,i) = readFrame(vidObj{c});
        i = i + 1;
    end
    
end


%
num_rows = 1;
num_columns = ceil(numel(video_indexes)/num_rows);


%
figure('Name', 'Video Mosaic', 'Position', [1 41 1920 963]);


%
for c=1:numel(video_indexes)
    subplot(num_rows,num_columns,c);
    title(strcat('Cluster #', int2str(c)));
end


%
for i=1:size(videos{1},4)
    for c=1:numel(video_indexes)
        videos{c}(:,:,:,i) = videos{c}(:,:,:,i)./255;
    end
end


i = 1;


%
while true
    
    
    %
    for c=1:numel(video_indexes)
        subplot(num_rows,num_columns,c);
        imshow(videos{c}(:,:,:,i));
    end
    
    pause(0.001);
    
    i = i + 1;
    
    
    %
    if(i > size(videos{c},4))
        i = 1;
    end
    
end

end

