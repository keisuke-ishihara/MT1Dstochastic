function [meanofd confidence] = MTsimulation(Ni,dt)

% this code simulates individual MTs using growing and shrinking functions
% outer loop is timestep, inner loop is MT updates
%
%       MT(i,:) = [is(growing) pos_minusend pos_plusend]
%

% clear all;

tic


%% specify simulation conditions

global xbin;

% dt = 0.2;           % time step [minutes]
tmax = 10;          % when to end simulation [minutes]

N  = 100000;           % max number of MTs to simulate
MT = zeros(N,3);    % array for storing MTs

sc = 1;             % scenario for nucleation
% bc = 3;             % boundary condition for minus ends

%% run simulation

% initialize MT array
% Ni = 3000;
MT(1:Ni,:) = [1*ones(Ni,1) 0*ones(Ni,1) 3*ones(Ni,1)];

counter = Ni;             % keeps track no. of MTs to loop, initialize with Ni
counter_next = 0;

% array for storing end positions
plusends = []; minusends = [];
  

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
               
        daughter = nucleation_MT2MT(MT(i,:),dt,sc);
        % keep daughter unless it is [0 0 0]
        if any(daughter)
            counter_next = counter_next + 1;
            MT(counter_next,:) = daughter;
        end
    end
    counter = counter_next; counter_next = 0;
    
   if counter > N
       disp('too many MTs'); counter
       stop
   end

    if mod(t,1.5)==0
        plusends  = [plusends; hist(MT(any(MT,2),2),xbin)];
        minusends = [minusends; hist(MT(any(MT,2),3),xbin)];
    end 

end

toc

v_p   =  8.8;       v_d   = 13.7;
f_cat = 0.05*60;    f_res = 0.006*60;
J = (v_p*f_res - v_d*f_cat)/(f_cat+f_res);
D = v_p*v_d/(f_cat+f_res);
tau =4*D/J^2;
L = D/abs(J);

% dt

lengths = MT(MT(:,3)~=0, 3)-MT(MT(:,3)~=0, 2);
size(lengths)

pd = fitdist(lengths,'Exponential');
confidence = paramci(pd);
meanofd = mean(pd);

figure
hist(MT(MT(:,3)~=0,3))


h1 = figure;
set(0,'DefaultAxesFontSize', 16)
set(0, 'DefaultFigurePosition', [10 10 350 250]);

s = size(plusends);
[grad,im] = colorGradient([0 0.6 1],[1 0.1 0], s(1));

hold on;
for i = 1:s(1)
    plot(xbin, plusends(i,:), '.', 'Color', grad(i,:), 'MarkerSize', 14);
end
% axis([0 160 0 300])
% set(gca,'XTick',0:40:160)
% set(gca,'YTick',0:500:2000)
