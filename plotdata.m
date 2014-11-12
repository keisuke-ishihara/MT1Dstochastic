% this script interacts with simulation data for visualization/analysis

clear all;

datapath = '/Users/Keisuke/Dropbox/KorolevGroup/simudata/20141111_vregoff_alpha0to1.9/';

old = cd(datapath);
files = dir('*.mat');
cd(old);

fig_endpoint = figure(1);

s = size(files);
[grad,im] = colorGradient([0 0.6 1],[1 0.1 0], s(1));

for i4ep = 1:length(files)
    strcat(datapath,files(i4ep).name)
    load(strcat(datapath,files(i4ep).name));
    MT = result(:,:,end);
    
    plusends  = hist(MT(any(MT,2),3),xbin);
    
    set(0, 'currentfigure', fig_endpoint); hold on;
    grad(i4ep,:)
    plot(xbin, plusends, '.', 'Color', grad(i4ep,:), 'MarkerSize', 14);
    
end


stop


%% plot length distribution

MT = result(:,:,end);
lengths = MT(MT(:,3)~=0, 3)-MT(MT(:,3)~=0, 2);
h1 = figure(1);
set(0,'DefaultAxesFontSize', 16)
set(0, 'DefaultFigurePosition', [10 10 350 250]);
hist(lengths)

%% plot plus and minus ends

s = size(result);
[grad,im] = colorGradient([0 0.6 1],[1 0.1 0], s(3));

h2 = figure(2);
set(0,'DefaultAxesFontSize', 16)
set(0, 'DefaultFigurePosition', [10 10 350 250]);

for i = 1:s(3)
    MT = result(:,:,i);
    
    plusends   = hist(MT(any(MT,2),3),xbin);
    minusends  = hist(MT(any(MT,2),2),xbin);

    figure(2); hold on;
    plot(xbin, plusends, '.', 'Color', grad(i,:), 'MarkerSize', 14);
    
    figure(3); hold on;
    diff_polymer = minusends-plusends;
    plot(xbin, cumsum(diff_polymer),'.', 'Color', grad(i,:), 'MarkerSize', 14);
    
end