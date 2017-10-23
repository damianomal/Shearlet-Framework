function output_map = shearlet_init_cluster_map()
%SHEARLET_INIT_CLUSTER_MAP Summary of this function goes here
%   Detailed explanation goes here

output_map =  [0 0 1; 1 0 0; 0 1 0; ...
               1 1 0; 0 0 0; 0 1 1; ...
               1 0 1; 1 1 1; 0.5 0.5 0.5; ...
               0.6 0.6 0; 1 0.4 0.4; 0.15 0.7 0.2; ...
               0.9 0.8 0.1; 0.2 0.2 1; 0.2 0.3 0.2;
               1 0.7 0.7; 0 1 0.6; 0.2 0 0.8; 
               0.4 0.1 0.7; 0.7 1 0.35];

end

