function [ avg_descr ] = shearlet_show_avg_descriptor( COEFFS, t, scale, idxs, mask )
%SHEARLET_SHOW_AVG_DESCRIPTOR Summary of this function goes here
%   Detailed explanation goes here

avg_descr = zeros(121,1);
count = 0;

for xx=2:size(COEFFS,1)-1
    for yy=2:size(COEFFS,2)-1
        
        if(mask(xx,yy) ~= 1)
            continue;
        end
        
        temp = shearlet_descriptor_for_point( COEFFS, xx, yy, t, scale, idxs);
        avg_descr  = avg_descr + temp(1:121);
        count = count + 1;
    end
end

avg_descr = avg_descr ./ count;

shearlet_show_descriptor(avg_descr);

end

