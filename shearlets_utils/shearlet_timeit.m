function [ avg_t, min_t, max_t ] = shearlet_timeit( f, times )
%   Detailed explanation goes here

% st = tic;

min_t = 10e9;
max_t = -1;
avg_t = 0;

for c=1:times
    start_t = tic;
    f();
    new_t = toc(start_t);
    min_t = min([min_t new_t]);
    max_t = max([max_t new_t]);
    avg_t = avg_t + new_t;
end

avg_t = avg_t / times;

%% more MATLAB-like version (not faster than the previous lines)

% res = zeros(1,times);
% 
% for c=1:times
%     start_t = tic;
%     f();
%     res(c) = toc(start_t);
% end
% 
% min_t = min(res);
% max_t = max(res);
% avg_t = sum(res) / times;

% fprintf('Process took: %.4f secs.\n', toc(st));

end

