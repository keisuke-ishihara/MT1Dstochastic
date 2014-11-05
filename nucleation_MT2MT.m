function [ daughter_MT ] = nucleation_MT2MT(parent_MT, time, sc)
%NUCLEATION_MT2MT Summary of this function goes here
%   Detailed explanation goes here

global nucrate;

if (parent_MT(1)==0)&&(parent_MT(2)==parent_MT(3))
    disp('input is a shrinking MT with length zero'); stop
end

% consider different scenarios for MT-stimulated MT nucleation
% 
% scenario = 1;   bifurcation of plus-end, generate growing MT of length zero
% scenario = 2;
% scenario = 3;
% 

scenario = sc;

daughter_MT = [0 0 0];

if scenario == 1
    
    if exprnd(1/nucrate) < time
        % bifurcation of plus-end occurs
        daughter_MT = [1 parent_MT(3) parent_MT(3)];
    end
    
elseif scenario == 2
    
    
end


end

