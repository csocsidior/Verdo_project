%%
clear all;
t=0:1:120; % Time vector
 
%//////////Identification//////////
load('dk_1.mat');
load('dk_2.mat');
load('p_A.mat');
load('p_B.mat');
load('p_C.mat');
load('pk_1.mat');
load('pk_2.mat');
dk_2 = dk_2*-1; 

%for calculating sigma:
load('HL7_demand.mat');   
load('HL14_flow.mat');  %in  
load('NY118_flow.mat'); %out
load('HL10_demand.mat');   
load('HL11_demand.mat');   
load('HogL52_demand.mat'); 

sigma = -HL10_demand - HL11_demand -HL7_demand - HogL52_demand + dk_1 + dk_2;

%removing the first day calculation

n=24;
dk_1(1:n,:) = [];   
dk_2(1:n,:) = []; 
p_A(1:n,:) = [];
p_B(1:n,:) = [];
p_C(1:n,:) = [];
pk_1(1:n,:) = [];
pk_2(1:n,:) = [];
sigma(1:n,:) = [];

%%
%Training set for the output identification
X_K = [sigma, p_A, p_B, p_C, dk_1, dk_2]';   %add elevations! 
Y_K = [pk_1, pk_2]';


%%

%% Output identification

spread = 150;                 %145 
% number of neurons
K = 6;                       %6
% performance goal 
goal = 0.001;
% neuron step
Ki = 1;

net = newrb(X_K,Y_K,goal,spread,K,Ki);
Y_net = net(X_K);
a{1} = radbas(netprod(dist(net.IW{1,1},X_K),net.b{1}));

 chi_K = [a{1} ; p_A' ; p_B'; p_C'; ones(1,121)];
 theta_K = Y_K/chi_K
 Z_K = theta_K*chi_K;
 
 figure(10)
stairs(t,Z_K(1,:),'LineWidth',1.2)
 hold on
 stairs(t,pk_1,'LineWidth',1.2)
  figure(11)
stairs(t,Z_K(2,:),'LineWidth',1.2)
 hold on
 stairs(t,pk_2,'LineWidth',1.2)
 
 cost_func = 'NRMSE';
 fit_pk1 = 100*goodnessOfFit(Z_K(1,:)',pk_1,cost_func)
 fit_pk2 = 100*goodnessOfFit(Z_K(2,:)',pk_2,cost_func)


%% Figures

figure(1)
stairs(t,sigma,'LineWidth',1.2)
xlim([0 120])
ylim([15 108])
xlabel('Time [h]','interpreter','latex');
 ylabel('Flow  [LPS]','interpreter','latex')
 title('Total water consumption - $\sigma$','Interpreter', 'latex');
 
%% 

figure(2)
stairs(t,dk_2,'LineWidth',1.2)
hold on
stairs(t,dk_1,'LineWidth',1.2)
ylim([0 105])
xlim([0 120])
xlabel('Time [h]','interpreter','latex');
ylabel('Flow  [LPS]','interpreter','latex')
h1 = legend('$\bar{d}_{\mathcal{K}1}$','$\bar{d}_{\mathcal{K}2}$','Location','NorthEast');
set(h1, 'Interpreter', 'latex');
title('Inlet flows','Interpreter', 'latex');


%% Don't export this
figure(3)
stairs(t,pk_1,'LineWidth',1.2)
xlim([0 121])

%% Don't export this
figure(4)
stairs(t,pk_2,'LineWidth',1.2)
xlim([0 121])

%%

figure(5)
stairs(t,p_A,'LineWidth',1.2)
hold on
stairs(t,p_B,'LineWidth',1.2)
xlim([0 120])
ylim([2.45 3.1])
xlabel('Time [h]','interpreter','latex');
ylabel('Head  [m]','interpreter','latex')
h1 = legend('$\hat{p}_{\mathcal{W}1}$','Location','SouthEast');
set(h1, 'Interpreter', 'latex');

%%
figure(6)
stairs(t,p_B,'LineWidth',1.2)
xlim([0 120])
ylim([2.92 3.02])
xlabel('Time [h]','interpreter','latex');
ylabel('Head  [m]','interpreter','latex')
h1 = legend('$\hat{p}_{\mathcal{W}2}$','Location','SouthEast');
set(h1, 'Interpreter', 'latex');

%%

figure(7)
stairs(t,p_C,'LineWidth',1.2)
xlim([0 120])
ylim([2.52 2.77])
xlabel('Time [h]','interpreter','latex');
ylabel('Head  [m]','interpreter','latex')
h1 = legend('$\hat{p}_{\mathcal{W}2}$','Location','SouthEast');
set(h1, 'Interpreter', 'latex');

