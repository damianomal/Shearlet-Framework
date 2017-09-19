function [result, coordinates] = shearlet_extract_point_sptneighborhood( input_video, s_win, t_win, padding_color, color_rescale_factor)
%EXTRACT_POINT_SPNEIGHBORHOOD Summary of this function goes here
%   Detailed explanation goes here

% play video

close all;

fH = figure(1);
i = 0;
skip = false;

cur_file = 0;

if(nargin < 5)
    color_rescale_factor = 1.0; 
end

while true
    
    if(~skip)
        
        i = i + 1;
        
        figure(1);
        imshow(input_video(:,:,i), []);
        
    end
    
    pause(1./20.);
    
    if strcmp(get(fH,'currentcharacter'),'q')
        break;
    elseif strcmp(get(fH,'currentcharacter'),'p')
        skip = ~skip;
        set(fH,'currentch',char(1));
        figure(fH);
    elseif strcmp(get(fH,'currentcharacter'),'d')
        cur_file = cur_file + 1;
        imwrite(C, ['current_extract_' int2str(cur_file) '.png']);
    elseif strcmp(get(fH,'currentcharacter'),'s')
        skip = true;
        figure(fH);
        [y,x] = ginput(1);
        result = input_video(x-s_win:x+s_win, y-s_win:y+s_win, i-t_win:i+t_win);
        coordinates = [x y i];
        
        %         C = zeros(size(result,1),size(result,2)*size(result,3));
        %
        %         for j =1:size(result,3)
        %             C(:,(1+size(result,2)*(j-1)):(size(result,2)*j)) = result(:,:,j);
        %         end
        
        Ccell = num2cell(result,[1 2]);
        Ccell = reshape(Ccell,1,size(result,3));
        C = cell2mat(Ccell);
        
        
        C = uint8(C) .* color_rescale_factor;
        C = uint8(cat(3, C, C, C));
        
        C(1, :, :) = repmat([255 0 0], size(result,2)*size(result,3), 1,1);
        C(end, :, :) = repmat([255 0 0], size(result,2)*size(result,3), 1,1);
        
        for j =1:size(result,3)
            C(:,(1+size(result,2)*(j-1)),:) = repmat(padding_color, size(result,1), 1,1);
            C(:,(size(result,2)*j),:) = repmat(padding_color, size(result,1), 1,1);
        end
        
        figure(2);
        imshow(C);
        
        cur_file = cur_file + 1;
        imwrite(C, ['current_extract_' int2str(cur_file) '.png']);
        
    end
    
    set(gcf,'currentch','n');
    
    if( i == size(input_video,3))
        i = 0;
    end
    
end

end