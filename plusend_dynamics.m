function [ MT_new ] = plusend_dynamics(MT, time)
% Plus-end dynamics for both growing and shrinking MTs as inputs.
% 
% depolyreg = 1; plusend dependent regulation
% depolyreg = 2; mt dependent regulation
%
% What happens when plus end reach minus end?
% boundarycondition = 1, instant rescue
% boundarycondition = 2, disappear
% boundarycondition = 3, disappear unless minus end is at origin, then rescue

global boundarycondition depolyreg;
global v_poly v_depoly f_cat f_res;
global plusendCap mtCap;
global plusendNumber mtNumber midpts;


if (MT(1)==0)&&(MT(2)==MT(3))
    disp('input is shrinking MT with length zero'); stop
end

if (MT(2) > MT(3))
    disp('negative length MT'); stop
end

% for growing plus-end
if MT(1) == 1

    if MT(3)==MT(2)
        % exception for zero-length growing MTs
        t_poly = time;
        MT_new = [1 MT(2) MT(3)+v_poly*time MT(4)+time]; 
    else   
        t_poly = exprnd(1/f_cat);
        if t_poly > time
            MT_new = [1 MT(2) MT(3)+v_poly*time MT(4)+time]; 
        else
            MT_new = [0 MT(2) MT(3) MT(4)+time];   % switch to shrinking
        end
    end
       
% for shrinking plus-end
elseif MT(1) == 0     
    t_depoly = exprnd(1/f_res);
        
    if t_depoly > time
        
        % regulation of depolymerization
        if depolyreg == 0
            v_depoly_mod = v_depoly;
            
        elseif depolyreg == 1
            y = hist(MT(3), midpts);              
            index = sum((1:length(midpts)).*y);
            density = plusendNumber(index)/plusendCap;
            v_depoly_mod = v_depoly+50*density;     % function arbitrary
            
        elseif depolyreg == 2
            y = hist(MT(3), midpts);              
            index = sum((1:length(midpts)).*y);
            density = mtNumber(index)/mtCap;                 
            v_depoly_mod = v_depoly+50*density;     % function arbitrary
            
        else
            disp('undefined depolyreg'); stop
        end
        
        if MT(3)-MT(2)-v_depoly_mod*time < 0
            if boundarycondition == 1
                MT_new = [1 MT(2) MT(2) 0];
            elseif boundarycondition == 2
                MT_new = [0 0 0 0];
            elseif boundarycondition == 3
                if MT(2) == 0
                    MT_new = [1 MT(2) MT(2) 0];
                else
                    MT_new = [0 0 0 0];
                end
            else
                disp('minus end scenario unspecified'); stop
            end
        else
            MT_new = [0 MT(2) MT(3)-v_depoly_mod*time MT(4)+time];
        end
    else
        MT_new = [1 MT(2) MT(3) MT(4)+time];   % switch to growing
    end
    
    
else
    disp('error: MT is neither growing or shrinking'); stop
end

end