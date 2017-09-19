function [ output_mapping ] = shearlet_coeffs_to_image( big_coeffs, x, y, t, scale, shearletIdxs, type, view)
%SHEARLET_COEFFS_TO_IMAGE Summary of this function goes here
%   Detailed explanation goes here

% in base a type mappa in un output diverso,
% 'matrices': tre matrici
% 'big_matrix: matrice graned 15x15
% 'descr': vettore srotolato

if(nargin < 8)
    view = false;
end

switch(type)
    case 'matrices'
        
        [c1, c2, c3] = shearlet_calculate_grids(big_coeffs, x, y, t, scale, shearletIdxs, 1);
        
        if(view)
            
            bigc = [c1(:); c2(:); c3(:)];
            maxc = max(bigc(:));
            
            figure;
            subplot(1,3,1); imshow(c1,[0 maxc]); colorbar;
            subplot(1,3,2); imshow(c2,[0 maxc]); colorbar;
            subplot(1,3,3); imshow(c3,[0 maxc]); colorbar;
        end
        
        output_mapping = cat(3, c1, c2, c3);
        
    case 'big_matrix'
        
        [c1, c2, c3] = shearlet_calculate_grids(big_coeffs, x, y, t, scale, shearletIdxs, 1);
                    
        
%                     bigc = [c1(:); c2(:); c3(:)];
% 
%                     maxc = max(bigc(:));
%             figure;
%             subplot(1,3,1); imshow(c1,[0 maxc]); colorbar;
%             subplot(1,3,2); imshow(c2,[0 maxc]); colorbar;
%             subplot(1,3,3); imshow(c3,[0 maxc]); colorbar;

        mat = shearlet_grids_to_matrix(c1,c2,c3);
        
        if(view)
            
            figure;
            imshow(mat, []);
            
            figure;
            
            [XX, YY] = meshgrid(1:15, 1:15);
            surf(XX, YY, mat(end:-1:1, :));
            rotate3d on;
            
        end
        
        output_mapping = mat;
        
    case 'descr'
        
        [c1, c2, c3] = shearlet_calculate_grids(big_coeffs, x, y, t, scale, shearletIdxs, 1);
        mat = shearlet_grids_to_matrix(c1,c2,c3);
        descr = shearlet_unroll_matrix_to_descr(mat);
        
        if(view)
            figure;
            bar(descr);
        end
        
        output_mapping = descr;
end

end



