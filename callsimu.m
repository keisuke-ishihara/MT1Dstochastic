clear all;

wd = cd();
load('param.mat');

tic
for i = 1:n_rep
    cd ~/MT1Dstochastic % comment this line for local test
   	[time, result] = MTsimulation();
% 	filename = strcat('simu',num2str(i),'.mat');
	filename = strcat('result',sprintf('%04.0f',i),'.mat');
    cd(wd); % comment this line for local test
    save(filename);
end
toc