function [ output_mat ] = shearlets_synthetic_worm( siz, delay, ratio)
%SHEARLETS_SYNTHETIC_WORM Summary of this function goes here
%   Detailed explanation goes here

OFFSET = 20;
output_mat = 255*ones(siz, siz, siz);

mid_val = siz / 2;

if(nargin < 3)
   ratio = 1; 
end

for t = delay:(siz-delay)

    if(t <= mid_val)
        output_mat(OFFSET+mid_val-20+1:OFFSET+mid_val+20, ...
                   mid_val-20+1:mid_val+20, ...
                   t) = 0;
    else
        
        y_off = floor((t - mid_val) * ratio);
        output_mat(OFFSET+mid_val-20+1-y_off:OFFSET+mid_val+20-y_off, ...
                   mid_val-20+1:mid_val+20, ...
                   t) = 0;
    end
   
end



