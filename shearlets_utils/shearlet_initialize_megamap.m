function  shearlet_initialize_megamap(sz, idxs)
%SHEARLET_INITIALIZE_MEGAMAP Summary of this function goes here
%   Detailed explanation goes here

global MEGAMAP real_indexes fake_indexes

MEGAMAP = zeros(75,3,121);

real_indexes = cell(1,3);
fake_indexes = cell(1,3);

for scale_chosen=2:3
    
    dummy_matrix = zeros(sz(1),sz(2),sz(4));
    
    for i = 1:3
        for j = 1:3
            dummy_matrix(i,j,:) = 1:size(dummy_matrix, 3);
        end
    end
    
    [c1, c2, c3] = shearlet_dummy_calculate_grids(dummy_matrix, 2, 2, 2, scale_chosen, idxs, 0);
    
    Z = zeros(5,5);
    
    res_v = shearlet_create_indexes_matrix;
    
    cc1 = c1';
    cc2 = c2';
    cc3 = c3';
    
    real_indexes{scale_chosen} = [cc1(:); cc2(:); cc3(:)];
    
    cc1 = flip(c1, 2)';
    cc2 = flip(c2, 2)';
    cc3 = flip(c3, 2)';
    
    fake_indexes{scale_chosen} = [cc1(:); cc2(:); cc3(:)];
    
    mask = zeros(15,15);
    
    mask(6:10, 3:13) = 1;
    mask(3:13, 6:10) = 1;
    
    
    %%
    
    for indice=1:75
        
        MBIG = [Z, Z, Z;
            Z, c1, c2;
            Z, c3, Z];
        
        [ir, ic] = find(MBIG == real_indexes{scale_chosen}(indice));
        
        ind = floor((indice-1)/25)+1;
        
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
        
        MEGAMAP(indice, scale_chosen,:) = res(1:121);
        
    end
    
end



end

