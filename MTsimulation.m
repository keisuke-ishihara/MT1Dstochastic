function [time, result] = MTsimulation(Ni,dt)

% this code simulates individual MTs using growing and shrinking functions
% outer loop is timestep, inner loops are MT updates
%
%       MT(i,:) = [is(growing) pos_minusend pos_plusend]
%

%% specify simulation conditions

global xbin tmax Nmax plusendCap mtCap;
global depolyreg nucleationscenario;
global plusendRho mtRho;

calcplusendRho = (depolyreg==1)|(nucleationscenario==2);
calcmtRho = (depolyreg==2)|(nucleationscenario==4);

MT = zeros(Nmax,3);    % array for storing MTs
n_tp = 1;

%% run simulation

% initialize MT array
MT(1:Ni,:) = [1*ones(Ni,1) 0.5*ones(Ni,1) 5*ones(Ni,1)];

counter = Ni;             % keeps track no. of MTs to loop, initialize with Ni
counter_next = 0;

% arrays for storing simulation results at certain time intervals
% will be 3d array
time   = []; 
result = MT;

% simulates in forward time
for t = dt:dt:tmax
    
    % plus-end densities in spatial bin, centered around val of xbin
    if calcplusendRho
        plusendRho = (hist(MT(MT(:,3)~=0, 3), xbin))/plusendCap;
    end
    
    % MT densities in spatial bin
    if calcmtRho
        mtRho = zeros(1, length(xbin));
        for i = 1:counter
            minusendbin = hist(MT(i,2), xbin).*(1:length(xbin));
            plusendbin  = hist(MT(i,3), xbin).*(1:length(xbin));  
            minusendbin(minusendbin==0) = [];
            plusendbin(plusendbin==0) = [];
            if minusendbin ~= plusendbin
               % assumption: MT shorter than bin size does not contribute
               add = zeros(1, length(xbin));
               add(minusendbin:plusendbin) = 1;
               mtRho = mtRho + add;
            end            
        end
        mtRho = mtRho/mtCap;
    end
        
    % loops through the MT array to update plus end positions
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
            
    % loops through the MT array to nucleate MT
    if nucleationscenario ~= 0
        for i = 1:counter       
            daughter = nucleation_MT2MT(MT(i,:),dt,nucleationscenario);
            % keep daughter unless it is [0 0 0]
            if any(daughter)
                counter_next = counter_next + 1;
                MT(counter_next,:) = daughter;
            end
        end
        counter = counter_next;
    end
    
    
    counter_next = 0;
    
    if counter > Nmax
       disp('too many MTs'); counter
       plusends = hist(MT(any(MT,2),3),xbin);
       plot(xbin, plusends);
       stop
    end
    
    % store time and MT state every half minute
    if mod(t,1) < dt
        n_tp = n_tp+1;
        time(n_tp) = t;
        result(:,:,n_tp) = MT;
    end 

end

end