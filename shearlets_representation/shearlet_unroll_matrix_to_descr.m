function [ descr ] = shearlet_unroll_matrix_to_descr( mat )
%SHEARLET_UNROLL_MATRIX_TO_DESCR Summary of this function goes here
%   Detailed explanation goes here

global res_v

if(isempty(res_v))
    res_v = shearlet_create_indexes_matrix;
end

res_u = mat(:);
res = res_u(res_v);

descr = res(1:121);

end

