close all;

% clear all; clc; close all;
% 
% xbin = 0:4:200;
% midpts = (xbin(1:end-1)+xbin(2:end))/2;
% 
% n = 150;
% MT1 = [ones(n,1) zeros(n,1) (linspace(1,190,n))'];
% MT2 = [ones(n,1) 50*ones(n,1) (linspace(50,190,n))'];
% 
% MT = MT1;

% MT = result(:,:,end);

ind = any(MT');
curr = MT(ind',:);
lengths = curr(:,3) - curr(:,2);

ages    = curr(:,4); length(ages);
pd = fitdist(ages,'Exponential')
ages(ages==0) = []; length(ages);
pd = fitdist(ages,'Exponential')

n = length(curr);

pd = fitdist(lengths,'Exponential');
confidence = paramci(pd);
meanofd = pd.mu;

% plot(midpts, calcplusendNumber(curr, n, midpts))
% figure
% plot(midpts, calcmtNumber(curr, n, midpts))

cmap_grow   = [1 1 1; 0 0.5 1];
cmap_shrink = [1 1 1; 1 0.2 0.1];
cmap_age    = [0.1 0.8 0.4];

figure;
barh([curr(:,2) curr(:,3)-curr(:,2)],'stacked')
colormap(cmap_grow);
axis([0 max(midpts) 0 length(curr)])
title('length and polymer distribution')

% figure;
% barh(curr(:,4));
% colormap(cmap_age);
% axis([0 1.2*max(curr(:,4)) 0 length(curr)])
% title('age distribution')

gplusend = calcplusendNumber(curr(curr(:,1) == 1,:), length(curr(curr(:,1) == 1,:)), midpts);
splusend = calcplusendNumber(curr(curr(:,1) == 0,:), length(curr(curr(:,1) == 0,:)), midpts);
tplusend = gplusend + splusend;
% figure; plot(midpts, [gplusend; splusend; tplusend])
% figure; plot(midpts, [gplusend./tplusend])
% title('fraction of growing plus end');

% distr of plus end and polymer
mtNo = calcmtNumber(curr, length(curr), midpts);
figure; plot(midpts,tplusend/mean(tplusend), midpts, mtNo/mean(mtNo))
legend('plus ends', 'mt Polymer')

stop

length(MT(ages~=0,1))
sum(MT(ages~=0,1))
length(MT(ind',1))
sum(MT(ind',1))

J = (v_poly*f_res - v_depoly*f_cat)/(f_cat+f_res);
D = v_poly*v_depoly/(f_cat+f_res);
tau =4*D/J^2;
L = D/abs(J);

