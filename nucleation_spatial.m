function [ newMTs ] = nucleation_spatial( xbin, j, time )
%NUCLEATION_SPATIAL 
% consider different scenarios for MT-stimulated MT nucleation
% 
% scenario = 1;   plus-end bifurcation
% scenario = 2;   plus-end bifurcation with saturation to local plusendRho
% scenario = 3;   MT polymer stimulated nucleation
% scenario = 4;   MT polymer with saturation to local mtRho
% 

global nucleationscenario nucrate;
global plusendRho mtRho;
global plusendCap mtCap xbinwidth;

% lambda: the rate of nucleation in a given position

if nucleationscenario == 1
    lambda = nucrate*plusendCap*xbinwidth*plusendRho(j);
elseif nucleationscenario == 2
    lambda = nucrate*plusendCap*xbinwidth*plusendRho(j)*max(1-plusendRho(j), 0);
elseif nucleationscenario == 3
    lambda = nucrate*mtCap*xbinwidth*mtRho(j);
elseif nucleationscenario == 4
    lambda = nucrate*mtCap*xbinwidth*mtRho(j)*max(1-mtRho(j), 0);
end

halfw = 0.5*xbinwidth;
L_bin = max(xbin(j)-halfw, xbin(1));   % left boundary of bin
R_bin = min(xbin(j)+halfw, xbin(end));   % right boundary of bin

n = poissrnd(lambda*time);  % determine how many MTs nucleated in this bin

newMTs = [];
if n > 1
    pos = unifrnd(L_bin, R_bin,n,1);
    newMTs = [ones(n,1), pos, pos];         % new length zero MTs
end

end

