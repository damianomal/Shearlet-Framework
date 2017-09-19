function res = shearlet_dynamism_measure_save_for_testing(video_filename, scale, END_LIM)
%%

% load the video sequence
[VID, COLOR_VID] = load_video_to_mat(video_filename,160,1,100);

% calculate the 3D Shearlet Transform

clear COEFFS idxs
[COEFFS,idxs] = shearlet_transform_3D(VID,46,91,[0 1 1], 3, 1, [2 3]);

%%

weights = zeros(5,5);
u = [1 0 0];

for i=1:5
    for j=1:5
        v = shearlet_shearings_to_angle([i j], [5 5], 2, 1);
        weights(i,j) = sind(atan2d(norm(cross(u,v)),dot(u,v)))^2;
    end
end

weights(:,3) = 0;



%%

close all;
% 
% scale = 3;

t = 55;

th = 0.05;

res = zeros(size(COEFFS,1), size(COEFFS,2), 3, 51);

% END_LIM=90;

for t=10:END_LIM
    
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
    CCZ(CC < 0.01) = 0;
    
    res(:,:,:,t-9) = shearlet_overlay_mask(VID(:,:,t), CCZ > 0, false, true);
    
end
end

% VID_CUT = VID(:,:,10:END_LIM);


% %%
% 
% i = 1;
% 
% while true
%     
%     subplot(1,2,1);
%     imshow(VID_CUT(:,:,i), []);
%     subplot(1,2,2);
%     imshow(res(:,:,:,i));
%     
%     pause(0.040);
%     i = i + 1;
%     if (i > 51)
%         i = 1;
%     end
% end


