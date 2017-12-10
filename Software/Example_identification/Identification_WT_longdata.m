clear all;
t=0:1:147; % Time vector
%% Case 1

load('dk_1_long.mat')
load('dk_2_long.mat')
load('p_h_long.mat')
load('sigma_long.mat')
h_h = ones(149,1)*21;

% state identification:
dk_1_long(149) = [];
dk_2_long(149) = [];
p_h_longk = p_h_long;
p_h_longk(149) = [];
p_h_long_kplus1 = p_h_long;
p_h_long_kplus1(1) = [];
sigma_long(149) = [];
h_h(149) = [];


%% Identification - Wt pressure - case 1

Xs = [sigma_long, p_h_longk + h_h, dk_1_long, dk_2_long]';
Ys = [p_h_long_kplus1 - p_h_longk]';

spread_s = 8.5;                 %25 %28
% number of neurons
K_s = 30;                       %10 %8
% performance goal 
goal_s = 0.00001;
% neuron step
Ki_s = 1;

net_s = newrb(Xs,Ys,goal_s,spread_s,K_s,Ki_s);
Ys_net = net_s(Xs);

a_s{1} = radbas(netprod(dist(net_s.IW{1,1},Xs),net_s.b{1}));

chi_s = [a_s{1} ; dk_1_long' ; dk_2_long' ; sigma_long' ; ones(1,148)];
theta_s = Ys/chi_s;

Ys_net_c = theta_s*chi_s;

set(0,'DefaultFigureVisible','on')
figure(1)
stairs(t,p_h_long_kplus1,'LineWidth',1.2)
hold on
stairs(t, Ys_net_c' + p_h_longk ,'LineWidth',1.2)
xlim([0 148])
title('Inlet pressure - $\bar{p}_{\mathcal{K},1}$','interpreter','latex')
xlabel('Time [h]','interpreter','latex');
ylabel('Pressure  [m]','interpreter','latex')


