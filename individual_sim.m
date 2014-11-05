% this code simulates individual MTs using growing and shrinking functions
% outer loop is MTs, inner loop is time step
% the mean MT lenght in the simulation is predicted by L = D/|J|

clc; clear all;

N = 10000; % number of MTs to simualate

dt = 0.1;
result = zeros(N,3);

for i = 1:N
    
    MT = [1 0 4];
    for t = 0:dt:10
        if MT(1) == 1
            MT_new = plusend_growing(MT,dt);
        else
            MT_new = plusend_shrinking(MT,dt);
        end
        MT = MT_new;
    end
    
    result(i,:) = MT;
    
end

figure(1);
bin = 0.5:1:50;
histpos = hist(result(:,3),bin);
plot(bin, histpos)

mean(result(:,3))

v_p   =  8.8; 
v_d   = 13.7;
f_cat = 0.05*60;
f_res = 0.006*60;
J = (v_p*f_res - v_d*f_cat)/(f_cat+f_res);
D = v_p*v_d/(f_cat+f_res);
L = D/abs(J)


