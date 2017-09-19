function [ translated ] = comparison_translate_points_by_centroid( coordinates, centroids, video )
%COMPARISON_TRANSLATE_POINTS_BY_CENTROID Summary of this function goes here
%   Detailed explanation goes here

translated = size(coordinates);

for c=1:size(video,3)  
    
    id = find(coordinates(:, 3) == c);
    
    for i=1:size(id,1)
        translated(id(i),1) = coordinates(id(i),1) - centroids(c,2) + size(video,1) * 0.5; 
        translated(id(i),2) = coordinates(id(i),2) - centroids(c,1) + size(video,2) * 0.5; 
        translated(id(i),3) = coordinates(id(i),3); 
    end
       
end

end

