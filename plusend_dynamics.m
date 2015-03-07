function [ MT_new ] = plusend_dynamics(MT, time)
% Plus-end dynamics for both growing and shrinking MTs as inputs.
% 
% depolyreg = 1; plusendRho dependent regulation
% depolyreg = 2; mtRho dependent regulation
%
% What happens when plus end reach minus end?
% boundarycondition = 1, instant rescue
% boundarycondition = 2, disappear
% boundarycondition = 3, disappear unless minus end is at origin, then rescue

global boundarycondition depolyreg plusendRho mtRho xbin;
global v_poly v_depoly f_cat f_res;

if (MT(1)==0)&&(MT(2)==MT(3))
    disp('input is shrinking MT with length zero'); stop
end

if (MT(2) > MT(3))
    disp('negative length MT'); stop
end

% for growing plus-end
if MT(1) == 1
    t_poly = exprnd(1/f_cat);

    if t_poly > time
        MT_new = [1 MT(2) MT(3)+v_poly*time]; 
    else
        MT_new = [0 MT(2) MT(3)];   % switch to shrinking
    end
    
    % for shrinking plus-end
elseif MT(1) == 0     
    t_depoly = exprnd(1/f_res);
        
    if t_depoly > time
        
        % regulation of depolymerization
        if depolyreg == 1
            
            y = hist(MT(3), xbin);              
            index = sum((1:length(xbin)).*y);
            density = plusendRho(index);            % plusendRho dep
            v_depoly_mod = v_depoly+36*density/(1+density);
            
        elseif depolyreg == 2

            y = hist(MT(3), xbin);              
            index = sum((1:length(xbin)).*y);
            density = mtRho(index);                 % mtRho dep
            v_depoly_mod = v_depoly+36*density/(1+density);
            
        else
            v_depoly_mod = v_depoly;
        end
        
        if MT(3)-MT(2)-v_depoly_mod*time < 0
            if boundarycondition == 1
                MT_new = [1 MT(2) MT(2)];
            elseif boundarycondition == 2
                MT_new = [0 0 0];
            elseif boundarycondition == 3
                if MT(2) == 0
                    MT_new = [1 MT(2) MT(2)];
                else
                    MT_new = [0 0 0];
                end
            else
                disp('minus end scenario unspecified'); stop
            end
        else
            MT_new = [0 MT(2) MT(3)-v_depoly_mod*time];
        end
    else
        MT_new = [1 MT(2) MT(3)];   % switch to growing
    end
    
    
else
    disp('error: MT is neither growing or shrinking'); stop
end

end