
s1 = struct('name', 'person04_boxing_d1_uncomp.avi', 'start', 1, 'end', 100);
s2 = struct('name', 'person01_walking_d1_uncomp.avi', 'start', 1, 'end', 100);
s3 = struct('name', 'person01_handwaving_d1_uncomp.avi', 'start', 1, 'end', 100);

s = {s1 s2 s3};

% KTH_20_centroids_scale2 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 20);
KTH_12_centroids_scale2 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 12);

%%

s1 = struct('name', '7-0006.mp4', 'start', 1, 'end', 100);
% s2 = struct('name', '7-0238.mp4', 'start', 80, 'end', 180);

s = {s1};

ASLAN_20_centroids_scale2 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 20, 2);
ASLAN_20_centroids_scale3 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 20, 3);

ASLAN_12_centroids_scale2 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 12, 2);
ASLAN_12_centroids_scale3 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 12, 3);


%%

s1 = struct('name', 'Sample0001_color.mp4', 'start', 1238, 'end', 1400);

s = {s1};

CHALEARN_20_centroids_scale2 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 20, 2);
CHALEARN_20_centroids_scale3 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 20, 3);

CHALEARN_12_centroids_scale2 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 12, 2);
CHALEARN_12_centroids_scale3 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 12, 3);


%%

s1 = struct('name', 'eating2_cam0.avi', 'start', 1, 'end', 100);

s = {s1};

EATING2CAM0_20_centroids_scale2 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 20, 2);
EATING2CAM0_20_centroids_scale3 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 20, 3);

EATING2CAM0_12_centroids_scale2 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 12, 2);
EATING2CAM0_12_centroids_scale3 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 12, 3);


%%

s1 = struct('name', 'eating2_cam1.avi', 'start', 1, 'end', 100);

s = {s1};

EATING2CAM1_20_centroids_scale2 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 20, 2);
EATING2CAM1_20_centroids_scale3 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 20, 3);

EATING2CAM1_12_centroids_scale2 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 12, 2);
EATING2CAM1_12_centroids_scale3 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 12, 3);


%%

s1 = struct('name', 'eating2_cam2.avi', 'start', 1, 'end', 100);

s = {s1};

EATING2CAM2_20_centroids_scale2 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 20, 2);
EATING2CAM2_20_centroids_scale3 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 20, 3);

EATING2CAM2_12_centroids_scale2 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 12, 2);
EATING2CAM2_12_centroids_scale3 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 12, 3);


%%

s1 = struct('name', 'eating2_cam0.avi', 'start', 1, 'end', 100);
s2 = struct('name', 'eating2_cam1.avi', 'start', 1, 'end', 100);
s3 = struct('name', 'eating2_cam2.avi', 'start', 1, 'end', 100);

s = {s1 s2 s3};

EATING2_20_centroids_scale2 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 20, 2);
EATING2_20_centroids_scale3 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 20, 3);

EATING2_12_centroids_scale2 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 12, 2);
EATING2_12_centroids_scale3 = shearlet_build_vocabulary_repr(s, 4, 0, 0, 12, 3);


%%

rows = 2;
cols = 3;

SHOW_DICT = KTH_20_centroids_scale2(:,:);

dim = size(SHOW_DICT,1);

if(dim > rows*cols)
    dim = rows*cols;
end

incr = 0;
redraw = true;

global fH1

if(isempty(fH1))
    fH1 = figure('Name','Bar Graph', 'Position', [726 554 560 420]);
else
    figure(fH1);
end


while true
    
    if(redraw)
        for i=1:dim
            
            subplot(rows,cols,i);
            shearlet_show_descriptor(SHOW_DICT(i+incr,:), i+incr, false);
            
        end
        
        redraw = false;
    end
    
    pause(0.5)
    current_key = uint8(get(gcf,'CurrentCharacter'));
    
    if(~isempty(current_key))
        switch current_key
            case 28
                incr = incr - 6;
                if(incr < 0)
                    incr = 0;
                end
                redraw = true;
            case 29
                incr = incr + 6;
                if(incr > size(SHOW_DICT,1) - 6)
                    incr = size(SHOW_DICT,1) - 6;
                end
                redraw = true;
                
        end
        
            set(gcf,'currentch',char(1))

    end
    
end

%%

close all
clear -global fH1 fH2
