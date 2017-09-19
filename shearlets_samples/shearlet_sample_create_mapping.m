

%%

clear VID

% video_filename = 'mixing3_cam0.avi';
% video_filename = 'person04_boxing_d1_uncomp.avi';
% VID = load_video_to_mat(video_filename,160,1,100);

video_filename = 'line_l.mp4';
VID = load_video_to_mat(video_filename,160,400,500);



clear COEFFS idxs

% calculate the 3D Shearlet Transform

clear COEFFS idxs
[COEFFS,idxs] = shearlet_transform_3D(VID,46,91,[0 1 1], 3, 1, [2 3]);


%%

TARGET_FRAME = 37;
SCALE_USED = 2;

REPRESENTATION = shearlet_descriptor_fast(COEFFS, TARGET_FRAME, SCALE_USED, idxs, true, true);


%%

scale_chosen = 2;

dummy_matrix = zeros(size(COEFFS,1),size(COEFFS,2),size(COEFFS,4));

for i = 1:3
    for j = 1:3
        dummy_matrix(i,j,:) = 1:size(dummy_matrix, 3);
    end
end

% xx = 2;
% yy = 2;
%
% calc_index_mats;
%
% c1 = square_mats{1, scale_chosen};
% c2 = square_mats{2, scale_chosen};
% c3 = square_mats{3, scale_chosen};

[c1, c2, c3] = shearlet_dummy_calculate_grids(dummy_matrix, 2, 2, 2, scale_chosen, idxs, 0);
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
%     pause

% MBIG = [Z, Z, Z;
%     Z, c1, c2;
%     Z, c3, Z];

mask = zeros(15,15);

mask(6:10, 3:13) = 1;
mask(3:13, 6:10) = 1;

%%

global MEGAMAP

MEGAMAP = zeros(75,3,121);

%%


st = tic;

for indice=1:75
    
    MBIG = [Z, Z, Z;
        Z, c1, c2;
        Z, c3, Z];
    
    %         [ir, ic] = find(MBIG == indice);
    [ir, ic] = find(MBIG == real_indexes(indice));
    
    ind = floor((indice-1)/25)+1;
    
    %     if(indice < 26)
    %         ind = 1;
    %     else
    %         if(indice < 51)
    %             ind = 2;
    %         else
    %             ind =3;
    %         end
    %     end
    
    shiftr = 8 - ir;
    shiftc = 8 - ic;
    
    switch ind
        
        case 1
            MBIG = [c3, c3, c3;
                c2, c1, c2;
                c3, c3, c3];
            
            %         figure; imshow(MBIG, [0 max(MBIG(:))]);
            
            MBIG = circshift(MBIG,shiftc, 2);
            
            %         figure; imshow(MBIG, [0 max(MBIG(:))]);
            
            MBIG(1:5, 6:10) = MBIG(11:15, 6:10);
            
            MBIG(1:5, 11:15) = MBIG(6:10, 11:15);
            MBIG(11:15, 11:15) = MBIG(6:10, 11:15);
            
            MBIG(1:5, 1:5) = MBIG(6:10, 1:5);
            MBIG(11:15, 1:5) = MBIG(6:10, 1:5);
            
            
            MBIG = circshift(MBIG,shiftr, 1);
            
            %         figure; imshow(MBIG, [0 max(MBIG(:))]);
            
        case 2
            
            MBIG = [c3, c3, c3;
                c1, c1, c2;
                c3, c3, c3];
            
            MBIG = circshift(MBIG,shiftc, 2);
            
            MBIG(1:5, 6:10) = MBIG(11:15, 6:10);
            
            MBIG(1:5, 11:15) = MBIG(6:10, 11:15);
            MBIG(11:15, 11:15) = MBIG(6:10, 11:15);
            
            MBIG(1:5, 1:5) = MBIG(6:10, 1:5);
            MBIG(11:15, 1:5) = MBIG(6:10, 1:5);
            
            
            MBIG = circshift(MBIG,shiftr, 1);
            
        case 3
            
            MBIG = [c2, c1, c2;
                c2, c1, c2;
                c2, c3, c2];
            
            %                 figure; imshow(MBIG, [0 max(MBIG(:))]);
            
            MBIG = circshift(MBIG,shiftr, 1);
            
            %                 figure; imshow(MBIG, [0 max(MBIG(:))]);
            
            MBIG(6:10, 1:5) = MBIG(6:10, 11:15);
            
            MBIG(1:5, 1:5) = MBIG(1:5, 6:10);
            MBIG(1:5, 11:15) = MBIG(1:5, 6:10);
            
            MBIG(11:15, 1:5) = MBIG(11:15, 6:10);
            MBIG(11:15, 11:15) = MBIG(11:15, 6:10);
            
            MBIG = circshift(MBIG,shiftc, 2);
            
            %                 figure; imshow(MBIG, [0 max(MBIG(:))]);
            
    end
    
    res_u = MBIG.*mask;
    res_u = res_u(:);
    
    res = res_u(res_v);
    
    %     keyboard
    MEGAMAP(indice, scale_chosen,:) = res(1:121);
    
    if(MEGAMAP(indice, scale_chosen, 1) ~= real_indexes(indice));
        indice
    end
    %     keyboard
    
end

fprintf('---- Processing time to create the mapping: %i ms.\n', round(toc(st)*1000));



%%

close all;

time_ind = 37;
% scale_chosen = 2;

% th = 0.06;
th = 0;

imm = VID(:,:,time_ind);

if(~exist('Z', 'var'))
    Z = zeros(5,5);
end

if(~exist('res_v', 'var'))
    create_indexes;
end

REPRESENTATION = zeros(size(imm,1)*size(imm,2), 121);

% mask = zeros(15,15);

% mask(6:10, 3:13) = 1;
% mask(3:13, 6:10) = 1;

count = 0;
count_cor = 0;

win = 1;

cc1 = flip(c1, 2)';
cc2 = flip(c2, 2)';
cc3 = flip(c3, 2)';

fake_indexes = [cc1(:); cc2(:); cc3(:)];

% errors = zeros(1, size(idxs, 1));
% correct = zeros(1, size(idxs, 1));


%% averaging first step

tic;

base = squeeze(COEFFS(:,:,time_ind,:));

shifted = zeros(size(imm,1),size(imm,2), size(idxs,1), 27);

shifted(:,:,:,1) = COEFFS(:,:,time_ind,:);

c = 2;

for i=-1:1
    temp = circshift(base, i, 1);
    for j=-1:1
        shifted(:,:,:,c) = circshift(temp, j, 2);
        c = c + 1;
    end
end

base = squeeze(COEFFS(:,:,time_ind-1,:));

for i=-1:1
    temp = circshift(base, i, 1);
    for j=-1:1
        shifted(:,:,:,c) = circshift(temp, j, 2);
        c = c + 1;
    end
end

base = squeeze(COEFFS(:,:,time_ind+1,:));

for i=-1:1
    temp = circshift(base, i, 1);
    for j=-1:1
        shifted(:,:,:,c) = circshift(temp, j, 2);
        c = c + 1;
    end
end

COEFFS_SHIFT = mean(shifted, 4);

toc;

%%

st = tic;

for xx=2:size(imm,1)-1
    
    %     fprintf('Processing row: %d..\n', xx);
    
    for yy=2:size(imm,2)-1
        
        [~, ii] = max(abs(COEFFS_SHIFT(xx, yy, idxs(:,2) == scale_chosen)));
        
        ii = find(fake_indexes == real_indexes(ii));
        
        coeff_order = squeeze(MEGAMAP(ii,scale_chosen,:));
        coeff_order(coeff_order == 0) = 1;
        
        res = abs(COEFFS_SHIFT(xx, yy, coeff_order));
        
        res(MEGAMAP(ii,scale_chosen,:) == 0) = 0;
        
        REPRESENTATION((xx-1)*size(COEFFS,2)+yy,:) = res;
        
        %         if(res(1) ~= max(res))
        %             count = count + 1;
        %             errors(real_indexes(ii)) = errors(real_indexes(ii)) + 1;
        %             %             figure(1);
        %             %             real_indexes(ii)
        %             %             bar(res(:));
        %             %             pause;
        %         else
        %             count_cor = count_cor + 1;
        %             correct(real_indexes(ii)) = correct(real_indexes(ii)) + 1;
        %
        %         end
        
    end
end

% fprintf('\n---- Processing time: %i ms, errors: %d.\n', round(toc(st)*1000), count);
fprintf('\n---- Processing time: %i ms.\n', round(toc(st)*1000));

% if(count > 1)
%     [Y, I] = sort(errors, 2, 'descend');
%
%     for i = 1:10
%         fprintf('---- Most errors in: %d, %d times, %d are correct.\n', I(i), Y(i), correct(I(i)));
%     end
%
% end

%%

REPRESENTATION(1:2, :) = REPRESENTATION(3:4,:);
REPRESENTATION(end-1:end, :) = REPRESENTATION(end-3:end-2,:);

%%

CLUSTER_NUMBER = 8;
[CL_IND, CTRS] = shearlet_cluster_coefficients(REPRESENTATION, CLUSTER_NUMBER, [size(COEFFS,1) size(COEFFS,2)]);

% sorts the clusters with respect to their size, and also rea

[SORTED_CL_IMAGE, SORT_CTRS] = shearlet_cluster_sort(CL_IND, CTRS);

% shows a colormap associated with the clusters found

shearlet_cluster_image(SORTED_CL_IMAGE, CLUSTER_NUMBER, true, false);

