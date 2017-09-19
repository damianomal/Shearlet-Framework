function comparison_3d_visualization_from_points( fg_masks, coordinates, permuted)
%COMPARISON_3D_VISUALIZATION_FROM_POINTS Summary of this function goes here
%   Detailed explanation goes here

figure('Position', [680 199 872 779]);

if(~permuted)
    fg_masks(:,:,1) = 0;
    fg_masks(:,:,end) = 0;
else
    fg_masks(1,:,:) = 0;
    fg_masks(end,:,:) = 0;
    fg_masks(:,1,:) = 0;
    fg_masks(:,end,:) = 0;
end
% fg_masks(:,:,1) = 0;

% layer = fg_masks(:,:,2);


% p = patch(isosurface(smooth3(fg_masks,'box',1) > 0, 0, fg_masks));
p = patch(isosurface(fg_masks > 0, 0, fg_masks));
p.FaceColor = 'interp';
p.EdgeColor = 'none';

if(~permuted)
xlabel('x', 'FontSize', 27)
ylabel('y', 'FontSize', 27)
zlabel('time', 'FontSize', 27)
else
    xlabel('time', 'FontSize', 27)
    ylabel('y', 'FontSize', 27)
    zlabel('x', 'FontSize', 27)

end


set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
set(gca,'zticklabel',[])

grid on

% [x,y,z] = sphere(10);
% sphere_color = ones(11);
%
% size(x)
% size(sphere_color)
%
% hold on
%
% for i=1:size(coordinates,1)
%
%      surf(4*x+coordinates(i,2),4*y+coordinates(i,1),4*z+coordinates(i,3), ...
%         sphere_color, ...
%         'FaceColor','interp',...
%         'EdgeColor','none',...
%         'FaceLighting','gouraud');
% end

% ratio = 1.1;
ratio = 1.5;

[x, y, z] = ellipsoid(0,0,0,ratio*3,ratio*3.25,ratio*3.25,30);
sphere_color = ones(31);

size(x);
size(sphere_color);

hold on

for i=1:size(coordinates,1)
    
    if(~permuted)
        surf(x+coordinates(i,2),y+coordinates(i,1),z+coordinates(i,3), ...
            sphere_color, ...
            'FaceColor','interp',...
            'EdgeColor','none',...
            'FaceLighting','gouraud');
    else
        surf(x+coordinates(i,2),y+coordinates(i,3),z+coordinates(i,1), ...
            sphere_color, ...
            'FaceColor','interp',...
            'EdgeColor','none',...
            'FaceLighting','gouraud');
        
    end
end



colormap([0 0.85 0.55;0 0.2 1])

if(~permuted)
    view([154.5000 10.8000]);
else
    view([-98.3000 30.0000]);
end

hold off
rotate3d on

camlight
lighting phong

end

