clear all; close all;

savepath = '/Users/Keisuke/Dropbox/KorolevGroup/simudata/';

global xbin  tmax Nmax;
xbin = 0.5:4:200;
tmax = 20;
Nmax = 100000;           % max number of MTs to simulate

global boundarycondition nucleationscenario depolyreg;
boundarycondition = 3;
nucleationscenario = 1;
depolyreg = 0;

global v_poly v_depoly f_cat f_res;
v_poly   =  8.8;    v_depoly   = 13.7; 
f_cat = 0.05*60;    f_res = 0.006*60;

dt = 0.04;
Ni = 500;

% nucrates = 1;
nucrates = 0:0.2:1.8;
nucrates = repmat(nucrates,1,100);

tic
for i = 1:length(nucrates)
    global nucrate
    nucrate = nucrates(i);
    
    
    [time, result] = MTsimulation(Ni, dt);
    i
    toc
    
    filename = strcat(savepath, 'sim', sprintf('%04.0f',i));
    save(filename);
    
end

% J = (v_poly*f_res - v_depoly*f_cat)/(f_cat+f_res);
% D = v_poly*v_depoly/(f_cat+f_res);
% tau =4*D/J^2;
% L = D/abs(J);


stop


%% plot length distribution

MT = result(:,:,end);
lengths = MT(MT(:,3)~=0, 3)-MT(MT(:,3)~=0, 2);
h1 = figure(1);
set(0,'DefaultAxesFontSize', 16)
set(0, 'DefaultFigurePosition', [10 10 350 250]);
hist(lengths)

% pd = fitdist(lengths,'Exponential');
% confidence = paramci(pd);
% meanofd = mean(pd);

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

% axis([0 160 0 300])
% set(gca,'XTick',0:40:160)
% set(gca,'YTick',0:500:2000)



% num = length(dts);
% 
% figure; hold on;
% plot(-log(dts), res(:,2), 'b', -log(dts), res(:,3), 'b')
% plot(-log(dts), L*ones(1,num), 'r') 
% plot(-log(dts), L*ones(1,num), 'r*') 