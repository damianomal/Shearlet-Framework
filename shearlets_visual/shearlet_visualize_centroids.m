function shearlet_visualize_centroids( centroids )
%SHEARLET_VISUALIZE_CENTROIDS Summary of this function goes here
%   Detailed explanation goes here

while true

    fprintf('-------------------------------------------\n');
    x = input('Insert the number of the cluster you want to see the centroid: ', 's');
    
    if(strcmp(x,''))
        continue;
    end
    
    A = {};
    A = textscan(x, '%d', 'ReturnOnError', true);
    
    if(numel(A) ~= 1 || A{1} > size(centroids,1) || A{1} < 1 )
        continue;
    end
    
    
    shearlet_show_descriptor(centroids(A{1},:), A{1});

end

end

