function [ coeffs_mat ] = shearlet_descriptor( big_coeffs, t, scale, shearletIdxs, print_debug, profiling)
%SHEARLET_DESCRIPTOR Calculates the shearlet descriptor for the selected
%time instant and scale on the passed coefficients matrix
%
% Example:
%   coeffs = shearlet_descriptor(input_coeffs, t, scale, shearletIdxs, debug, profiling)
%       Calculates the shearlet descriptor matrix c
%
% Parameters:
%   input_coeffs:
%   t:
%   scale: 
%   shearletIdxs: 
%   debug: 
%   profiling: 
%
% Output:
%   coeffs_mat:
%
%   See also ...
 
% 2016 Damiano Malafronte.



%
if(nargin < 6)
    profiling = false;
    
    if(nargin < 5)
        print_debug = false;
    end
end

%
coeffs_mat = zeros(size(big_coeffs,1)*size(big_coeffs,2), 121);

%
if(profiling)
   st = tic; 
end

%

for xx=2:size(big_coeffs,1)-1
    
    %
    if(print_debug)
        
        %
        if(xx > 2)
            fprintf(repmat('\b',1, numel(msg)));
        end
        
        msg = ['---- Processing row ' int2str(xx) '/' int2str(size(big_coeffs,1)-1) ' '];
        fprintf(msg);
    end
    
    row_index = (xx-1)*size(big_coeffs,2);
    
    %
    for yy=2:size(big_coeffs,2)-1
        coeffs_mat(row_index+yy, :) = shearlet_descriptor_for_point( big_coeffs, xx, yy, t, scale, shearletIdxs);
    end
end

%
if(print_debug)
    fprintf('\n');
end

% 
if(profiling)
    fprintf('-- Time for Representation Extraction: %.4f seconds\n', toc(st));
end

end

