

% files to be processed within the MATLAB path

filenames = {'person02_boxing_d1_uncomp.avi', 'person02_boxing_d2_uncomp.avi', 'person01_handclapping_d4_uncomp.avi', ...
             'person05_handwaving_d3_uncomp.avi', 'person04_jogging_d4_uncomp.avi', 'person04_running_d1_uncomp.avi', ...
             'person02_walking_d3_uncomp.avi', 'person01_walking_d2_uncomp.avi'};

% for each file, specify correctly the first and last frame to be loaded  
% (in the case represented in this sample .m file, only the first 100
% frames of the sequences listed above were considered)
         
limits = {[1 100], [1 100], [1 100], ...
          [1 100], [1 100], [1 100], ...
          [1 100], [1 100]};
         
% specifies which scale of coefficients to use
      
SCALE_USED = 2;

% processes every file

for i=1:numel(filenames)
 
   % loads the i-th sequence
    
   VID = load_video_to_mat(filenames{i}, 160, limits{i}(1), limits{i}(2));
   
   % skips the current sequence if it contains less than 100 frames
   
   if(size(VID, 3) < 100) 
        continue;
   end
   
   % extracts the basename of the current file
   
   [~,name,~] = fileparts(filenames{i});
   
   % clusters the points belonging to all the frames in the current
   % sequence using the previously calculated centroids in the SORT_CTRS
   % structure (refer to others sample files for an example on how to 
   % calculate these centroids)
   
   shearlet_video_representation_clustering( VID(:,:,:), SORT_CTRS, SCALE_USED, name, true);
   
end

