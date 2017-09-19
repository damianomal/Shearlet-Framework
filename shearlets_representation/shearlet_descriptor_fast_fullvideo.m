function [ full_representation ] = shearlet_descriptor_fast_fullvideo( big_coeffs, scale, shearletIdxs, print_debug, profiling)
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

global MEGAMAP

dummy_matrix = zeros(size(big_coeffs,1),size(big_coeffs,2),size(big_coeffs,4));

full_representation = zeros(size(big_coeffs,1),size(big_coeffs,2),size(big_coeffs,3));

for i = 1:3
    for j = 1:3
        dummy_matrix(i,j,:) = 1:size(dummy_matrix, 3);
    end
end

[c1, c2, c3] = shearlet_dummy_calculate_grids(dummy_matrix, 2, 2, 2, scale, shearletIdxs, 0);
%         mat = shearlet_grids_to_matrix(c1,c2,c3);
%         descr = shearlet_unroll_matrix_to_descr(mat);

% keyboard

Z = zeros(5,5);

res_v = shearlet_create_indexes_matrix;

% real_indexes = [c1(:); c2(:); c3(:)];

cc1 = c1';
cc2 = c2';
cc3 = c3';

real_indexes = [cc1(:); cc2(:); cc3(:)];

cc1 = flip(c1, 2)';
cc2 = flip(c2, 2)';
cc3 = flip(c3, 2)';

fake_indexes = [cc1(:); cc2(:); cc3(:)];

        %% TODO FINIRE


mask = zeros(15,15);

mask(6:10, 3:13) = 1;
mask(3:13, 6:10) = 1;

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

        %% TODO FINIRE: manca il codice per mettere tutto in output

for t=2:size(big_coeffs,3)-1

% averaging first step

base = squeeze(big_coeffs(:,:,t,:));

shifted = zeros(size(big_coeffs,1),size(big_coeffs,2), size(shearletIdxs,1), 27);

shifted(:,:,:,1) = big_coeffs(:,:,t,:);

c = 2;

for i=-1:1
    temp = circshift(base, i, 1);
    for j=-1:1
        shifted(:,:,:,c) = circshift(temp, j, 2);
        c = c + 1;
    end
end

base = squeeze(big_coeffs(:,:,t-1,:));

for i=-1:1
    temp = circshift(base, i, 1);
    for j=-1:1
        shifted(:,:,:,c) = circshift(temp, j, 2);
        c = c + 1;
    end
end

base = squeeze(big_coeffs(:,:,t+1,:));

for i=-1:1
    temp = circshift(base, i, 1);
    for j=-1:1
        shifted(:,:,:,c) = circshift(temp, j, 2);
        c = c + 1;
    end
end

COEFFS_SHIFT = mean(shifted, 4);

% toc;

%%

% st = tic;

for xx=2:size(big_coeffs,1)-1
        
    for yy=2:size(big_coeffs,2)-1
        
        [~, ii] = max(abs(COEFFS_SHIFT(xx, yy, shearletIdxs(:,2) == scale)));
        
        ii = find(fake_indexes == real_indexes(ii));
        
        coeff_order = squeeze(MEGAMAP(ii,scale,:));
        coeff_order(coeff_order == 0) = 1;
        
        res = abs(COEFFS_SHIFT(xx, yy, coeff_order));
        
        res(MEGAMAP(ii,scale,:) == 0) = 0;
        
        coeffs_mat((xx-1)*size(big_coeffs,2)+yy,:) = res;
        
        %% TODO FINIRE
    end
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

