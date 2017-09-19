function [ output_args ] = shearlet_show_bar_diagram( values, color_map )
%SHEARLET_SHOW_BAR_DIAGRAM Summary of this function goes here
%   Detailed explanation goes here

    figure;
    hold on
    for i = 1:numel(values)
        h=bar(i,values(i));
        set(h,'FaceColor', color_map(i, :));
    end
    hold off
    
end

