function [ mat ] = shearlet_grids_to_matrix( c1, c2, c3 )
%SHEARLET_GRIDS_TO_MATRIX Summary of this function goes here
%   Detailed explanation goes here

global descr_mask

m1 = max(c1(:));
m2 = max(c2(:));
m3 = max(c3(:));

Z = zeros(5,5);

% 
if(isempty(descr_mask))
    descr_mask = zeros(15,15);
    
    descr_mask(6:10, 3:13) = 1;
    descr_mask(3:13, 6:10) = 1;
end

%% to write

% st = tic;

[~, ind] = max([m1 m2 m3]);

MBIG = [Z, Z, Z;
    Z, c1, c2;
    Z, c3, Z];

[ir, ic] = find(MBIG == max(MBIG(:)));

% times(2) = toc(st);


% st = tic;

shiftr = 8 - ir;
shiftc = 8 - ic;


% summed = [5 5; 5 10; 10 5];

% ind 

shiftc = shiftc(1);
shiftr = shiftr(1);
        
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


mat = MBIG .* descr_mask;

end

