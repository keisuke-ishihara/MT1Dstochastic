function [time, result] = MTsimulation(Ni,dt)

% this code simulates individual MTs using growing and shrinking functions
% 
%       MT(i,:) = [is(growing) pos_minusend pos_plusend]
%

%% Step 0: specify simulation conditions

global xbin tmax Nmax plusendCap mtCap;
global depolyreg nucleationscenario;
global plusendRho mtRho;

needplusendRho = (depolyreg==1)|(nucleationscenario==2);
needmtRho = (depolyreg==2)|(nucleationscenario==4);

MT = zeros(Nmax,3);    % array for storing MTs for timepoints
curr_tp = 1;           % no. of timepoints for data storage


%% Step 1: initialization of MT array

MT(1:Ni,:) = [1*ones(Ni,1) 0*ones(Ni,1) 5*ones(Ni,1)];

counter = Ni;             % keeps track no. of MTs to loop, initialize with Ni
counter_next = 0;

% arrays for storing simulation results at certain time intervals
% will be 3d array
time   = [0]; 
result = MT;

%% Step 2: simulates in forward time

for t = dt:dt:tmax
    
    
    % first, apply plus end dynamics
    
    % calculate densities if necessary
    if needplusendRho 
        plusendRho = calcplusendRho(MT);
    end
    if needmtRho
        mtRho = calcmtRho(MT,counter);
    end
        
    % loop through the MT array to update plus end positions
    for i = 1:counter        
 
        updated = plusend_dynamics(MT(i,:),dt);
        MT(i,:) = [0 0 0];
        
        % keep 'updated' unless it is shrinking length zero
        if ~((updated(1)==0)&&(updated(2)==updated(3)))
            counter_next = counter_next + 1;
            MT(counter_next,:) = updated;
        end       
        
    end
    counter = counter_next;
    
    
    % next, nucleate microtubules
    
    % loop through the spatial bin to nucleate MT
    if nucleationscenario ~= 0
   
        % re-calculate densities if necessary
        if needplusendRho 
            plusendRho = calcplusendRho(MT);
        end
        if needmtRho
            mtRho = calcmtRho(MT,counter);
        end
        
        % generate new MTs
        newMTs = [];
        for j = 1:length(xbin)
            new = nucleation_spatial(xbin,j,dt);            
            newMTs =[newMTs; new];
        end
     
        % add new MTs to system
        s_newMTs = size(newMTs);
        nnew = s_newMTs(1);
        if nnew > 1
            if counter+nnew > Nmax
                disp('too many MTs nucleated'); stop
            else
                MT((counter+1):(counter+nnew), :) = newMTs;
                counter = counter + nnew;
            end
        end
        
    end
    
% %     newMTs2 = [];
%     % loop through the MT array to nucleate MT
%     if nucleationscenario ~= 0
%         
%         % re-calculate densities if necessary
%         if needplusendRho 
%             plusendRho = calcplusendRho(MT);
%         end
%         if needmtRho
%             mtRho = calcmtRho(MT,counter);
%         end
% 
%         for i = 1:counter       
%             daughter = nucleation_MT2MT(MT(i,:),dt);
%             % keep daughter unless it is [0 0 0]
%             if any(daughter)
%                 counter_next = counter_next + 1;
%                 MT(counter_next,:) = daughter;
% %                 newMTs2 =[newMTs2; daughter];
%             end
%         end
%         counter = counter_next;
%     end
%     
%     if ~exist('rs')
%         rs = [];
%     end
%     if ~isempty(newMTs)
%         newMTs
%         newMTs2
%         
%         tempa = size(newMTs);
%         tempb = size(newMTs2);
%         rs = [rs tempb/tempa];
%         mean(rs)
%         std(rs)
%     end
    
%     % check if there are too many MTs in the system
%     if counter > Nmax
%        disp('too many MTs');
%        Nmax
%        counter
%        plusends = hist(MT(any(MT,2),3),xbin); plot(xbin, plusends);
%        stop
%     end
    
    % finally, store time and MT state every half minute
    if mod(t,1) < dt
        curr_tp = curr_tp+1;
        time(curr_tp) = t;
        result(:,:,curr_tp) = MT;
    end
    
    % initialize counter_next before next time loop, just in case
    counter_next = 0;

end

end