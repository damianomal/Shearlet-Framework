

%% EDGE EXAMPLE

close all;
clear all;


% 
VID = shearlets_synthetic_data('edge', [100 100 100], 255);

%
% VID = imgaussfilt3(VID, 1.5);

% 
[COEFFS,idxs] = shearlet_transform_3D(VID,50,91,[0 1 1], 3, 1);
% 
% % 
p = [50 47 50];

%
yrange = p(2)-25:p(2)+25;

%3
cone = 1;
scale = 3;

%
indexes3 = find(idxs(:,1) == cone & idxs(:,2) == scale);

%
[mv, mi3]  = max(abs(squeeze(COEFFS(p(1), p(2), p(3), indexes3))));

% fprintf('Max: %.5f - at index: %d\n', mv, mi3);

%
scale = 2;

%
indexes2 = find(idxs(:,1) == cone & idxs(:,2) == scale);
[~, mi2]  = max(abs(squeeze(COEFFS(p(1), p(2), p(3), indexes2))));

%
figure('Position', [101 559 560 420]);
imshow(VID(:,:,50),[]);

hold on;
plot([25 75],[50 50],'r-', 'LineWidth', 3);
% plot(50, 50,'g.', 'MarkerSize', 30, 'LineWidth', 3);
hold off;

set(gcf, 'Position', [101 559 560 420]);


%
figure('Position', [680 558 560 420]);

hold on;
% plot(indexes3-min(indexes3), abs(squeeze(COEFFS(p(1), p(2), p(3), indexes3))), 'r-', 'LineWidth', 2);
% plot(indexes2-min(indexes2), abs(squeeze(COEFFS(p(1), p(2), p(3), indexes2))), 'b-', 'LineWidth', 2);
plot(indexes3-min(indexes3), squeeze(COEFFS(p(1), p(2), p(3), indexes3)), 'r-', 'LineWidth', 2);
plot(indexes2-min(indexes2), squeeze(COEFFS(p(1), p(2), p(3), indexes2)), 'b-', 'LineWidth', 2);

% plot(1:size(COEFFS,4)-1, abs(squeeze(COEFFS(p(1), p(2), p(3), 1:end-1))), 'r-', 'LineWidth', 2);
% plot(1:size(COEFFS,4)-1, abs(squeeze(COEFFS(p(1), p(2), p(3), 1:end-1))), 'b-', 'LineWidth', 2);


% plot(indexes3-min(indexes3), abs(squeeze(sum(sum(sum(COEFFS(p(1)-1:p(1)+1, p(2)-1:p(2)+1, p(3)-1:p(3)+1, indexes3),1),2),3)))./27, 'r-', 'LineWidth', 2);
% plot(indexes2-min(indexes2), abs(squeeze(sum(sum(sum(COEFFS(p(1)-1:p(1)+1, p(2)-1:p(2)+1, p(3)-1:p(3)+1, indexes3),1),2),3)))./27, 'b-', 'LineWidth', 2);

hold off;

title(['SH(k) while k=(k1,k2) changes, cone ' int2str(cone) ', scale 2 and 3']);
legend('Scale 3', 'Scale 2');


%   
figure('Position', [1257 558 560 420]);

hold on;
% plot(yrange, abs(squeeze(COEFFS(p(1), yrange, p(3), indexes3(mi3)))), 'r-', 'LineWidth', 2);
% plot(yrange, abs(squeeze(COEFFS(p(1), yrange, p(3), indexes2(mi2)))), 'b-', 'LineWidth', 2);
plot(yrange, squeeze(COEFFS(p(1), yrange, p(3), indexes3(mi3))), 'r-', 'LineWidth', 2);
plot(yrange, squeeze(COEFFS(p(1), yrange, p(3), indexes2(mi2))), 'b-', 'LineWidth', 2);
% 
% plot(yrange, abs(squeeze(sum(sum(COEFFS(p(1)-2:p(1)+2, yrange, p(3)-2:p(3)+2, indexes3(mi3)),1),3))), 'r-', 'LineWidth', 2);
% plot(yrange, abs(squeeze(sum(sum(COEFFS(p(1)-2:p(1)+2, yrange, p(3)-2:p(3)+2, indexes2(mi2)),1),3))), 'b-', 'LineWidth', 2);

hold off;

title(['SH(kmax, y) while y in [25, 75] changes, cone ' int2str(cone) ', scale 2 and 3']);
legend('Scale 3', 'Scale 2');


%% CORNER EXAMPLE

close all;

VID = shearlets_synthetic_data('corner', [100 100 100], 255);

%
VID = imgaussfilt3(VID, 1);

% 
[COEFFS,idxs] = shearlet_transform_3D(VID,50,91,[0 1 1], 3, 1);

% 
% p = [50 50 50];
% p = [49 51 50]; % giusto sul cono 3
% p = [51 49 50]; % qua e' giusta la scala 2
p = [51 51 50]; % giusto sul cono 1

%
yrange = p(2)-25:p(2)+25;
xrange = p(1)-25:p(1)+25;

%3
cone = 1;
scale = 3;

%
indexes3 = find(idxs(:,1) == cone & idxs(:,2) == scale);

%
[mv, mi3]  = max(abs(squeeze(COEFFS(p(1), p(2), p(3), indexes3))));

% fprintf('Max: %.5f - at index: %d\n', mv, mi3);

%
scale = 2;

%
indexes2 = find(idxs(:,1) == cone & idxs(:,2) == scale);
[~, mi2]  = max(abs(squeeze(COEFFS(p(1), p(2), p(3), indexes2))));

%
figure('Position', [101 559 560 420]);
imshow(VID(:,:,50),[]);

hold on;
plot([yrange(1) yrange(end)],[p(1) p(1)],'r-', 'LineWidth', 3);
plot(p(1), p(2),'g.', 'MarkerSize', 30, 'LineWidth', 3);
hold off;

set(gcf, 'Position', [101 559 560 420]);


%
figure('Position', [680 558 560 420]);

hold on;
plot(indexes3-min(indexes3), abs(squeeze(COEFFS(p(1), p(2), p(3), indexes3))), 'r-', 'LineWidth', 2);
plot(indexes2-min(indexes2), abs(squeeze(COEFFS(p(1), p(2), p(3), indexes2))), 'b-', 'LineWidth', 2);

% plot(indexes3-min(indexes3), abs(squeeze(sum(sum(sum(COEFFS(p(1)-1:p(1)+1, p(2)-1:p(2)+1, p(3)-1:p(3)+1, indexes3),1),2),3)))./27, 'r-', 'LineWidth', 2);
% plot(indexes2-min(indexes2), abs(squeeze(sum(sum(sum(COEFFS(p(1)-1:p(1)+1, p(2)-1:p(2)+1, p(3)-1:p(3)+1, indexes3),1),2),3)))./27, 'b-', 'LineWidth', 2);

hold off;

title(['SH(k) while k=(k1,k2) changes, cone ' int2str(cone) ', scale 2 and 3']);
legend('Scale 3', 'Scale 2');


%
figure('Position', [1257 558 560 420]);

hold on;
plot(yrange, abs(squeeze(COEFFS(p(1), yrange, p(3), indexes3(mi3)))), 'r-', 'LineWidth', 2);
plot(yrange, abs(squeeze(COEFFS(p(1), yrange, p(3), indexes2(mi2)))), 'b-', 'LineWidth', 2);
% 
% plot(yrange, abs(squeeze(sum(sum(COEFFS(p(1)-2:p(1)+2, yrange, p(3)-2:p(3)+2, indexes3(mi3)),1),3))), 'r-', 'LineWidth', 2);
% plot(yrange, abs(squeeze(sum(sum(COEFFS(p(1)-2:p(1)+2, yrange, p(3)-2:p(3)+2, indexes2(mi2)),1),3))), 'b-', 'LineWidth', 2);

hold off;

title(['SH(kmax, y) while y in [25, 75] changes, cone ' int2str(cone) ', scale 2 and 3']);
legend('Scale 3', 'Scale 2');





p = [49 51 50]; % giusto sul cono 3



cone = 3;
scale = 3;

%
indexes3 = find(idxs(:,1) == cone & idxs(:,2) == scale);

%
[mv, mi3]  = max(abs(squeeze(COEFFS(p(1), p(2), p(3), indexes3))));

% fprintf('Max: %.5f - at index: %d\n', mv, mi3);

%
scale = 2;

%
indexes2 = find(idxs(:,1) == cone & idxs(:,2) == scale);
[~, mi2]  = max(abs(squeeze(COEFFS(p(1), p(2), p(3), indexes2))));

%
figure('Position', [101 (559-420) 560 420]);
imshow(VID(:,:,50),[]);

hold on;
plot([p(1) p(1)],[xrange(1) xrange(end)],'r-', 'LineWidth', 3);
plot(p(1), p(2),'g.', 'MarkerSize', 30, 'LineWidth', 3);
hold off;

set(gcf, 'Position', [101 (559-420) 560 420]);


%
figure('Position', [680 (559-420) 560 420]);

hold on;
plot(indexes3-min(indexes3), abs(squeeze(COEFFS(p(1), p(2), p(3), indexes3))), 'r-', 'LineWidth', 2);
plot(indexes2-min(indexes2), abs(squeeze(COEFFS(p(1), p(2), p(3), indexes2))), 'b-', 'LineWidth', 2);

% plot(indexes3-min(indexes3), abs(squeeze(sum(sum(sum(COEFFS(p(1)-1:p(1)+1, p(2)-1:p(2)+1, p(3)-1:p(3)+1, indexes3),1),2),3)))./27, 'r-', 'LineWidth', 2);
% plot(indexes2-min(indexes2), abs(squeeze(sum(sum(sum(COEFFS(p(1)-1:p(1)+1, p(2)-1:p(2)+1, p(3)-1:p(3)+1, indexes3),1),2),3)))./27, 'b-', 'LineWidth', 2);

hold off;

title(['SH(k) while k=(k1,k2) changes, cone ' int2str(cone) ', scale 2 and 3']);
legend('Scale 3', 'Scale 2');


%
figure('Position', [1257 (559-420) 560 420]);

hold on;
plot(xrange, abs(squeeze(COEFFS(xrange, p(2), p(3), indexes3(mi3)))), 'r-', 'LineWidth', 2);
plot(xrange, abs(squeeze(COEFFS(xrange, p(2), p(3), indexes2(mi2)))), 'b-', 'LineWidth', 2);
% 
% plot(yrange, abs(squeeze(sum(sum(COEFFS(p(1)-2:p(1)+2, yrange, p(3)-2:p(3)+2, indexes3(mi3)),1),3))), 'r-', 'LineWidth', 2);
% plot(yrange, abs(squeeze(sum(sum(COEFFS(p(1)-2:p(1)+2, yrange, p(3)-2:p(3)+2, indexes2(mi2)),1),3))), 'b-', 'LineWidth', 2);

hold off;

title(['SH(kmax, x) while x in [25, 75] changes, cone ' int2str(cone) ', scale 2 and 3']);
legend('Scale 3', 'Scale 2');





%% OLD CODE



%% EDGE EXAMPLE

close all;
% clear all;

% 
clear VID
VID = shearlets_synthetic_data('edge', [100 100 100], 255);

%
% VID = imgaussfilt3(VID, 1.5);

% 
clear COEFFS
[COEFFS,idxs] = shearlet_transform_3D(VID,50,91,[0 1 1], 3, 1);

% 
p = [50 50 50];
% p = [75 75 75];

%
yrange = p(2)-25:p(2)+25;

%3
cone = 1;
scale = 3;

%
indexes3 = find(idxs(:,1) == cone & idxs(:,2) == scale);
indexes4 = find(idxs(:,1) == cone & idxs(:,2) == 4);
indexes5 = find(idxs(:,1) == cone & idxs(:,2) == 5);

%
[~, mi3]  = max(abs(squeeze(COEFFS(p(1), p(2), p(3), indexes3))));
[~, mi4]  = max(abs(squeeze(COEFFS(p(1), p(2), p(3), indexes4))));
[~, mi5]  = max(abs(squeeze(COEFFS(p(1), p(2), p(3), indexes5))));

% fprintf('Max: %.5f - at index: %d\n', mv, mi3);

%
scale = 2;

%
indexes2 = find(idxs(:,1) == cone & idxs(:,2) == scale);
[~, mi2]  = max(abs(squeeze(COEFFS(p(1), p(2), p(3), indexes2))));

%
figure('Position', [101 559 560 420]);
imshow(VID(:,:,50),[]);

hold on;
plot([p(1)-25 p(1)+25],[p(1) p(1)],'r-', 'LineWidth', 3);
% plot(50, 50,'g.', 'MarkerSize', 30, 'LineWidth', 3);
hold off;

set(gcf, 'Position', [101 559 560 420]);


%
figure('Position', [680 558 560 420]);

hold on;
plot(indexes3-min(indexes3), abs(squeeze(COEFFS(p(1), p(2), p(3), indexes3))), 'r-', 'LineWidth', 2);
% plot(indexes2-min(indexes2), abs(squeeze(COEFFS(p(1), p(2), p(3), indexes2))), 'b-', 'LineWidth', 2);
% plot(indexes4-min(indexes4), abs(squeeze(COEFFS(p(1), p(2), p(3), indexes4))), 'b-', 'LineWidth', 2);
% plot(indexes5-min(indexes5), abs(squeeze(COEFFS(p(1), p(2), p(3), indexes5))), 'y-', 'LineWidth', 2);

% plot(1:size(COEFFS,4)-1, abs(squeeze(COEFFS(p(1), p(2), p(3), 1:end-1))), 'r-', 'LineWidth', 2);
% plot(1:size(COEFFS,4)-1, abs(squeeze(COEFFS(p(1), p(2), p(3), 1:end-1))), 'b-', 'LineWidth', 2);


% plot(indexes3-min(indexes3), abs(squeeze(sum(sum(sum(COEFFS(p(1)-1:p(1)+1, p(2)-1:p(2)+1, p(3)-1:p(3)+1, indexes3),1),2),3)))./27, 'r-', 'LineWidth', 2);
% plot(indexes2-min(indexes2), abs(squeeze(sum(sum(sum(COEFFS(p(1)-1:p(1)+1, p(2)-1:p(2)+1, p(3)-1:p(3)+1, indexes3),1),2),3)))./27, 'b-', 'LineWidth', 2);

hold off;

title(['SH(k) while k=(k1,k2) changes, cone ' int2str(cone) ', scale 2 and 3']);
% legend('Scale 3', 'Scale 2');
legend('Scale 3');


%   
figure('Position', [1257 558 560 420]);

hold on;
plot(yrange, abs(squeeze(COEFFS(p(1), yrange, p(3), indexes3(mi3)))), 'r-', 'LineWidth', 2);
% plot(yrange, abs(squeeze(COEFFS(p(1), yrange, p(3), indexes2(mi2)))), 'b-', 'LineWidth', 2);
% plot(yrange, abs(squeeze(COEFFS(p(1), yrange, p(3), indexes4(mi4)))), 'y-', 'LineWidth', 2);
% plot(yrange, abs(squeeze(COEFFS(p(1), yrange, p(3), indexes5(mi5)))), 'k-', 'LineWidth', 2);
% plot(yrange, abs(squeeze(COEFFS(p(1), yrange, p(3), indexes3(mi3)))), 'r-', 'LineWidth', 2);
% 
% plot(yrange, abs(squeeze(sum(sum(COEFFS(p(1)-2:p(1)+2, yrange, p(3)-2:p(3)+2, indexes3(mi3)),1),3))), 'r-', 'LineWidth', 2);
% plot(yrange, abs(squeeze(sum(sum(COEFFS(p(1)-2:p(1)+2, yrange, p(3)-2:p(3)+2, indexes2(mi2)),1),3))), 'b-', 'LineWidth', 2);

hold off;

title(['SH(kmax, y) while y in [25, 75] changes, cone ' int2str(cone) ', scale 2 and 3']);
% legend('Scale 3', 'Scale 2', 'Scale 4', 'Scale 5');
legend('Scale 3');





% figure;



%% CORNER EXAMPLE

close all;

VID = shearlets_synthetic_data('corner', [100 100 100], 255);

%
% VID = imgaussfilt3(VID, 1);

% 
[COEFFS,idxs] = shearlet_transform_3D(VID,50,91,[0 1 1], 3, 1);

% 
% p = [50 50 50];
% p = [49 51 50]; % giusto sul cono 3
% p = [51 49 50]; % qua e' giusta la scala 2
p = [51 51 50]; % giusto sul cono 1

%
yrange = p(2)-25:p(2)+25;
xrange = p(1)-25:p(1)+25;

%3
cone = 1;
scale = 3;

%
indexes3 = find(idxs(:,1) == cone & idxs(:,2) == scale);

%
[mv, mi3]  = max(abs(squeeze(COEFFS(p(1), p(2), p(3), indexes3))));

% fprintf('Max: %.5f - at index: %d\n', mv, mi3);

%
scale = 2;

%
indexes2 = find(idxs(:,1) == cone & idxs(:,2) == scale);
[~, mi2]  = max(abs(squeeze(COEFFS(p(1), p(2), p(3), indexes2))));

%
figure('Position', [101 559 560 420]);
imshow(VID(:,:,50),[]);

hold on;
plot([yrange(1) yrange(end)],[p(1) p(1)],'r-', 'LineWidth', 3);
plot(p(1), p(2),'g.', 'MarkerSize', 30, 'LineWidth', 3);
hold off;

set(gcf, 'Position', [101 559 560 420]);


%
figure('Position', [680 558 560 420]);

hold on;
plot(indexes3-min(indexes3), abs(squeeze(COEFFS(p(1), p(2), p(3), indexes3))), 'r-', 'LineWidth', 2);
% plot(indexes2-min(indexes2), abs(squeeze(COEFFS(p(1), p(2), p(3), indexes2))), 'b-', 'LineWidth', 2);

% plot(indexes3-min(indexes3), abs(squeeze(sum(sum(sum(COEFFS(p(1)-1:p(1)+1, p(2)-1:p(2)+1, p(3)-1:p(3)+1, indexes3),1),2),3)))./27, 'r-', 'LineWidth', 2);
% plot(indexes2-min(indexes2), abs(squeeze(sum(sum(sum(COEFFS(p(1)-1:p(1)+1, p(2)-1:p(2)+1, p(3)-1:p(3)+1, indexes3),1),2),3)))./27, 'b-', 'LineWidth', 2);

hold off;

title(['SH(k) while k=(k1,k2) changes, cone ' int2str(cone) ', scale 2 and 3']);
% legend('Scale 3', 'Scale 2');
legend('Scale 3');


%
figure('Position', [1257 558 560 420]);

hold on;
plot(yrange, abs(squeeze(COEFFS(p(1), yrange, p(3), indexes3(mi3)))), 'r-', 'LineWidth', 2);
% plot(yrange, abs(squeeze(COEFFS(p(1), yrange, p(3), indexes2(mi2)))), 'b-', 'LineWidth', 2);
% 
% plot(yrange, abs(squeeze(sum(sum(COEFFS(p(1)-2:p(1)+2, yrange, p(3)-2:p(3)+2, indexes3(mi3)),1),3))), 'r-', 'LineWidth', 2);
% plot(yrange, abs(squeeze(sum(sum(COEFFS(p(1)-2:p(1)+2, yrange, p(3)-2:p(3)+2, indexes2(mi2)),1),3))), 'b-', 'LineWidth', 2);

hold off;

title(['SH(kmax, y) while y in [25, 75] changes, cone ' int2str(cone) ', scale 2 and 3']);
% legend('Scale 3', 'Scale 2');
legend('Scale 3');





p = [49 51 50]; % giusto sul cono 3



cone = 3;
scale = 3;

%
indexes3 = find(idxs(:,1) == cone & idxs(:,2) == scale);

%
[mv, mi3]  = max(abs(squeeze(COEFFS(p(1), p(2), p(3), indexes3))));

% fprintf('Max: %.5f - at index: %d\n', mv, mi3);

%
scale = 2;

%
indexes2 = find(idxs(:,1) == cone & idxs(:,2) == scale);
[~, mi2]  = max(abs(squeeze(COEFFS(p(1), p(2), p(3), indexes2))));

%
figure('Position', [101 (559-420) 560 420]);
imshow(VID(:,:,50),[]);

hold on;
plot([p(1) p(1)],[xrange(1) xrange(end)],'r-', 'LineWidth', 3);
plot(p(1), p(2),'g.', 'MarkerSize', 30, 'LineWidth', 3);
hold off;

set(gcf, 'Position', [101 (559-420) 560 420]);


%
figure('Position', [680 (559-420) 560 420]);

hold on;
plot(indexes3-min(indexes3), abs(squeeze(COEFFS(p(1), p(2), p(3), indexes3))), 'r-', 'LineWidth', 2);
% plot(indexes2-min(indexes2), abs(squeeze(COEFFS(p(1), p(2), p(3), indexes2))), 'b-', 'LineWidth', 2);

% plot(indexes3-min(indexes3), abs(squeeze(sum(sum(sum(COEFFS(p(1)-1:p(1)+1, p(2)-1:p(2)+1, p(3)-1:p(3)+1, indexes3),1),2),3)))./27, 'r-', 'LineWidth', 2);
% plot(indexes2-min(indexes2), abs(squeeze(sum(sum(sum(COEFFS(p(1)-1:p(1)+1, p(2)-1:p(2)+1, p(3)-1:p(3)+1, indexes3),1),2),3)))./27, 'b-', 'LineWidth', 2);

hold off;

title(['SH(k) while k=(k1,k2) changes, cone ' int2str(cone) ', scale 2 and 3']);
% legend('Scale 3', 'Scale 2');
legend('Scale 3');


%
figure('Position', [1257 (559-420) 560 420]);

hold on;
plot(xrange, abs(squeeze(COEFFS(xrange, p(2), p(3), indexes3(mi3)))), 'r-', 'LineWidth', 2);
% plot(xrange, abs(squeeze(COEFFS(xrange, p(2), p(3), indexes2(mi2)))), 'b-', 'LineWidth', 2);
% 
% plot(yrange, abs(squeeze(sum(sum(COEFFS(p(1)-2:p(1)+2, yrange, p(3)-2:p(3)+2, indexes3(mi3)),1),3))), 'r-', 'LineWidth', 2);
% plot(yrange, abs(squeeze(sum(sum(COEFFS(p(1)-2:p(1)+2, yrange, p(3)-2:p(3)+2, indexes2(mi2)),1),3))), 'b-', 'LineWidth', 2);

hold off;

title(['SH(kmax, x) while x in [25, 75] changes, cone ' int2str(cone) ', scale 2 and 3']);
% legend('Scale 3', 'Scale 2');
legend('Scale 3');










