function shearlet_play_video( video, fps )
%SHEARLET_PLAY_VIDEO Summary of this function goes here
%   Detailed explanation goes here

figure('Name', 'Video Playback');

c = 1;

grayscale = size(video,3) ~= 3;

if(grayscale)
    frames = size(video, 3);
else
    frames = size(video, 4);
end

while true
    
    if(grayscale)
        imshow(video(:,:,c),[]);
    else
        imshow(video(:,:,:,c),[]);
    end
    
    pause(1.0/fps);
    
    c = c + 1;
    
    if(c > frames)
        c = 1;
    end
end

end

