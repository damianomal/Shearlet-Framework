function [ result ] = shearlet_overlay_mask_weighted( image, mask_values, limit, show, normalize)
%SHEARLET_OVERLAY_MASK Summary of this function goes here
%   Detailed explanation goes here

result = cat(3, image, image, image);

mask_values(mask_values > limit) = limit;
mask_values = mask_values./ limit;

for x=1:size(mask_values,1)
    for y=1:size(mask_values,2)
        if(mask_values(x,y) > 0)
            result(x,y,:) = [255*mask_values(x,y) 0 0];
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

