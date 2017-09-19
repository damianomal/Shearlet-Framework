function [img] = shearlet_show_color_wheel(discretized)
%SHEARLET_SHOW_COLOR_WHEEL Summary of this function goes here
%   Detailed explanation goes here

if(nargin < 1)
    discretized = false;
end

figure('Name' ,'HSV Color Wheel', 'Position', [15 482 435 404]); % da casa

if(discretized)
    
    for i=0.0:359.0
        c = floor(i/18.0)*18;
        pl = line([0 cos(((i-9)/180.0)*pi)],[0 sin(((i-9)/180.0)*pi)], 'LineWidth',2);
        pl.Color = hsv2rgb([c/360.0 1 1]);
    end
    
else
    
    for i=0.0:359.0
        pl = line([0 cos((i/180.0)*pi)],[0 sin((i/180.0)*pi)], 'LineWidth',2);
        pl.Color = hsv2rgb([i/360.0 1 1]);
    end
    
end

axis off

f = getframe(gcf);
img = f.cdata;

if(nargout == 1)
   close(gcf); 
end

end

