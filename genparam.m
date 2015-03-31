clear all;

workingpath = strcat(fileparts(pwd),'/experiments_MT1Dstoch/20150330_1');

global xbin tmax Nmax midpts;
xbinwidth = 4;              % in microns
xbin = 0:xbinwidth:200;  
midpts = (xbin(1:end-1)+xbin(2:end))/2;
tmax = 20;
Nmax = 10000;           % max number of MTs to simulate

global plusendCap mtCap;
% define carrying capacities so density is robust to xbinwidth
plusendCap = 2.5*xbinwidth;
mtCap      = 2.5*xbinwidth;

global boundarycondition nucscenario depolyreg;
boundarycondition = 3;
nucscenario = 2;
depolyreg = 0;

global v_poly v_depoly f_cat f_res;
v_poly   =  8.8;    v_depoly   = 13.7; 
f_cat = 0.05*60;    f_res = 0.006*60;

global Ni dt;
dt = 0.04;
Ni = 100;

global nucrate n_rep
nucrate = 1;
n_rep = 2;

J = (v_poly*f_res - v_depoly*f_cat)/(f_cat+f_res);
D = v_poly*v_depoly/(f_cat+f_res);
tau =4*D/J^2;
L = D/abs(J);

save(strcat(workingpath,'/param.mat'));
cd(workingpath);