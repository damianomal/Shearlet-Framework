function [ result, mask] = shearlet_overlay_cluster( image, cl_image, cl_number, show, normalize)
%SHEARLET_OVERLAY_CLUSTER Summary of this function goes here
%   Detailed explanation goes here

% result = cat(3, image, image, image);
mask = zeros(size(cl_image));

for c = cl_number
    mask = mask | cl_image == c;
end
result = cat(3, image, image, image);

for x=1:size(mask,1)
    for y=1:size(mask,2)
        if(mask(x,y))
            result(x,y,:) = [255 0 0];
        end
    end
end

% result = imoverlay(image, mask, [255 0 0]);

if(normalize)
    result = result ./ 255;
end


if(show)
    figure;
    imshow(result);
end

end

