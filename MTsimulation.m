function result = MTsimulation(Ni,dt)

% this code simulates individual MTs using growing and shrinking functions
% outer loop is timestep, inner loop is MT updates
%
%       MT(i,:) = [is(growing) pos_minusend pos_plusend]
%

tic

%% specify simulation conditions

global xbin tmax Nmax;
global nucleationscenario;

MT = zeros(Nmax,3);    % array for storing MTs
n_tp = 1;

%% run simulation

% initialize MT array
MT(1:Ni,:) = [1*ones(Ni,1) 0*ones(Ni,1) 3*ones(Ni,1)];

counter = Ni;             % keeps track no. of MTs to loop, initialize with Ni
counter_next = 0;

% array for storing simulation results at certain time intervals
% will be 3d array
result = MT;

% simulates in forward time
for t = dt:dt:tmax
    
    % calculate the density of plus ends
    global plusendN;
    plusendN = hist([MT(MT(:,3)~=0, 3)], xbin);
        
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
    for i = 1:counter       
               
        daughter = nucleation_MT2MT(MT(i,:),dt,nucleationscenario);
        % keep daughter unless it is [0 0 0]
        if any(daughter)
            counter_next = counter_next + 1;
            MT(counter_next,:) = daughter;
        end
    end
    counter = counter_next; counter_next = 0;
    
   if counter > Nmax
       disp('too many MTs'); counter
       stop
   end

    if mod(t,1.5)==0
%         plusends  = [plusends; hist(MT(any(MT,2),2),xbin)];
%         minusends = [minusends; hist(MT(any(MT,2),3),xbin)];
        n_tp = n_tp+1;
        result(:,:,n_tp) = MT;
    end 

end

toc

end