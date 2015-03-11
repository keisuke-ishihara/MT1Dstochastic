function [ daughter_MT ] = nucleation_MT2MT(parent_MT, time)
%NUCLEATION_MT2MT Summary of this function goes here
%   Detailed explanation goes here

global xbin;
global nucleationscenario nucrate;
global plusendRho mtRho;

if (parent_MT(1)==0)&&(parent_MT(2)==parent_MT(3))
    disp('input is a shrinking MT with length zero'); stop
end

% consider different scenarios for MT-stimulated MT nucleation
% 
% scenario = 1;   plus-end bifurcation
% scenario = 2;   plus-end bifurcation with saturation to local plusendRho
% scenario = 3;   MT polymer stimulated nucleation
% scenario = 4;   MT polymer with saturation to local mtRho
% 
% assumption: time step is small enough, only one nucleation per parent MT
%

daughter_MT = [0 0 0];

if nucleationscenario == 1
    
    if exprnd(1/nucrate) < time
        daughter_MT = [1 parent_MT(3) parent_MT(3)];
    end
    
elseif nucleationscenario == 2
    
    % parent_MT plusend position defines local
    index = hist(parent_MT(3), xbin).*(1:length(xbin));
    index(index(:)==0) = [];
    cof = min(plusendRho(index),1);
    if exprnd(1/nucrate/abs((1-cof))) < time
        daughter_MT = [1 parent_MT(3) parent_MT(3)];
    end

elseif nucleationscenario == 3
    
    L = MT(3)-MT(2);    % length of parent MT
    
    if exprnd(1/nucrate/L) < time
        pos = unifrnd(parent_MT(2), parent_MT(3));
        daughter_MT = [1 pos pos];
    end
    
% elseif nucleationscenario == 4
%     
%     % this needs work here!! not trivial
%     index = hist(parent_MT(3), xbin).*(1:length(xbin));
%     L = MT(3)-MT(2);    % length of parent MT
%     
%     if exprnd(1/nucrate/L//(1-mtRho)) < time
%         pos = unifrnd(parent_MT(2), parent_MT(3));
%         daughter_MT = [1 pos pos];
%     end
    
end


end

