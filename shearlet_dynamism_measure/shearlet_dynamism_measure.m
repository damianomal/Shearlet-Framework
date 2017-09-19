function [ res, VID_CUT ] = shearlet_dynamism_measure( VID, COEFFS, idxs, scale, th, th2, START_IND, END_LIM)
%SHEARLET_DYNAMISM_MEASURE Summary of this function goes here
%   Detailed explanation goes here

weights = zeros(5,5);
u = [1 0 0];

for i=1:5
    for j=1:5
        v = shearlet_shearings_to_angle([i j], [5 5], 2, 1);
        weights(i,j) = sind(atan2d(norm(cross(u,v)),dot(u,v)))^2;
    end
end

weights(:,3) = 0;

weights

clear u v i j



%%
res = zeros(size(COEFFS,1), size(COEFFS,2), 3, END_LIM-START_IND+1);

for t=START_IND:END_LIM
    
    coeffs_mat = zeros(1, size(COEFFS,1)*size(COEFFS,2));
    c = zeros(5,5,3);

    for xx=2:size(COEFFS,1)-1
        if(xx > 2)
            fprintf(repmat('\b',1, numel(msg)));
        end
        
        msg = ['---- Processing row ' int2str(xx) '/' int2str(size(COEFFS,1)-1) ' frame: ' int2str(t) '/' int2str(END_LIM) ' '];
        fprintf(msg);
        
        row_index = (xx-1)*size(COEFFS,2);
        
        for yy=2:size(COEFFS,2)-1
            
            [c(:,:,1), c(:,:,2), c(:,:,3)] = shearlet_calculate_grids(COEFFS, xx, yy, t, scale, idxs, 1);
            
            [mx, ind] = max([max(reshape(c(:,:,1).',[],1))
                max(reshape(c(:,:,2).',[],1))
                max(reshape(c(:,:,3).',[],1))]);
            
            [ii, jj] = ind2sub(size(c(:,:,ind)), find(c(:,:,ind) == max(reshape(c(:,:,ind).',[],1))));
            
            if(mx > th)
                coeffs_mat(row_index+yy) = mx*weights(ii, jj);
            end
        end
    end
    
    
    fprintf('\n');
    
    CC = reshape(coeffs_mat, size(COEFFS,2), size(COEFFS,1));
    CC = CC';
    
    CCZ = CC;
    CCZ(CC < th2) = 0;
    
    res(:,:,:,t-START_IND+1) = shearlet_overlay_mask(VID(:,:,t), CCZ > 0, false, true);
    
end

VID_CUT = VID(:,:,START_IND:END_LIM);


end

