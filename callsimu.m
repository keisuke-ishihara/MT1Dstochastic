clear all;
load('../param.mat');
scriptdir = fileparts(fileparts(fileparts(pwd)));

tic
for i = 1:n_rep

    old = cd(scriptdir);
    
    nucrate
    [time, result] = MTsimulation();
	filename = strcat('result',sprintf('%04.0f',i),'.mat');

    % display progress of simulation
    out1 = strcat('Simulation', {' '}, num2str(i), ' out of ', {' '}, num2str(n_rep), '.', {' '}); 
    out2 = strcat('Elapsed time is', {' '}, num2str(toc), {' '}, 'seconds.');
    strcat(out1,out2)
    
    cd(old);
    save(filename);
        
end

