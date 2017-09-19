% This video is to breakdown a video into its constituent frames and to
% save the said frames into a .png files in the defines working directory.

workingDir = 'Dataset';
% mkdir(workingDir);
mkdir(workingDir,'Images');
% cd (workingDir)
video = VideoReader('TABLE_TR_0.avi');
% cd ..
ii = 1;

while hasFrame(video)
   img = readFrame(video);
   filename = [sprintf('%08d',ii) '.png'];
   fullname = fullfile(workingDir,'Images',filename);
%    imshow(I)
   imwrite(img,fullname)   
   ii = ii+1;
end