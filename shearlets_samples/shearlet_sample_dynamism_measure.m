
%%

% load the video sequence

clear VID
% video_filename = 'eating_cam0.avi'; % scala 2, frame 50, th 0.1
% [VID, COLOR_VID] = load_video_to_mat(video_filename,160,1,100, true);

% video_filename = 'alessia_rectangle.mp4';
% [VID, COLOR_VID] = load_video_to_mat(video_filename,160, 600,700, true);

% video_filename = 'person01_walking_d1_uncomp.avi';
video_filename = 'person04_boxing_d1_uncomp.avi';
[VID, COLOR_VID] = load_video_to_mat(video_filename,160,1,100, true);

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

clear u v i j

%%

% close all;

scale = 3;

% coeffs_mat = zeros(1, size(COEFFS,1)*size(COEFFS,2));

t = 37;

% c = zeros(5,5,3);

th = 0.02;

START_IND = 20;
END_LIM = 20;

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
    CCZ(CC < 0.01) = 0;
    
    res(:,:,:,t-START_IND+1) = shearlet_overlay_mask(VID(:,:,t), CCZ > 0, false, true);
    
end

VID_CUT = VID(:,:,START_IND:END_LIM);

figure;
imshow(res(:,:,:,1));

%%

i = 1;

while true
    
    subplot(1,2,1);
    imshow(VID_CUT(:,:,i), []);
    subplot(1,2,2);
    imshow(res(:,:,:,i));
    
    pause(0.040);
    i = i + 1;
    if (i > size(VID_CUT,3))
        i = 1;
    end
end

%%

% close all;

scale = 2;

t = 37;

th = 0.001;

START_IND = 2;
END_LIM = 40;

% res_values = zeros(size(COEFFS,1), size(COEFFS,2), END_LIM-START_IND+1);
res = zeros(size(COEFFS,1), size(COEFFS,2), 3, END_LIM-START_IND+1);
pesi = zeros(size(COEFFS,1), size(COEFFS,2), END_LIM-START_IND+1);

w = weights';

WE = w(:);
WE = [WE; WE; WE];

for t=START_IND:END_LIM
    
    %     t
    %     this_frame = squeeze(COEFFS(:,:,t,idxs(:,2) == scale));
    
    t
    this_frame = shearlet_average_shifted_coeffs( COEFFS, idxs, t, 1);
    this_frame = this_frame(:,:,idxs(:,2) == scale);

    C = reshape(this_frame,[size(COEFFS,1)*size(COEFFS,2) size(this_frame,3)]);
    
    [MX, MI] = max(C, [], 2);
    
    WEIG = WE(MI);
    
    MX(MX < th) = 0;
    
    %     res_values(:,:,t-START_IND+1) = reshape(MX .* WEIG, [size(COEFFS,1) size(COEFFS,2)]);
    
    reshaped = reshape(MX .* WEIG, [size(COEFFS,1) size(COEFFS,2)]);
    mmmask = reshaped > 0;
    WEIG(MX < th) = 0;
    
    pesi(:,:,t-START_IND+1) = reshape(WEIG, [size(COEFFS,1) size(COEFFS,2)]);
    res(:,:,:,t-START_IND+1) = shearlet_overlay_mask(VID(:,:,t), mmmask, false, true);
    
end

% figure; imshow(res, []);
% figure; imshow(VID(:,:,t), []);
% figure; imshow(reshape(MX .* WEIG, [size(COEFFS,1) size(COEFFS,2)]), []);

% %%
% 
% 
% 
% figure;
% 
% t=START_IND;
% 
% while true
%     
%     %     subplot(1,2,1);
%     %     imshow(VID(:,:,t), []);
%     %     subplot(1,2,2);
%     %     imshow(res(:,:,t-START_IND+1), []);
%     
%     imshow(res(:,:,:,t-START_IND+1), 'InitialMagnification', 400);
%     pause(0.04);
%     
%     t = t + 1;
%     
%     if(t > END_LIM)
%         t = START_IND;
%     end
%     
% end


%%

close all;

t = 78;

estimated_flow = zeros(size(COEFFS,1), size(COEFFS,2), 2);
color_coded = cat(3, VID(:,:,t), VID(:,:,t), VID(:,:,t));
color_coded_long = zeros(size(COEFFS,1), size(COEFFS,2), size(COEFFS,3), 3);


for tt = START_IND:END_LIM
    
    color_coded = cat(3, VID(:,:,tt), VID(:,:,tt), VID(:,:,tt));
    
    for xx=2:size(COEFFS,1)
        for yy=2:size(COEFFS,2)
            
%             if(squeeze(res(xx,yy,:,tt-START_IND+1)) == [1 0 0]')
%                 %             if(true)
% %                 [xx yy tt]
%                 [mx, mi] = max(squeeze(COEFFS(xx,yy,tt,:)));
%                 
%                 if(ismember(mi, c1))
%                     [ir, ic] = find(c1 == mi);
%                     if(ic < 3)
%                         %sx, rosso
%                         %                     estimated_flow(xx,yy,1) = -1;
%                         %                     estimated_flow(xx,yy,2) = 0;
%                         color_coded(xx,yy,:) = [255 0 0];
%                         %                         color_coded_long(xx,yy,t,:) = [255 0 0];
%                     end
%                     
%                     if(ic > 3)
%                         %dx, verde
%                         %                     estimated_flow(xx,yy,1) = 1;
%                         %                     estimated_flow(xx,yy,2) = 0;
%                         color_coded(xx,yy,:) = [0 255 0];
%                         %                         color_coded_long(xx,yy,t,:) = [0 255 0];
%                     end
%                 else
%                     if(ismember(mi, c3))
%                         [ir, ic] = find(c3 == mi);
%                         if(ic < 3)
%                             %giu, azzurro
%                             %                         estimated_flow(xx,yy,1) = 0;
%                             %                         estimated_flow(xx,yy,2) = 1;
%                             color_coded(xx,yy,:) = [0 120 255];
%                             %                             color_coded_long(xx,yy,t,:) = [0 0 255];
%                             
%                         end
%                         if(ic > 3)
%                             %su, giallo
%                             %                         estimated_flow(xx,yy,1) = 0;
%                             %                         estimated_flow(xx,yy,2) = -1;
%                             color_coded(xx,yy,:) = [255 255 0];
%                             %                             color_coded_long(xx,yy,t,:) = [255 255 0];
%                         end
%                         
%                     else
%                         if(ismember(mi, c2))
%                             [ir, ic] = find(c2 == mi);
%                             if(ic < 3)
%                                 %giu, azzurro
%                                 %                         estimated_flow(xx,yy,1) = 0;
%                                 %                         estimated_flow(xx,yy,2) = 1;
%                                 color_coded(xx,yy,:) = [0 120 255];
%                                 %                             color_coded_long(xx,yy,t,:) = [0 0 255];
%                                 
%                             end
%                             if(ic > 3)
%                                 %su, giallo
%                                 %                         estimated_flow(xx,yy,1) = 0;
%                                 %                         estimated_flow(xx,yy,2) = -1;
%                                 color_coded(xx,yy,:) = [255 255 0];
%                                 %                             color_coded_long(xx,yy,t,:) = [255 255 0];
%                             end
%                         end
%                         
%                     end
%                     
%                     
%                 end
%                 
%             end
            
            if(squeeze(res(xx,yy,:,tt-START_IND+1)) == [1 0 0]')
                %             if(true)
%                 [xx yy tt]
                [mx, mi] = max(squeeze(COEFFS(xx,yy,tt,:)));
                
                if(ismember(mi, c1))
                    [ir, ic] = find(c1 == mi);
                    if(ic < 3)
                        %sx, rosso
                        %                     estimated_flow(xx,yy,1) = -1;
                        %                     estimated_flow(xx,yy,2) = 0;
                        color_coded(xx,yy,:) = [255 0 0];
                        %                         color_coded_long(xx,yy,t,:) = [255 0 0];
                    end
                    
                    if(ic > 3)
                        %dx, verde
                        %                     estimated_flow(xx,yy,1) = 1;
                        %                     estimated_flow(xx,yy,2) = 0;
                        color_coded(xx,yy,:) = [0 255 0];
                        %                         color_coded_long(xx,yy,t,:) = [0 255 0];
                    end
                else
                    if(ismember(mi, c3))
                        [ir, ic] = find(c3 == mi);
                        if(ic < 3)
                            %giu, azzurro
                            %                         estimated_flow(xx,yy,1) = 0;
                            %                         estimated_flow(xx,yy,2) = 1;
                            color_coded(xx,yy,:) = [0 120 255];
                            %                             color_coded_long(xx,yy,t,:) = [0 0 255];
                            
                        end
                        if(ic > 3)
                            %su, giallo
                            %                         estimated_flow(xx,yy,1) = 0;
                            %                         estimated_flow(xx,yy,2) = -1;
                            color_coded(xx,yy,:) = [255 255 0];
                            %                             color_coded_long(xx,yy,t,:) = [255 255 0];
                        end
                        
                    else
                        if(ismember(mi, c2))
                            [ir, ic] = find(c2 == mi);
                            if(ic < 3)
                                %giu, azzurro
                                %                         estimated_flow(xx,yy,1) = 0;
                                %                         estimated_flow(xx,yy,2) = 1;
                                color_coded(xx,yy,:) = [0 120 255];
                                %                             color_coded_long(xx,yy,t,:) = [0 0 255];
                                
                            end
                            if(ic > 3)
                                %su, giallo
                                %                         estimated_flow(xx,yy,1) = 0;
                                %                         estimated_flow(xx,yy,2) = -1;
                                color_coded(xx,yy,:) = [255 255 0];
                                %                             color_coded_long(xx,yy,t,:) = [255 255 0];
                            end
                        end
                        
                    end
                    
                    
                end
                
            end
            
        end
    end
    
    %     figure;
    subplot(1,3,1);
    imshow(res(:,:,:,tt-START_IND+1));
    subplot(1,3,2);
    imshow(color_coded ./ 255);
    subplot(1,3,3);
    imshow(pesi(:,:,tt-START_IND+1), []);
    pause(0.01);
    
end



%%

% %%
%
% close all;
%
% scale = 2;
%
% coeffs_mat = zeros(1, size(COEFFS,1)*size(COEFFS,2));
%
% t = 55;
%
% c = zeros(5,5,3);
%
% th = 0.1;
%
% % for t=2:size(COEFFS,3)-1
% for xx=2:size(COEFFS,1)-1
%     if(xx > 2)
%         fprintf(repmat('\b',1, numel(msg)));
%     end
%
%     msg = ['---- Processing row ' int2str(xx) '/' int2str(size(COEFFS,1)-1) ' '];
%     fprintf(msg);
%
%     row_index = (xx-1)*size(COEFFS,2);
%
%     for yy=2:size(COEFFS,2)-1
%
%         [c(:,:,1), c(:,:,2), c(:,:,3)] = shearlet_calculate_grids(COEFFS, xx, yy, t, scale, idxs, 1);
%
%         [mx, ind] = max([max(reshape(c(:,:,1).',[],1))
%             max(reshape(c(:,:,2).',[],1))
%             max(reshape(c(:,:,3).',[],1))]);
%
%         [ii, jj] = ind2sub(size(c(:,:,ind)), find(c(:,:,ind) == max(reshape(c(:,:,ind).',[],1))));
%
%         if(mx > th)
%             coeffs_mat(row_index+yy) = mx*weights(ii, jj);
%         end
%     end
% end
%
% % end
% fprintf('\n');
%
% %%
%
% CC = reshape(coeffs_mat, size(COEFFS,2), size(COEFFS,1));
% CC = CC';
%
% CCZ = CC;
% CCZ(CC < 0.02) = 0;
%
% res = shearlet_overlay_mask(VID(:,:,t), CCZ > 0, false, true);
%
% close all;
% figure;
% subplot(1,3,1); imshow(CC, []);
% subplot(1,3,2); imshow(CCZ, []); colormap(hot(256));
% subplot(1,3,3); imshow(res);

