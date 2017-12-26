t=0:1:144; % Time vector

%% 
%//////////Identification//////////
load('dk_1.mat');
load('dk_2.mat');
load('p_A.mat');
load('p_B.mat');
load('p_C.mat');
load('pk_1.mat');
load('pk_2.mat');
dk_2 = dk_2*-1;


%for test:
load('HL7_demand.mat');   
load('HL14_flow.mat');  %in  
load('NY118_flow.mat'); %out
load('HL10_demand.mat');   
load('HL11_demand.mat');   
load('HogL52_demand.mat');  

figure(1)
stairs(t,-HL10_demand - HL11_demand -HL7_demand - HogL52_demand + dk_1 + dk_2,'LineWidth',1.2)
xlim([25 149])
%  hold on
%  stairs(t,dk_1 + dk_2,'LineWidth',1.2)
%  hold on
 % stairs(t,HL10_demand + HL11_demand,'LineWidth',1.2)

figure(2)
stairs(t,dk_1,'LineWidth',1.2)
hold on
stairs(t,dk_2,'LineWidth',1.2)
xlim([25 149])

figure(3)
stairs(t,pk_1,'LineWidth',1.2)
xlim([25 149])

figure(4)
stairs(t,pk_2,'LineWidth',1.2)
xlim([25 149])

figure(5)
stairs(t,p_A,'LineWidth',1.2)
xlim([25 149])

figure(6)
stairs(t,p_B,'LineWidth',1.2)
xlim([25 149])

figure(7)
stairs(t,p_C,'LineWidth',1.2)
xlim([25 149])
