function result = shearlet_shearings_to_angle(k, ranges, scale, cone)
%SHEARLET_SHEARINGS_TO_ANGLE Summary of this function goes here
%   Detailed explanation goes here

k1 = k(1) - ceil(ranges(1)/2);
k2 = k(2) - ceil(ranges(2)/2);

num = ((2^(-scale/2))*k2);
den = sqrt(1+(2^(-scale))*(k1^2));

a = atan(num/den);
b = atan((2^(-scale/2))*k1);

angle = [cos(a)*cos(b) cos(a)*sin(b) sin(a)];

% rotations = [0 -90 90];
% rotations = [0 90 -90];
% angles = [1 0 0; 0 0 1; 0 1 0];

rotations = [0 90 -90];
angles = [1 0 0; 0 1 0; 0 0 1];

vec = [angle 0];

vec = vec(:)' * AxelRot(rotations(cone), angles(cone, :));
result = vec(1:3);

end

