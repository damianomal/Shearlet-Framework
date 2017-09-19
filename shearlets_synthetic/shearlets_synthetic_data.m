function [ output_mat ] = shearlets_synthetic_data( type, sizes, scaling_values)
%SHEARLETS_SYNTHETIC_DATA Summary of this function goes here
%   Detailed explanation goes here

output_mat = ones(sizes);

switch(type)
    
    case 'edge'
        output_mat(:,1:ceil(sizes(2)/2),:) = 0;
        
    case 'corner'
        output_mat(floor(sizes(1)/2):end,1:(ceil(sizes(2)/2)+1),:) = 0;

    case 'other'
        
end

if(nargin > 2)
    output_mat = output_mat .* scaling_values;
end

end

