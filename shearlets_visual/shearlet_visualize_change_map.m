function [ output_args ] = shearlet_visualize_change_map( sequence, change_map, upper_limit, cmap, filename )
%SHEARLET_VISUALIZE Summary of this function goes here
%   Detailed explanation goes here



if(nargin < 4)
    cmap = colormap(jet(256));
    if(nargin < 3)
        upper_limit = 3;
    end
end


incremental = 0;

c=2;

%
% figure('Position', [755 217 1024 214]);
fH = figure;

paused = false;

%
while true
    
    if(~paused)
        %
        subplot(1,2,1);
        imshow(sequence(:,:,c), []);
        
        subplot(1,2,2);
        
        ttemp = change_map(:,:,c);
        ttemp(ttemp > upper_limit) = upper_limit;
        ttemp = gray2ind(ttemp, 256);
        ttemp = ind2rgb(ttemp, cmap);
        
        imshow(ttemp);
        
        c = c + 1;
        
        
        if(c == size(sequence, 3))
            c=2;
        end
        
    end
    
    key = get(gcf,'currentch');
    set(gcf,'currentch',char(1))
    
    if(strcmp (key , 'p'))
        paused = ~paused;
    end
    
    if(strcmp (key , 's'))
        fig = getframe(gcf);
        imwrite(fig.cdata, [filename '_' int2str(incremental) '.png']);
        incremental = incremental + 1;
    end
    
    figure(fH);
    pause(0.04);
    
end

% close(vidOut1);

end



