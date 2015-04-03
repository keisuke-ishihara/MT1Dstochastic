dirname = '20150403_2';

cd experiments

if exist(dirname) ~= 0
    rmdir(dirname, 's');    
end

mkdir(dirname);
cd(dirname);

clear all;
variation = 0:2:10;

for i = 1:length(variation)
   
    global xbin tmax Nmax midpts;
    xbinwidth = 4;              % in microns
    xbin = 0:xbinwidth:500;  
    midpts = (xbin(1:end-1)+xbin(2:end))/2;
    tmax = 20;
    Nmax = 6000;           % max number of MTs allowed to simulate

    global plusendCap mtCap;
    % define carrying capacities so density is robust to xbinwidth
    plusendCap = 10*xbinwidth;
    mtCap      = 10*xbinwidth;

    global boundarycondition nucscenario depolyreg;
    boundarycondition = 3;
    nucscenario = 2;
    depolyreg = 0;

    global v_poly v_depoly f_cat f_res;
%     v_poly   =  8.8;    v_depoly   = 13.7; 
%     f_cat = 0.05*60;    f_res = 0.006*60;
    
    % these are fake interphase values 20150403
    v_poly   =  12.0;    v_depoly   = 9.3; 
    f_cat = 0.012*60;    f_res = 0.020*60;

    global Ni dt;
    dt = 0.04;          % time step for simulation
    Ni = 50;           % initial number of immortal microtubules at origin

    global nucrate n_rep
    nucrate = variation(i);        % rate of nucleation
    n_rep = 10;          % how many simulations to repeat per condition

    J = (v_poly*f_res - v_depoly*f_cat)/(f_cat+f_res);
    D = v_poly*v_depoly/(f_cat+f_res);
    tau =4*D/J^2;
    L = D/abs(J);

    save(strcat('param',num2str(i),'.mat'));

end

cd ..
cd ..
