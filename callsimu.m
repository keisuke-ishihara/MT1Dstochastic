clear all;

global xbin boundarycondition;
boundarycondition = 3;
xbin = 0.5:2:200;

dts = [0.04];
% dts = 0.5;
Ni = 500;

res = [];

for i = 1:length(dts)
    [meanofd confidence] = MTsimulation(Ni, dts(i));
    res = [res; meanofd confidence'];    
end

v_p   =  8.8;       v_d   = 13.7;
f_cat = 0.05*60;    f_res = 0.006*60;
J = (v_p*f_res - v_d*f_cat)/(f_cat+f_res);
D = v_p*v_d/(f_cat+f_res);
tau =4*D/J^2;
L = D/abs(J);


% num = length(dts);
% 
% figure; hold on;
% plot(-log(dts), res(:,2), 'b', -log(dts), res(:,3), 'b')
% plot(-log(dts), L*ones(1,num), 'r') 
% plot(-log(dts), L*ones(1,num), 'r*') 