clear all; close all;

savepath = '/Users/Keisuke/Dropbox/KorolevGroup/simudata/';

global xbin tmax Nmax midpts;
xbinwidth = 4;              % in microns
xbin = 0:xbinwidth:200;  
midpts = (xbin(1:end-1)+xbin(2:end))/2;
tmax = 20;
Nmax = 50000;           % max number of MTs to simulate
% Nmax = 10000;           % max number of MTs to simulate

global plusendCap mtCap;
% define carrying capacities so density is robust to xbinwidth
% the numerator defines the number of MTs in the simulation
% plusendCap = 50/xbinwidth;
% mtCap      = 50/xbinwidth;
plusendCap = 50;
mtCap      = 50; 

global boundarycondition nucscenario depolyreg;
boundarycondition = 3;
nucscenario = 0;
depolyreg = 0;

global v_poly v_depoly f_cat f_res;
v_poly   =  8.8;    v_depoly   = 13.7; 
f_cat = 0.05*60;    f_res = 0.006*60;

dt = 0.04;
Ni = 50;
% Ni = Nmax;

nucrates = (0:1.8:3.6)';
% nucrates = [0];
n_rep = 3;
nucrates = repmat(nucrates,1,n_rep);

tic
for i = 1:length(nucrates(:))
    global nucrate
    lin = nucrates(:);
    nucrate = lin(i);
    
    [time, result] = MTsimulation(Ni, dt);
    i
    toc
    
    filename = strcat(savepath, 'sim', sprintf('%04.0f',i));
    save(filename);
    
end

J = (v_poly*f_res - v_depoly*f_cat)/(f_cat+f_res);
D = v_poly*v_depoly/(f_cat+f_res);
tau =4*D/J^2;
L = D/abs(J);

stop;

%% plot length distribution

MT = result(:,:,end);
% lengths = MT(MT(:,3)~=0, 3)-MT(MT(:,3)~=0, 2); % excluded length zero
lengths = MT(:,3) - MT(:,2); % include length zero
h1 = figure(1);
set(0,'DefaultAxesFontSize', 16)
set(0, 'DefaultFigurePosition', [10 10 350 250]);
figure; hist(lengths)

mean(lengths)
pd = fitdist(lengths,'Exponential')
confidence = paramci(pd);
meanofd = pd.mu;

stop

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