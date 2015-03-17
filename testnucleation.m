clear all; close all;

global xbin xbinwidth tmax Nmax;
xbinwidth = 4;              % in microns
xbin = 0:xbinwidth:200;   
tmax = 20;
Nmax = 10000;           % max number of MTs to simulate
% Nmax = 10000;           % max number of MTs to simulate

global plusendCap mtCap;
% define carrying capacities so density is robust to xbinwidth
% the numerator defines the number of MTs in the simulation
plusendCap = 50/xbinwidth;
mtCap      = 50/xbinwidth; 

dt = 0.04;

global nucrate nucleationscenario;
nucrate = 1;
nucleationscenario = 1;

n = 10000;
MT = [ones(n,1), ones(n,1), 0.2/20*(1:n)'];
MTadd = [ones(n,1), ones(n,1), 0.4/20*(1:n)'];
MT = [MT; MTadd];
 
% plot MTs
figure(1);
global plusendRho;
plusendRho = calcplusendRho(MT);
plot(xbin, plusendRho)

nucleationscenario = 2;

% plot newly nucleated, MT2MT
daughters1 = [];
for i = 1:length(MT)
    daughter = [];
    parent_MT = MT(i,:);
    if (parent_MT(1)==0)&&(parent_MT(2)==parent_MT(3))
%         disp('input is a shrinking MT with length zero');
    else
        daughter = nucleation_MT2MT(parent_MT, dt);
        if any(daughter)
            daughters1 = [daughters1; daughter];
        end
    end
end
figure(2); hold on;
plot(xbin,calcplusendRho(daughters1), 'b.')

% plot newly nucleated, spatial
daughters2 = [];
for i = 1:length(xbin)
    daughter = nucleation_spatial(xbin, i, dt);
    daughters2 = [daughters2; daughter];
end
figure(2); hold on;
plot(xbin,calcplusendRho(daughters2), 'r.')

