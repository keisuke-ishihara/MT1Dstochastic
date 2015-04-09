function [time, result] = MTsimulation()

% this code simulates individual MTs using growing and shrinking functions
% 
%       MT(i,:) = [is(growing) pos_minusend pos_plusend age]
%

%% Step 0: specify simulation conditions

global xbin midpts tmax Nmax Ni dt;
global depolyreg nucscenario;
global plusendCap mtCap;
global plusendNumber mtNumber needplusendNumber needmtNumber;

needplusendNumber = (depolyreg==1)|((nucscenario==1)|(nucscenario==2));
needmtNumber      = (depolyreg==2)|((nucscenario==3)|(nucscenario==4));

MT      = zeros(Nmax,4);    % array for storing MTs for timepoints

curr_tp = 1;           % no. of timepoints for data storage

%% Step 1: initialization of MT array

MT(1:Ni,:) = [1*ones(Ni,1) zeros(Ni,1) 5*ones(Ni,1) zeros(Ni,1)];

counter = Ni;             % keeps track no. of MTs to loop, initialize with Ni
counter_next = 0;

% arrays for storing simulation results at certain time intervals
% will be 3d array
time   = [0]; 
result = MT;

%% Step 2: simulates in forward time

for t = dt:dt:tmax
      
    % calculate numbers if necessary
    if needplusendNumber 
        plusendNumber = calcplusendNumber(MT, counter, midpts);
    end
    if needmtNumber
        mtNumber = calcmtNumber(MT, counter, midpts);
    end
    
    % apply plus end dynamics to individual MTs
    for i = 1:counter        
 
        updated = plusend_dynamics(MT(i,:),dt);

        % keep 'updated' unless it is shrinking length zero
        if ~((updated(1)==0)&&(updated(2)==updated(3)))
            counter_next = counter_next + 1;
            MT(counter_next,:) = updated;
        end       
        
    end
    counter = counter_next;
    counter_next = 0;    
    
%   nucleate microtubules spatially

    if nucscenario ~= 0
        
        % generate new MTs and add to system
        newMTs = nucleation_spatial(MT, counter, midpts, dt);                 
        
        s_newMTs = size(newMTs);
        nnew = s_newMTs(1);
        if nnew >= 1
            if counter+nnew > Nmax
                disp('too many MTs nucleated'); stop
            else
                MT((counter+1):(counter+nnew), :) = newMTs;
                counter = counter + nnew;
                counter_next = 0;
            end
        end
    end    
   
%   finally, store time and MT state every half minute
    if mod(t,0.5) < dt*0.9999
        curr_tp = curr_tp+1;
        time(curr_tp) = t;
        result(:,:,curr_tp) = [MT(1:counter,:); zeros(Nmax-counter,4)];
    end
    
end



end