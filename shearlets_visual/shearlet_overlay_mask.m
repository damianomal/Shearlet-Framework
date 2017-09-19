function [ result ] = shearlet_overlay_mask( image, mask, show, normalize)
%SHEARLET_OVERLAY_MASK Summary of this function goes here
%   Detailed explanation goes here

result = cat(3, image, image, image);

for x=1:size(mask,1)
    for y=1:size(mask,2)
        if(mask(x,y))
            result(x,y,:) = [255 0 0];
        end
    end
end

if(normalize)
    result = result ./ 255;
end

if(show)
    figure;
    imshow(result);
end

end

