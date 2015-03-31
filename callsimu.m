clear all;

wd = cd();
load('param.mat');

tic
for i = 1:n_rep
    
   	[time, result] = MTsimulation();
% 	filename = strcat('simu',num2str(i),'.mat');
	filename = strcat('simu',sprintf('%04.0f',i),'.mat');
	save(filename);
    
end
toc