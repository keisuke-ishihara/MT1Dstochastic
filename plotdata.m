% this script interacts with simulation data for visualization/analysis

clear all; close all;

datapath = '/Users/Keisuke/Dropbox/KorolevGroup/simudata/20141111_vregoff_alpha0to1.9/';
% datapath = '/Users/Keisuke/Dropbox/KorolevGroup/simudata/20141111_vregon_alpha0to2.6/';

old = cd(datapath);
files = dir('*.mat');
cd(old);

fig_endpoint = figure(1);

s = size(files);
[grad,im] = colorGradient([0 0.6 1],[1 0.1 0], s(1));

for i4ep = 1:length(files)

    load(strcat(datapath,files(i4ep).name));
    MT = result(:,:,end);
    
    plusends  = hist(MT(any(MT,2),3),xbin);
    
    set(0, 'currentfigure', fig_endpoint); hold on;
    plot(xbin, plusends, '.', 'Color', grad(i4ep,:), 'MarkerSize', 14);
    
end
