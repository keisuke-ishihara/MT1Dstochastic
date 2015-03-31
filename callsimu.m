clear all;

wd = cd();
wd
load('param.mat');

tic
for i = 1:n_rep
    cd ~/MT1Dstochastic % comment this line for local test
   	[time, result] = MTsimulation();
% 	filename = strcat('result',num2str(i),'.mat');
	filename = strcat('result',sprintf('%04.0f',i),'.mat');
    cd(wd); % comment this line for local test
    save(filename);

    % display progress of simulation
    out1 = strcat('Simulation', {' '}, num2str(i), ' out of ', {' '}, num2str(n_rep), '.', {' '}); 
    out2 = strcat('Elapsed time is', {' '}, num2str(toc), {' '}, 'seconds.');
    strcat(out1,out2)
   
end
