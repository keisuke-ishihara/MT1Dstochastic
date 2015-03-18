function [ mtNo ] = calcmtNumber(MT, counter, xbin)
%CALCMTRHO 
% 
% calculate no. of MT in system
% postion is centered around value of elements in xbin
% 

    mtNo = zeros(1, length(xbin));
    for i = 1:counter
        minusendbin = hist(MT(i,2), xbin).*(1:length(xbin));
        plusendbin  = hist(MT(i,3), xbin).*(1:length(xbin));  
        minusendbin(minusendbin==0) = [];
        plusendbin(plusendbin==0) = [];
        if minusendbin ~= plusendbin
           % assumption: MT shorter than bin size does not contribute
           add = zeros(1, length(xbin));
           add(minusendbin:plusendbin) = 1;
           mtNo = mtNo + add;
        end            
    end

end

