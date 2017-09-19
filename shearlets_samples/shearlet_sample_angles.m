
s1 = 4;
s2 = 3;

range_s1 = 5;
range_s2 = 5;

% s2 = -s2;

s1 = s1 - ceil(range_s1/2);
s2 = s2 - ceil(range_s2/2);

k = [s1 s2];
j = 2;

num = ((2^(-j/2))*k(2));
den = sqrt(1+(2^(-j))*(k(1)^2));

a = atan(num/den);
b = atan((2^(-j/2))*k(1));

angle = [cos(a)*cos(b) cos(a)*sin(b) sin(a)]

cone = 1;

rotations = [0 -90 90];
angles = [1 0 0; 0 0 1; 0 1 0];

vec = [angle 0];

vec = vec(:)' * AxelRot(rotations(cone), angles(cone, :));
vec(1:3)



