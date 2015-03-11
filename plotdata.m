% this script interacts with simulation data for visualization/analysis

clear all; close all;

datapath = '/Users/Keisuke/Dropbox/KorolevGroup/simudata/';

% datapath = '/Users/Keisuke/Dropbox/KorolevGroup/simudata/20141111_vregoff_alpha0to1.9/';
% datapath = '/Users/Keisuke/Dropbox/KorolevGroup/simudata/20141111_vregon_alpha0to2.6/';

% load list of simulation results
old = cd(datapath);
files = dir('*.mat');
cd(old);

set(0,'DefaultAxesFontSize', 16)
set(0, 'DefaultFigurePosition', [10 10 350 250]);

fig_endpoint = figure(1);

s = size(files);
s(1) = 10;
[grad,im] = colorGradient([0 0.6 1],[1 0.1 0], s(1));


%% for plotting individual simulations
% for i4ep = 1:100
% 
%     load(strcat(datapath,files(i4ep).name));
%     MT = result(:,:,end);
%     
%     plusends  = hist(MT(any(MT,2),3),xbin);
%     
%     set(0, 'currentfigure', fig_endpoint); hold on;
%     plot(xbin, plusends, '.', 'Color', grad(mod(i4ep-1,10)+1,:), 'MarkerSize', 14);
%     
% end
% accum = zeros(s(1),50);


%% for plotting average of simulations

fig_endpointmean = figure(2);

% collect data points and add them into a row in a matrix
accum = zeros(s(1),50);
for i4ep = 1:length(files)

    load(strcat(datapath,files(i4ep).name));
    MT = result(:,:,end);
    plusends  = hist(MT(any(MT,2),3),xbin);
    accum(mod(i4ep-1,10)+1,:) = accum(mod(i4ep-1,10)+1,:) + plusends;
    
end

% take average and plot
accum = accum/(length(files)/s(1));
for i4ep = 1:s(1)
    
    set(0, 'currentfigure', fig_endpointmean); hold on;
    plot(xbin, accum(i4ep,:), '.', 'Color', grad(i4ep,:), 'MarkerSize', 14)

end

% add legend
leg = [];
for i4ep = 1:s(1)
    leg = [leg; 'alpha = ', sprintf('%1.1f',nucrates(i4ep))]
end
legend(leg);

stop

%% for plotting a timecourse

fig_timecoursemean = figure(3);

% collect data points and add them into a row in a matrix
accum = zeros(s(1),50);
for i4ep = 9:10:1000

    load(strcat(datapath,files(i4ep).name));
    MT = result(:,:,i4ep);
    plusends  = hist(MT(any(MT,2),3),xbin);
    accum(mod(i4ep-1,10)+1,:) = accum(mod(i4ep-1,10)+1,:) + plusends;
    
end

% axis([0 200 0 700])
% set(gca,'XTick',0:40:160)
% set(gca,'YTick',0:500:2000)

