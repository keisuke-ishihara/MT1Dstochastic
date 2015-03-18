function [ plusendNo ] = calcplusendNumber(MT, counter, midpts)
%CALCPLUSENDRHO
% 
% calculate plus-end numbers in system
% postion is centered around value of elements in xbin
% MT of [1 0 0] will not be included in the first bin such as (0, 0.5) 
%
    
    plusendNo = hist(MT(MT(1:counter,3)~=0, 3), midpts);

end

