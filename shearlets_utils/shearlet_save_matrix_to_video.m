function shearlet_save_matrix_to_video( DATA, output_file, framerate )
%SHEARLET_SAVE_MATRIX_TO_VIDEO Summary of this function goes here
%   Detailed explanation goes here

vidOut = VideoWriter(output_file);
vidOut.Quality = 100;
vidOut.FrameRate = framerate;

open(vidOut);


fH = figure('Name','Video To Save','visible','off');
axis image off;
set(gca,'position',[0 0 1 1],'units','normalized');

% a = gca;
% set(a,'box','off','color','none')
% 
% b = axes('Position',get(a,'Position'),'box','on','xtick',[],'ytick',[]);
% axes(a)
% linkaxes([a b])

for i=1:size(DATA,3)
    
%     imagesc(DATA(:,:,i));
    imshow(DATA(:,:,i));
    
%     F=getframe;
%     writeVideo(vidOut, F.cdata);
    frame = DATA(:,:,i);
%     writeVideo(vidOut, DATA(:,:,i));
    writeVideo(vidOut, frame);
    
end

close(vidOut);


end

