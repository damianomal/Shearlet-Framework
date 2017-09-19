function [i, j, k] = shearlet_local_maxima_in_3D_matrix( c2_vars, min_threshold, minmax_window, sizes )
%SHEARLET_LOCAL_MAXIMA_IN_GREYSCALE Summary of this function goes here
%   Detailed explanation goes here

CURMAT = c2_vars;
CURMAT(CURMAT < min_threshold) = 0;

Amin=minmaxfilt(CURMAT,minmax_window,'max','same'); % alternatively use imerode in image processing
[i, j, k]=ind2sub(size(CURMAT),find(Amin==CURMAT & CURMAT > 0)); % <- index of local minima

idxkeep=find(i>minmax_window & i<=sizes(1)-minmax_window & ...
    j>minmax_window & j<=sizes(2)-minmax_window & ...
    k>minmax_window & k<=sizes(3)-minmax_window);

i=i(idxkeep);
j=j(idxkeep);
k=k(idxkeep);

end

