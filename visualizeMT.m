clear all; clc; close all;

xbin = 0:4:200;
midpts = (xbin(1:end-1)+xbin(2:end))/2;

n = 150;
MT1 = [ones(n,1) zeros(n,1) (linspace(1,190,n))'];
MT2 = [ones(n,1) 50*ones(n,1) (linspace(50,190,n))'];

MT = MT1;

calcplusendNumber(MT, n, midpts)

plot(midpts, calcplusendNumber(MT, n, midpts))
figure
plot(midpts, calcmtNumber(MT, n, midpts))

stop
cmap_grow   = [1 1 1; 0 0.5 1];
cmap_shrink = [1 1 1; 1 0.2 0.1];

subplot(2,1,1)
barh([MT(:,2) MT(:,3)],'stacked')
colormap(cmap_grow);

stop

subplot(2,1,2)
barh([MT(:,2) MT(:,3)],'stacked')

stop


plot(xbin, hist(MT(:,2), xbin))

figure;
plot(xbin, hist(MT(:,3), xbin))



