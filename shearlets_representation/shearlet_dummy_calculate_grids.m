function [ c1, c2, c3 ] = shearlet_dummy_calculate_grids( big_coeffs, x, y, t, scale, shearletIdxs, win)
%   Detailed explanation goes here

global square_mats

if(nargin < 7)
    win = 1;
end

xwin =  uint8(x-win:x+win);
ywin =  uint8(y-win:y+win);
twin =  uint8(t-win:t+win);

% if(~exist('calculate_map'))
%     calculate_map = false;
% end

% coeffslong = zeros(size(shearletIdxs,1), size(big_coeffs,3));

% for j = 1:size(shearletIdxs,1)
%     
%     res = abs(big_coeffs(xwin, ywin, twin, j));
%     res = squeeze((sum(sum(sum(res,1),2),3)));
%     coeffslong(j) = big_coeffs(xwin, ywin, twin;
%     
% end

coeffslong = 1:size(shearletIdxs,1);

if(isempty('square_mats'))
    square_mats = cell(3,3);
end

for i=1:3
    %     for scale=scale_chosen:scale_chosen
    
    CONO = shearletIdxs(shearletIdxs(:,1) == i, :);
    SCALA = CONO(CONO(:,2) == scale, :);
    M = numel(unique(SCALA(:,3)));
    N = numel(unique(SCALA(:,4)));
    
    %% FIX: TODO controllare se visualizza giusto ora
     SCALA(:,4) = - SCALA(:,4);
    
    these_coeffs = coeffslong(shearletIdxs(:,1) == i & shearletIdxs(:,2) == scale);
    
    %         MAT = zeros(M, N);
    square_mats{i, scale} = zeros(M, N);
    
    
    if(min(SCALA(:,3)) <= 0)
        SCALA(:,3) = SCALA(:,3) + abs(min(SCALA(:,3))) + 1;
    end
    
    if(min(SCALA(:,4)) <= 0)
        SCALA(:,4) = SCALA(:,4) + abs(min(SCALA(:,4))) + 1;
    end
    
    for j=1:M*N
        %             MAT(SCALA(j,3), SCALA(j,4)) = these_coeffs(j);
        square_mats{i, scale}(SCALA(j,3), SCALA(j,4)) = these_coeffs(j);
    end
    
    %         square_mats{i, scale} = MAT;
    
    %     end
end

c1 = square_mats{1, scale};
c2 = square_mats{2, scale};
c3 = square_mats{3, scale};
end

