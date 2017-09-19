function [ output_mat, output_image ] = shearlet_extract_spt_neighborhood( video_mat, coords, s_win, t_win, padding_color, color_rescale_factor)
%SHEARLET_EXTRACT_SPT_NEIGHBORHOOD Summary of this function goes here
%   Detailed explanation goes here

x = coords(1);
y = coords(2);
t = coords(3);

if(nargin < 6)
    color_rescale_factor = 1.5;
    if(nargin < 5)
        padding_color = [255 0 0];
    end
end

output_mat = video_mat(x-s_win:x+s_win, y-s_win:y+s_win, t-t_win:t+t_win);

% C = zeros(size(output_mat,1),size(output_mat,2)*size(output_mat,3));
% 
% for j=1:size(output_mat,3)
%     C(:,(1+size(output_mat,2)*(j-1)):(size(output_mat,2)*j)) = output_mat(:,:,j);
% end

if(nargout > 1)
    
    Ccell = num2cell(output_mat,[1 2]);
    Ccell = reshape(Ccell,1,[]);
    output_image = cell2mat(Ccell);
    
    output_image = uint8(output_image) .* color_rescale_factor;
    output_image = cat(3, output_image, output_image, output_image);
    
    output_image(1, :, :) = repmat([255 0 0], size(output_mat,2)*size(output_mat,3), 1,1);
    output_image(end, :, :) = repmat([255 0 0], size(output_mat,2)*size(output_mat,3), 1,1);
    
    for j=1:size(output_mat,3)
        output_image(:,(1+size(output_mat,2)*(j-1)),:) = repmat(padding_color, size(output_mat,1), 1,1);
        output_image(:,(size(output_mat,2)*j),:) = repmat(padding_color, size(output_mat,1), 1,1);
    end
    
end

end

