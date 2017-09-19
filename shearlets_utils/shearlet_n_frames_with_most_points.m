function [ frames ] = shearlet_n_frames_with_most_points( counts, n, suppress_win)
%SHEARLET_N_FRAMES_WITH_MOST_POINTS Summary of this function goes here
%   Detailed explanation goes here


if(nargin < 3)
    suppress_win = 0;
end

%
frames = zeros(1,n);

%
for i=1:n
    
    %
    [~, mi] = max(counts);
    
    if(isempty(mi))
        break;
    end
    
    %
    frames(i) = mi(1);
    
    %
    counts(mi(1)-suppress_win:mi(1)+suppress_win) = 0;
    
end

end

