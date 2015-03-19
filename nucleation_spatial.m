function [ newMTs ] = nucleation_spatial(MT, counter, midpts, time)
%NUCLEATION_SPATIAL 
% consider different scenarios for MT-stimulated MT nucleation
% 
% scenario = 1;   plus-end bifurcation
% scenario = 2;   plus-end bifurcation with saturation to local plusendRho
% scenario = 3;   MT polymer stimulated nucleation
% scenario = 4;   MT polymer with saturation to local mtRho
% 

global nucscenario nucrate;
global needplusendNumber needmtNumber;
global plusendCap mtCap;

% calculate numbers as necessary
if needplusendNumber 
    plusendNumber = calcplusendNumber(MT, counter, midpts);
end
if needmtNumber
    mtNumber = calcmtNumber(MT, counter, midpts);
end

% lambda: the rate of nucleation in a given position

if nucscenario == 1
    lambdas = nucrate*plusendNumber;
elseif nucscenario == 2
    u = plusendNumber/plusendCap;
    u(u>1) = 1;
    lambdas = nucrate*plusendNumber.*(1-u);
elseif nucscenario == 3
    lambdas = nucrate*mtNumber;
elseif nucscenario == 4
    u = mtNumber/mtCap;
    u(u>1) = 1;
    lambdas = nucrate*mtNumber.*(1-u);
else
    disp('error nucleation'); stop
end

% loop through spatial bin
newMTs = [];
halfw = 0.5*(midpts(2)-midpts(1));
for j = 1:length(midpts)

    L_bin = midpts(j)-halfw;   % left boundary of bin
    R_bin = midpts(j)+halfw;   % right boundary of bin

    n = poissrnd(lambdas(j)*time);  % determine how many MTs nucleated in this bin

    if n > 1
        pos = unifrnd(L_bin, R_bin,n,1);
        new = [ones(n,1), pos, pos, zeros(n,1)];         % new length zero MTs
        newMTs = [newMTs; new];
    end
    
end

