function [ result ] = shearlet_average_descriptor( big_coeffs, mask, idxs, time_ind, scale, border_skip)
%SHEARLET_AVERAGE_DESCRIPTOR Summary of this function goes here
%   Detailed explanation goes here

% 
if(nargin < 6)
    border_skip = 0;
end

%
% DESCR_MAT = shearlet_descriptor(big_coeffs, time_ind, scale, idxs, true);
DESCR_MAT = shearlet_descriptor_fast(big_coeffs, time_ind, scale, idxs, true);

%
mask_unroll = mask;

%
if(border_skip > 0)
    mask_unroll(1:1+border_skip, :) = 0;
    mask_unroll(:, 1:1+border_skip) = 0;
    mask_unroll(end-border_skip:end, :) = 0;
    mask_unroll(:, end-border_skip:end) = 0;
end

mask_unroll = reshape(mask_unroll' ,1, []);

%
result = zeros(1,size(DESCR_MAT,2));

%
for indice=1:size(DESCR_MAT,1)
    if(mask_unroll(indice))
        result = result + DESCR_MAT(indice,:);
    end
end

%
result = result ./ sum(mask_unroll);

end

