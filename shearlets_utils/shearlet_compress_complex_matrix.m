function [ output_mat ] = shearlet_compress_complex_matrix(input_mat, type)
%SHEARLET Summary of this function goes here
%   Detailed explanation goes here

to_compress = gather(input_mat);

to_compress_r = real(to_compress);
to_compress_i = imag(to_compress);

mmax_r = max(to_compress_r(:));
mmin_r = min(to_compress_r(:));

compressed_r = ((to_compress_r-mmin_r)/(mmax_r-mmin_r));

mmax_i = max(to_compress_i(:));
mmin_i = min(to_compress_i(:));

compressed_i = ((to_compress_i-mmin_i)/(mmax_i-mmin_i));

if(strcmp(type,'uint16'))
    
    compressed_uint16_r = uint16(compressed_r*65535);
    compressed_uint16_i = uint16(compressed_i*65535);
    
    recounstructed_r_uint16 = ((double(compressed_uint16_r) ./ 65535) .* (mmax_r-mmin_r)) + mmin_r;
    recounstructed_i_uint16 = ((double(compressed_uint16_i) ./ 65535) .* (mmax_i-mmin_i)) + mmin_i;
    
    output_mat = gpuArray(complex(recounstructed_r_uint16, recounstructed_i_uint16));
    
else
    if(strcmp(type,'uint8'))
        
        compressed_uint8_r = uint8(compressed_r*255);
        compressed_uint8_i = uint8(compressed_i*255);
        
        recounstructed_r_uint8 = ((double(compressed_uint8_r) ./ 255) .* (mmax_r-mmin_r)) + mmin_r;
        recounstructed_i_uint8 = ((double(compressed_uint8_i) ./ 255) .* (mmax_i-mmin_i)) + mmin_i;
        
        output_mat = gpuArray(complex(recounstructed_r_uint8, recounstructed_i_uint8));
    else
        
        ME = MException('shearlet_compress_complex_matrix:output_type', ...
            'Wrong type.');
        throw(ME);
    
    end
end


end

