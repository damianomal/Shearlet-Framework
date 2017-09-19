function [ velocity_map, cone_map ] = shearlet_normal_fast( big_coeffs, idxs, t, scale, th, profiling)
%SHEARLET_NORMAL_FASGT Summary of this function goes here
%   Detailed explanation goes here


global MEGAMAP_ANGLES real_indexes fake_indexes

if(isempty(MEGAMAP_ANGLES))
    shearlet_initialize_megamap_angle(size(big_coeffs), idxs);
end

if(nargin < 6)
   profiling = true; 
end

%
if(profiling)
   st = tic; 
end

cone_map = zeros(size(big_coeffs,1), size(big_coeffs,2));
velocity_map = zeros(size(big_coeffs,1), size(big_coeffs,2), 1, 3);

COEFFS_SHIFT = shearlet_global_coeff_shift(big_coeffs, idxs, t, 1);

for xx=2:size(big_coeffs,1)-1
    
    for yy=2:size(big_coeffs,2)-1
        
        [mx, ii] = max(abs(COEFFS_SHIFT(xx, yy, idxs(:,2) == scale)));
        
        if(mx < th)
            continue;
        end
                
        ii = find(fake_indexes{scale} == real_indexes{scale}(ii));
        
        cone_map(xx,yy) = floor((ii-1)/25)+1;
        
        velocity_map(xx,yy,1, :) = MEGAMAP_ANGLES(ii,:);
        
        if(MEGAMAP_ANGLES(ii,3) == 0)
            continue;
        end
        
        
    end
end


% 
if(profiling)
    fprintf('-- Time for Motion Extraction: %.4f seconds\n', toc(st));
end

end

