function [ descr, mat, c1, c2, c3 ] = shearlet_descriptor_for_point( big_coeffs, x, y, t, scale, shearletIdxs )
%SHEARLET_DESCRIPTOR_FOR_POINT Summary of this function goes here
%   Detailed explanation goes here        

        [c1, c2, c3] = shearlet_calculate_grids(big_coeffs, x, y, t, scale, shearletIdxs, 1);
        mat = shearlet_grids_to_matrix(c1,c2,c3);
        descr = shearlet_unroll_matrix_to_descr(mat);
        
end

