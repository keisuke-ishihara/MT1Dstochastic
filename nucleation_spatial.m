function [ newMTs ] = nucleation_spatial( xbin, j, time )
%NUCLEATION_SPATIAL Summary of this function goes here
%   Detailed explanation goes here
%
% consider different scenarios for MT-stimulated MT nucleation
% 
% scenario = 1;   plus-end bifurcation
% scenario = 2;   plus-end bifurcation with saturation to local plusendRho
% scenario = 3;   MT polymer stimulated nucleation
% scenario = 4;   MT polymer with saturation to local mtRho
% 

global nucleationscenario nucrate;
global plusendRho mtRho;
global plusendCap mtCap;

% lambda: the rate of nucleation in a given position

if nucleationscenario == 1
    lambda = nucrate*plusendCap*plusendRho(j);
elseif nucleationscenario == 2
    lambda = nucrate*plusendCap*plusendRho(j)*max(1-plusendRho(j), 0);
elseif nucleationscenario == 3
    lambda = nucrate*mtCap*mtRho(j);
elseif nucleationscenario == 4
    lambda = nucrate*mtCap*mtRho(j)*max(1-mtRho(j), 0);
end

halfw = (xbin(2)-xbin(1))/2;
L_bin = max(xbin(j)-halfw, min(xbin));   % left boundary of bin
R_bin = min(xbin(j)+halfw, max(xbin));   % right boundary of bin

n = poissrnd(lambda*time);  % determine how many MTs nucleated in this bin

newMTs = [];
if n > 1
    pos = unifrnd(L_bin, R_bin,n,1);
    newMTs = [ones(n,1), pos, pos];         % new length zero MTs
end

end

