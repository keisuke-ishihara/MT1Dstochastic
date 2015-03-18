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

ind = any(MT');

curr = MT(ind',:);

lengths = curr(:,3) - curr(:,2);
figure; hist(lengths)
mean(lengths)

n = length(curr);
% calcplusendNumber(curr, n, midpts);

mean(lengths)
pd = fitdist(lengths,'Exponential')
confidence = paramci(pd);
meanofd = pd.mu;

% plot(midpts, calcplusendNumber(curr, n, midpts))
% figure
% plot(midpts, calcmtNumber(curr, n, midpts))

cmap_grow   = [1 1 1; 0 0.5 1];
cmap_shrink = [1 1 1; 1 0.2 0.1];

% subplot(2,1,1)
figure;
barh([curr(:,2) curr(:,3)-curr(:,2)],'stacked')
colormap(cmap_grow);
axis([0 max(midpts) 0 length(curr)])


stop

subplot(2,1,2)
barh([curr(:,2) curr(:,3)],'stacked')




