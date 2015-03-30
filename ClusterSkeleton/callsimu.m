n = 3;
wd = cd;
for i = 1:n
	cd ~/MT1Dstochastic
	out = MTsimulation(i,wd);
	filename = strcat(out,num2str(i),'.mat');
	
	cd (wd);
	save(filename);
end

