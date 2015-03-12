function [ out ] = calcplusendRho(MT)
%CALCPLUSENDRHO
% 
% calculate plus-end densities in spatial bin, normalized with plusendCap
% postion is centered around value of elements in xbin
% 

    global xbin plusendCap;   
    out = (hist(MT(MT(:,3)~=0, 3), xbin))/plusendCap;

end

