

%% calculate the transform

clear VID 
video_filename = 'person04_boxing_d1_uncomp.avi';
[VID, COLOR_VID] = load_video_to_mat(video_filename,160,1,100);

%%

clear COEFFS idxs
[COEFFS,idxs] = shearlet_transform_3D(VID,46,91,[0 1 1], 3, 1, [2 3]);

%% compress a single shearlet wave

global particular_shearlet

to_compress = gather(particular_shearlet);

to_compress_r = real(to_compress);
to_compress_i = imag(to_compress);

mmax_r = max(to_compress_r(:));
mmin_r = min(to_compress_r(:));

compressed_r = ((to_compress_r-mmin_r)/(mmax_r-mmin_r));

mmax_i = max(to_compress_i(:));
mmin_i = min(to_compress_i(:));

compressed_i = ((to_compress_i-mmin_i)/(mmax_i-mmin_i));

compressed_uint16_r = uint16(compressed_r*65535);
compressed_uint16_i = uint16(compressed_i*65535);

compressed_uint8_r = uint8(compressed_r*255);
compressed_uint8_i = uint8(compressed_i*255);

fprintf('-------------------------------\n');

c = whos('to_compress');
fprintf('Shearlet, original size: %.3f GB (%.1f MB)\n', (1/1024/1024/1024)*c.bytes, (1/1024/1024)*c.bytes);

c_r = whos('compressed_uint16_r');
fprintf('Shearlet, uint16 size: %.3f GB (%.1f MB)\n', (1/1024/1024/1024)*c_r.bytes*2, (1/1024/1024)*c_r.bytes*2);

%% calculate the reconstruction error for that shearlet 

fprintf('-------------------------------\n');

recounstructed_r_uint16 = ((double(compressed_uint16_r) ./ 65535) .* (mmax_r-mmin_r)) + mmin_r;
diff_16 = abs(to_compress_r - recounstructed_r_uint16);

recounstructed_r_uint8 = ((double(compressed_uint8_r) ./ 255) .* (mmax_r-mmin_r)) + mmin_r;
diff_8 = abs(to_compress_r - recounstructed_r_uint8);

c_c = whos('recounstructed_r_uint16');
fprintf('Shearlet, reconstructed size (real part): %.3f GB (%.1f MB)\n', (1/1024/1024/1024)*c_c.bytes, (1/1024/1024)*c_c.bytes);

sz = size(VID,1) * size(VID,2) * size(VID,3);

fprintf('Shearlet, (reconstructed_uint16 - original) error: %.3f, avg_per_point: %.7f\n', sum(diff_16(:)), sum(diff_16(:)) / sz);
fprintf('Shearlet, (reconstructed_uint8 - original) error: %.3f, avg_per_point: %.7f\n', sum(diff_8(:)), sum(diff_8(:)) / sz);

