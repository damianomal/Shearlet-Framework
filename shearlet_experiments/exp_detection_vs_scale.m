video_filename = 'person04_boxing_d1_uncomp.avi';
[VID, COLOR_VID] = load_video_to_mat(video_filename,160,1,100, true);

clear COEFFS idxs
[COEFFS,idxs] = shearlet_transform_3D(VID,46,91,[0 1 1], 3, 1, [2 3]);

%%

% parameters for the detection process
LOWER_THRESHOLD = 0.5;
SPT_WINDOW = 7;
SCALES = 2;
CONE_WEIGHTS = [1 1 1];

close all;

% output_name = ['IBPRIA/' shearlet_create_video_outname( video_filename, SCALES, LOWER_THRESHOLD, SPT_WINDOW, CONE_WEIGHTS)];
[COORDINATES_SCALE2, CHANGE_MAP_SCALE2] = shearlet_detect_points( VID(:,:,1:91), COEFFS, SCALES, [], LOWER_THRESHOLD, SPT_WINDOW, CONE_WEIGHTS, false);


%%

LOWER_THRESHOLD = 0.1;
SPT_WINDOW = 7;
SCALES = 3;
CONE_WEIGHTS = [1 1 1];

close all;

% output_name = ['IBPRIA/' shearlet_create_video_outname( video_filename, SCALES, LOWER_THRESHOLD, SPT_WINDOW, CONE_WEIGHTS)];
[COORDINATES_SCALE3, CHANGE_MAP_SCALE3] = shearlet_detect_points( VID(:,:,1:91), COEFFS, SCALES, [], LOWER_THRESHOLD, SPT_WINDOW, CONE_WEIGHTS, false);

%%

i2 = COORDINATES_SCALE2(:,1);
j2 = COORDINATES_SCALE2(:,2);
k2 = COORDINATES_SCALE2(:,3);

i3 = COORDINATES_SCALE3(:,1);
j3 = COORDINATES_SCALE3(:,2);
k3 = COORDINATES_SCALE3(:,3);

c=2;

%
repeated_frames = 5;

figure;

win = 3;

% cycle over the whole sequence
while true
        
    % selects the points found in the current frame
    if(win >= 0)
        id2 = find(abs(k2-c)<=win);
        id3 = find(abs(k3-c)<=win);
    else
        id2 = find(k2==c);
        id3 = find(k3==c);
    end
    
    % showing the current frame in the sequence
    %     subplot(1,num_plots,1);
    if(size(VID,3) == 3)
        imshow(VID(:,:,:,c), []);
    else
        imshow(VID(:,:,c), []);
    end
        
    %
    if(size(id2,1) > 0)
        hold on
        plot(j2(id2), i2(id2), 'ro', 'MarkerSize', 20, 'LineWidth', 5);
        hold off
    end
    
    if(size(id3,1) > 0)
        hold on
        plot(j3(id3), i3(id3), 'bo', 'MarkerSize', 20, 'LineWidth', 5);
        hold off
    end
    
    % sets a small pause, then increases the
    % current frame counter
    pause(0.04);
    c = c + 1;
    
    % if the end of the sequence has been reached,
    % exits the loop (the commented line should be
    % swapped with the one below it, in case the user
    % wants to see the sequence looping)
    if(((size(VID,3) > 3) &&  c >= size(VID,3)) || ((size(VID,3) == 3) &&  c >= size(VID,4)))
        c=2;
%         break;
    end
    
end


%%
