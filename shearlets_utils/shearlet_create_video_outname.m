function [ output_name ] = shearlet_create_video_outname( video_filename, scales, min_threshold, spt_window, cone_weights,file_format)
%SHEARLET_CREATE_VIDEO_OUTNAME Creates a filename starting from the values
%contained in the parameters passed.
%
% Usage:
%   output_name = shearlet_create_video_outname('movement.mp4', [2 3], 0.05, 11)
%           On the basis of the filename of the original video being processed
%           and of the values of the parameters passed, returns a new 
%           filename related to them. In the case above, for example, the
%           resulting filename is 'movement_sc_2_3_th_0_05_win_11.avi'.
%
% Parameters:
%   video_filename: the matrix representing the video sequence
%   scales: the set of scales considered
%   min_threshold: the minumum value for a candidate point
%   spt_window: the neighborhood to consider while searching for local maxima
%   cone_weights: XXX
%
% Output:
%   output_name: the resulting filename
%
%   See also ...
%
% 2016 Damiano Malafronte.

[~,name,~] = fileparts(video_filename);

scales_text = 'sc_';

for i =1:numel(scales)
    scales_text = strcat(scales_text, int2str(scales(i)), '_');
end
if nargin < 6
    file_format = '.avi';
end

thresh_text = strcat('th_', num2str(min_threshold, 3));

thresh_text = strrep(thresh_text, '.', '_');

win_text = strcat('win_', int2str(spt_window));

output_name = strcat(name, '_', scales_text, thresh_text, '_', win_text, file_format);

end

