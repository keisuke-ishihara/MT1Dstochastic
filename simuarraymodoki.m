clc;

% place this file in directory (eg. 20150330_1) that contains
% the param files to simulate

addpath(strcat(fileparts(fileparts(pwd)),'/MT1Dstochastic/'));

mkdir param1_out
copyfile('param1.mat', strcat(pwd,'/param1_out/param.mat'))
curr = cd('param1_out');
run callsimu.m
delete param.mat
cd ..

mkdir param2_out
copyfile('param2.mat', strcat(pwd,'/param2_out/param.mat'))
curr = cd('param2_out');
run callsimu.m
delete param.mat
cd ..

rmpath(strcat(fileparts(fileparts(pwd)),'/MT1Dstochastic/'));
