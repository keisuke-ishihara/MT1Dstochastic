% this script interacts with simulation data for visualization/analysis

clear all; close all;

datapath = strcat(fileparts(pwd),'/experiments_MT1Dstoch/20150330_1/param1_out/');

% load list of simulation results
old = cd(datapath);
files = dir('*.mat');
cd(old);

set(0,'DefaultAxesFontSize', 16)
set(0, 'DefaultFigurePosition', [10 10 600 450]);

%% plot average of simulation to figure

load(strcat(datapath,files(1).name));
accum = zeros(length(files),length(midpts));

for i4ep = 1:length(files)

    load(strcat(datapath,files(i4ep).name));
    MT = result(:,:,end);
    plusends  = hist(MT(any(MT,2),3),midpts);
    accum(i4ep,:) = plusends;    
    
end

plusendprofile = sum(accum, 1)/length(files);

figure(1); hold on
plot(midpts, plusendprofile);

stop

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

% fig_endpointmean = figure(2);
% 
% % collect data points and add them into a row in a matrix
% 
% load(strcat(datapath,files(1).name));
% [n_cond, n_rep] = size(nucrates);
% accum = zeros(n_cond,length(xbin));
% 
% for i4ep = 1:length(files)
% 
%     load(strcat(datapath,files(i4ep).name));
%     MT = result(:,:,end);
%     plusends  = hist(MT(any(MT,2),3),xbin);
%     accum(mod(i4ep-1,n_cond)+1,:) = accum(mod(i4ep-1,n_cond)+1,:) + plusends;    
%     
% end
% 
% [grad,im] = colorGradient([0 0.6 1],[1 0.1 0], n_cond);
% 
% 
% % take average and plot
% accum = accum/n_rep;
% for i4ep = 1:n_cond
%     
%     set(0, 'currentfigure', fig_endpointmean); hold on;
%     plot(xbin, accum(i4ep,:), '.', 'Color', grad(i4ep,:), 'MarkerSize', 14)
% 
% end
% leg = [];
% for i4ep = 1:n_cond
%     leg = [leg; 'alpha = ', sprintf('%1.1f',nucrates(i4ep,1))];
% end
% legend(leg);

%% plot individual simulations
fig_individual = figure(3);
set(0, 'currentfigure', fig_individual); hold on;

for i = 1:length(files)
    
    load(strcat(datapath,files(i).name));
    MT = result(:,:,end);
    plusends  = hist(MT(any(MT,2),3),xbin);
    plot(xbin, plusends, '.', 'Color', grad(mod(i-1,n_cond)+1,:), 'MarkerSize', 14)

end
leg = [];
for i4ep = 1:n_cond
    leg = [leg; 'alpha = ', sprintf('%1.1f',nucrates(i4ep,1))];
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

