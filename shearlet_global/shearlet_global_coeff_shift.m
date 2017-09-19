function [ result ] = shearlet_global_coeff_shift(big_coeffs, idxs, t_centr, win)
%SHEARLET_GLOBAL_COEFF_SHIFT Summary of this function goes here
%   Detailed explanation goes here

global shifted

if(isempty(shifted))
    
    shifted = zeros(size(big_coeffs,1),size(big_coeffs,2), size(idxs,1), (1+2*win)^3);
    
    for t=t_centr-win:t_centr+win
        
        base_ind = ((1+2*win)^2)*mod(t,3);
        c = 1;
        
        base = squeeze(big_coeffs(:,:,t,:));
        
        for i=-win:win
            temp = circshift(base, i, 1);
            for j=-win:win
                shifted(:,:,:,base_ind+c) = circshift(temp, j, 2);
                c = c + 1;
            end
        end
        
    end
    
else
    
    for t=t_centr+1:t_centr+win
        
        base_ind = ((1+2*win)^2)*mod(t,3);
        c = 1;
        
        base = squeeze(big_coeffs(:,:,t,:));
        
        for i=-win:win
            temp = circshift(base, i, 1);
            for j=-win:win
                shifted(:,:,:,base_ind+c) = circshift(temp, j, 2);
                c = c + 1;
            end
        end
        
    end
    
end

result = mean(shifted, 4);

end

