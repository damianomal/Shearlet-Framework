function big_map = shearlet_create_representation_mapping( coeffs, idxs, scale)
%SHEARLET_CREATE_REPRESENTATION_MAPPING Summary of this function goes here
%   Detailed explanation goes here

dummy_matrix = zeros(size(coeffs,1),size(coeffs,2),size(coeffs,4));

for i = 1:size(dummy_matrix,1)
    for j = 1:size(dummy_matrix,2)
        dummy_matrix(i,j,:) = 1:size(dummy_matrix, 3);
    end
end


% calc_index_mats;

coeffslong = zeros(1,225);
coeffslong(1:121) = 1:121;




INDM = zeros(15,15);
INDM(8,8)=1;

ind = 1;
vars = [0 1; 1 0; 0 -1; -1 0; 0 1];

for step=1:7
    
    i = 8-step;
    j = 8;
    
    %     INDM
    %     pause;
    
    var_ind = 1;
    
    for var_ind =1:4
        
        while(INDM(i+vars(var_ind+1,1), j + vars(var_ind+1,2)) ~= 0)
            
            
            ind = ind + 1;
            
            INDM(i,j) = ind;
            
            i = i + vars(var_ind,1);
            j = j + vars(var_ind,2);
            
        end
        
        
    end
    
    while(step > 1 && INDM(i,j) == 0)
        
        ind = ind + 1;
        INDM(i,j) = ind;
        j = j +1;
        
    end
    
end

% INDM

res_v = zeros(15*15,1);

for i=1:15*15
    [r,c] = find(INDM == i);
    res_v(i) = sub2ind([15 15], r, c);
end



c = cell(1,3);

Z = zeros(5,5);

mask = zeros(15,15);

mask(6:10, 3:13) = 1;
mask(3:13, 6:10) = 1;





for i=1:3
    
    CONO = idxs(idxs(:,1) == i, :);
    SCALA = CONO(CONO(:,2) == scale, :);
    M = numel(unique(SCALA(:,3)));
    N = numel(unique(SCALA(:,4)));
    
    % FIX: TODO controllare se visualizza giusto ora
    SCALA(:,4) = - SCALA(:,4);
    
    these_coeffs = coeffslong(idxs(:,1) == i & idxs(:,2) == scale);
    
    %         MAT = zeros(M, N);
    c{i} = zeros(M, N);
    
    
    if(min(SCALA(:,3)) <= 0)
        SCALA(:,3) = SCALA(:,3) + abs(min(SCALA(:,3))) + 1;
    end
    
    if(min(SCALA(:,4)) <= 0)
        SCALA(:,4) = SCALA(:,4) + abs(min(SCALA(:,4))) + 1;
    end
    
    for j=1:M*N
        %             MAT(SCALA(j,3), SCALA(j,4)) = these_coeffs(j);
        c{i}(SCALA(j,3), SCALA(j,4)) = these_coeffs(j);
    end
    
    %         square_mats{i, scale} = MAT;
    
end

% [c1, c2, c3] = shearlet_calculate_grids(coeffs, 2, 2, 2, scale, idxs, 1);

% c1 = square_mats{1, scale_chosen};
% c2 = square_mats{2, scale_chosen};
% c3 = square_mats{3, scale_chosen};

% #tapullo #genovamorethanthis
c1 = c{1};
c2 = c{2};
c3 = c{3};


real_indexes = [c1(:); c2(:); c3(:)];
%     pause

MBIG = [Z, Z, Z;
    Z, c1, c2;
    Z, c3, Z];

% [~, xx] = max([c1(:); c2(:); c3(:)]);

MEGAMAP = zeros(75,3,121);

scale_chosen = scale;

for indice=1:75
    
    MBIG = [Z, Z, Z;
        Z, c1, c2;
        Z, c3, Z];
    
    %         [ir, ic] = find(MBIG == indice);
    indice
    [ir, ic] = find(MBIG == real_indexes(indice));
    
    ind = floor((indice-1)/25)+1;
    
    shiftr = 8 - ir;
    shiftc = 8 - ic;
    
    switch ind
        
        case 1
            MBIG = [c3, c3, c3;
                c2, c1, c2;
                c3, c3, c3];
            
            MBIG = circshift(MBIG,shiftc, 2);
            
            MBIG(1:5, 6:10) = MBIG(11:15, 6:10);
            
            MBIG(1:5, 11:15) = MBIG(6:10, 11:15);
            MBIG(11:15, 11:15) = MBIG(6:10, 11:15);
            
            MBIG(1:5, 1:5) = MBIG(6:10, 1:5);
            MBIG(11:15, 1:5) = MBIG(6:10, 1:5);
            
            MBIG = circshift(MBIG,shiftr, 1);
            
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
            
            MBIG = circshift(MBIG,shiftr, 1);
            
            MBIG(6:10, 1:5) = MBIG(6:10, 11:15);
            
            MBIG(1:5, 1:5) = MBIG(1:5, 6:10);
            MBIG(1:5, 11:15) = MBIG(1:5, 6:10);
            
            MBIG(11:15, 1:5) = MBIG(11:15, 6:10);
            MBIG(11:15, 11:15) = MBIG(11:15, 6:10);
            
            MBIG = circshift(MBIG,shiftc, 2);
            
    end
    
    res_u = MBIG.*mask;
    res_u = res_u(:);
    
    res = res_u(res_v);
    %     indice = (xx-1)*size(imm,2)+yy;
    
    MEGAMAP(indice, scale_chosen,:) = res(1:121);
    
end

end

