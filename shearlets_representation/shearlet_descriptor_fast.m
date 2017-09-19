function [ coeffs_mat ] = shearlet_descriptor_fast( big_coeffs, t, scale, idxs, print_debug, profiling, skip_border)
%SHEARLET_DESCRIPTOR Calculates the shearlet descriptor for the selected
%time instant and scale on the passed coefficients matrix
%
% Example:
%   big_coeffs = shearlet_descriptor(input_coeffs, t, scale, shearletIdxs, debug, profiling)
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

global MEGAMAP real_indexes fake_indexes

if(isempty(MEGAMAP))
    shearlet_initialize_megamap(size(big_coeffs), idxs);
end

if(nargin < 7)
   skip_border = 1; 
end

    
% dummy_matrix = zeros(size(big_coeffs,1),size(big_coeffs,2),size(big_coeffs,4));
% 
% for i = 1:3
%     for j = 1:3
%         dummy_matrix(i,j,:) = 1:size(dummy_matrix, 3);
%     end
% end
% 
% [c1, c2, c3] = shearlet_dummy_calculate_grids(dummy_matrix, 2, 2, 2, scale, shearletIdxs, 0);
% 
% Z = zeros(5,5);
% 
% res_v = shearlet_create_indexes_matrix;
% 
% cc1 = c1';
% cc2 = c2';
% cc3 = c3';
% 
% real_indexes = [cc1(:); cc2(:); cc3(:)];
% 
% cc1 = flip(c1, 2)';
% cc2 = flip(c2, 2)';
% cc3 = flip(c3, 2)';
% 
% fake_indexes = [cc1(:); cc2(:); cc3(:)];
% 
% %
% if(nargin < 6)
%     profiling = false;
%     
%     if(nargin < 5)
%         print_debug = false;
%     end
% end
% 
% %
coeffs_mat = zeros(size(big_coeffs,1)*size(big_coeffs,2), 121);

%
if(profiling)
   st = tic; 
end

%


%% averaging first step

% base = squeeze(big_coeffs(:,:,t,:));
% 
% shifted = zeros(size(big_coeffs,1),size(big_coeffs,2), size(shearletIdxs,1), 27);
% 
% shifted(:,:,:,1) = big_coeffs(:,:,t,:);
% 
% c = 2;
% 
% for i=-1:1
%     temp = circshift(base, i, 1);
%     for j=-1:1
%         shifted(:,:,:,c) = circshift(temp, j, 2);
%         c = c + 1;
%     end
% end
% 
% base = squeeze(big_coeffs(:,:,t-1,:));
% 
% for i=-1:1
%     temp = circshift(base, i, 1);
%     for j=-1:1
%         shifted(:,:,:,c) = circshift(temp, j, 2);
%         c = c + 1;
%     end
% end
% 
% base = squeeze(big_coeffs(:,:,t+1,:));
% 
% for i=-1:1
%     temp = circshift(base, i, 1);
%     for j=-1:1
%         shifted(:,:,:,c) = circshift(temp, j, 2);
%         c = c + 1;
%     end
% end
% 
% COEFFS_SHIFT = mean(shifted, 4);

%
COEFFS_SHIFT = shearlet_average_shifted_coeffs(big_coeffs, idxs, t, 1);

%%


for xx=1+skip_border:size(big_coeffs,1)-skip_border
        
    for yy=1+skip_border:size(big_coeffs,2)-skip_border
        
        [~, ii] = max(abs(COEFFS_SHIFT(xx, yy, idxs(:,2) == scale)));
        
        ii = find(fake_indexes{scale} == real_indexes{scale}(ii));
        
        coeff_order = squeeze(MEGAMAP(ii,scale,:));
        coeff_order(coeff_order == 0) = 1;
        
        res = abs(COEFFS_SHIFT(xx, yy, coeff_order));
        
        res(MEGAMAP(ii,scale,:) == 0) = 0;
        
        coeffs_mat((xx-1)*size(big_coeffs,2)+yy,:) = res;
        
    end
end

% if(print_debug)
%     fprintf('\n');
% end

% 
if(profiling)
    fprintf('-- Time for Representation Extraction: %.4f seconds\n', toc(st));
end

end

