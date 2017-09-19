function [ shifted ] = shearlet_average_shifted_coeffs( big_coeffs, idxs, t_centr, win )
%SHEARLET_AVERAGE_SHIFTED_COEFFS Summary of this function goes here
%   Detailed explanation goes here

shifted = zeros(size(big_coeffs,1),size(big_coeffs,2), size(idxs,1), (1+2*win)^3);

% shifted(:,:,:,1) = big_coeffs(:,:,t,:);

c = 1;

for t=t_centr-win:t_centr+win
    
    base = squeeze(big_coeffs(:,:,t,:));
    
    for i=-win:win
        temp = circshift(base, i, 1);
        for j=-win:win
            shifted(:,:,:,c) = circshift(temp, j, 2);
            c = c + 1;
        end
    end
    
end

% base = squeeze(big_coeffs(:,:,t-1,:));
% 
% for i=-win:win
%     temp = circshift(base, i, 1);
%     for j=-win:win
%         shifted(:,:,:,c) = circshift(temp, j, 2);
%         c = c + 1;
%     end
% end
% 
% base = squeeze(big_coeffs(:,:,t+1,:));
% 
% for i=-win:win
%     temp = circshift(base, i, 1);
%     for j=-win:win
%         shifted(:,:,:,c) = circshift(temp, j, 2);
%         c = c + 1;
%     end
% end

shifted = mean(shifted, 4);

end

