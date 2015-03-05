function [ daughter_MT ] = nucleation_MT2MT(parent_MT, time)
%NUCLEATION_MT2MT Summary of this function goes here
%   Detailed explanation goes here

global nucrate nucleationscenario mtN;

if (parent_MT(1)==0)&&(parent_MT(2)==parent_MT(3))
    disp('input is a shrinking MT with length zero'); stop
end

% consider different scenarios for MT-stimulated MT nucleation
% 
% scenario = 1;   plus-end bifurcation, new growing MT of length zero
% scenario = 2;   dep on MT local polymer density, no saturation
% scenario = 3;   dep on MT local polymer density, logistic
% 

daughter_MT = [0 0 0];

if nucleationscenario == 1
    
    if exprnd(1/nucrate) < time
        % bifurcation of plus-end occurs both growing&shrinking
        daughter_MT = [1 parent_MT(3) parent_MT(3)];
    end
    
elseif nucleationscenario == 2
    
    
end


end

