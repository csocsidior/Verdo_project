clear all

%% Case 1

load('dk_1.mat')
load('dk_2.mat')
load('p_h.mat')
load('sigma.mat')
h_h = ones(73,1)*21;

%% Case 2

load('dk_1_mod1.mat')
load('dk_2_mod1.mat')
load('p_h_mod1.mat')
load('sigma_mod1.mat')

%% Pressure calculation - case 1

%Pump 1
pk_1 = 53.33-0.008334.*dk_1.^2;
%Pump 2
pk_2 = 46.67-0.009525.*dk_2.^2;

%% Pressure calculation - case 1

%Pump1
pk_1_mod1 = 53.33-0.008334.*dk_1_mod1.^2;
%Pump2
pk_2_mod1 = 46.67-0.009525.*dk_2_mod1.^2;

%% Identification - Inlet pressures - case 1

X = [sigma, p_h + h_h, dk_1, dk_2]';
Y = [pk_1, pk_2]';

spread = 75;                 %25 %28
% number of neurons
K = 12;                       %10 %8
% performance goal 
goal = 0.0001;
% neuron step
Ki = 1;

net = newrb(X,Y,goal,spread,K,Ki);
Y_net = net(X);

a{1} = radbas(netprod(dist(net.IW{1,1},X),net.b{1}));

%Output weights
net.LW{2,1};
%Output bias
net.b{2};

chi = [a{1} ; (p_h+h_h)' ; ones(1,73)];
theta1 = Y/chi

Y_net_c = theta1*chi;

%% Validation - case 2

X_mod1 = [sigma_mod1, p_h_mod1 + h_h, dk_1_mod1, dk_2_mod1]';
Y_mod1 = [pk_1_mod1, pk_2_mod1]';

Y_net_mod1 = net(X_mod1);

a_mod1{1} = radbas(netprod(dist(net.IW{1,1},X_mod1),net.b{1}))
chi_mod1 = [a_mod1{1} ; (p_h_mod1+h_h)' ; ones(1,73)];

Y_net_mod1_c = theta1*chi_mod1

%% Identification - WT pressure - case 1


%% Plots
t=0:1:72; % Time vector

set(0,'DefaultFigureVisible','on')
% 
% figure(1)
% stairs(t,pk_1(:,1),'LineWidth',1.2)
% hold on
% stairs(t,pk_2(:,1),'LineWidth',1.2)
% xlim([0 73])
% title('Inlet pressure - $\bar{p}_{\mathcal{K},1}$','interpreter','latex')
% xlabel('Time [h]','interpreter','latex');
% ylabel('Pressure  [m]','interpreter','latex')
% 
figure(1)
stairs(t,dk_1(:,1),'LineWidth',1.2)
hold on
stairs(t,dk_2(:,1),'LineWidth',1.2)
xlim([0 73])
title('Inlet flow - $\bar{d}_{\mathcal{K},1}$','interpreter','latex')
xlabel('Time [h]','interpreter','latex');
ylabel('Flow  [LPS]','interpreter','latex')

set(0,'DefaultFigureVisible','on')
figure(3)
stairs(t,pk_1,'LineWidth',1.2)
hold on
stairs(t,Y_net_c(1,:),'LineWidth',1.2)
xlim([0 73])
title('Inlet pressure - $\bar{p}_{\mathcal{K},1}$','interpreter','latex')
xlabel('Time [h]','interpreter','latex');
ylabel('Pressure  [m]','interpreter','latex')

set(0,'DefaultFigureVisible','on')
figure(4)
stairs(t,pk_2,'LineWidth',1.2)
hold on
stairs(t,Y_net_c(2,:),'LineWidth',1.2)
xlim([0 73])
title('Inlet pressure - $\bar{p}_{\mathcal{K},2}$','interpreter','latex')
xlabel('Time [h]','interpreter','latex');
ylabel('Pressure  [m]','interpreter','latex')

set(0,'DefaultFigureVisible','on')
figure(5)
stairs(t,pk_1_mod1,'LineWidth',1.2)
hold on
stairs(t,Y_net_mod1_c(1,:),'LineWidth',1.2)
xlim([0 73])
title('Validation 1 - $\bar{p}_{\mathcal{K},1}$','interpreter','latex')
xlabel('Time [h]','interpreter','latex');
ylabel('Pressure  [m]','interpreter','latex')

set(0,'DefaultFigureVisible','on')
figure(6)
stairs(t,pk_2_mod1,'LineWidth',1.2)
hold on
stairs(t,Y_net_mod1_c(2,:),'LineWidth',1.2)
xlim([0 73])
title('Validation 1 - $\bar{p}_{\mathcal{K},2}$','interpreter','latex')
xlabel('Time [h]','interpreter','latex');
ylabel('Pressure  [m]','interpreter','latex')
