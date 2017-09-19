function shearlet_show_frames( VID, frames )
%SHEARLET_SHOW_FRAMES Summary of this function goes here
%   Detailed explanation goes here

count = numel(frames);

if(count < 5)
    r = 1;
    c = count;
else 
    r = 2;
    c = ceil(count/2.);
end

figure;

for i=1:numel(frames)
    subplot(r,c,i);
    imshow(VID(:,:,frames(i)), []);    
end

end