

close all;

% VIDW = load_video_to_mat('person01_walking_d1_uncomp.avi',160, 1,100); %parametri 1 e 7
% BG = VIDW(:,:,3);

load kth_bg_averaged.mat

BG = bg_averaged;

VID = load_video_to_mat('person04_boxing_d1_uncomp.avi',160, 1,200); % parametri 1.5 e 5
% VID = load_video_to_mat('person01_handclapping_d4_uncomp.avi',160, 1,200); % parametri 1.5 e 5
% VID = load_video_to_mat('person01_walking_d1_uncomp.avi',160, 1,100);
% VID = load_video_to_mat('person01_running_d1_uncomp.avi',160, 1,100);
% VID = load_video_to_mat('person01_walking_d1_uncomp.avi',160, 1,100); %parametri 1 e 7

LIMIT = size(VID,3);
LIMIT = 100;

VID(:,:,1) = BG;
VID(:,:,LIMIT) = BG;


VID2 = abs(VID - repmat(BG,1,1,size(VID, 3)));
VID2 = permute(VID2, [2 1 3]);

RES = zeros(size(VID2));

for t=1:size(VID,3)
%     VID2(:,:,t) = imgaussfilt(VID2(:,:,t), 5);
   RES(:,:,t) = bwareafilt(VID2(:,:,t) > 50,1);
   
%        RES(:,:,t) = imgaussfilt(RES(:,:,t), 1);

   
end

fH = figure('Position', [680 558 1035 420]); 



subplot(1,2,2);
hold on;
% camlight
p = patch(isosurface(RES(:,:,1:LIMIT), 0));
% p = patch(isosurface(RES, 0));
% p.FaceColor = 'cyan';
% p.FaceColor = [0.2 0.2 0.9];
 p.FaceColor = [0.2 0.25 0.8];
p.EdgeColor = 'none';
camlight;




 
 
 hold off;

 axis off
 
% view([-48 45]);
% view([58.4 58.8]);
view([76.4000 63.6]);

i = 90;
step = -1;
t = 1;

% vidOut = VideoWriter('handclapping_moving.avi');
% vidOut.Quality = 100;
% vidOut.FrameRate = 25;

% open(vidOut);

count_loop = 0;

while true   
    
    subplot(1,2,1);
    imshow(VID(:,:,t), []);
    
    subplot(1,2,2);
    view([ i i]);
%     pause(0.04);
    pause(0.00001);
    
    i = i + step;
    
    if(step == -1 && i == 35)
        step = 1;
    else
        if(step == 1 && i == 90)
            step = -1;
            count_loop = count_loop + 1;
        end
    end
    
    t = t+1;
    
%     count_loop
    
    if(count_loop == 3)
        break; 
    end
    
    if(t > size(RES,3))
       t = 1; 
    end
    
    fg = getframe(gcf);
%     writeVideo(vidOut, fg.cdata(50:359, 113:923, :));
   
    key = get(gcf,'CurrentKey');
    
    if(strcmp (key , 'q'))
        break;
    end
    
end

% close(vidOut);

