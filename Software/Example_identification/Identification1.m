clear all

t=0:1:72; % Time vector
tk = 0:1:71;

%% Case 1

load('dk_1.mat')
load('dk_2.mat')
load('p_h.mat')
load('sigma.mat')
h_h = ones(73,1)*21;

%for state identification:
dk_1k = dk_1;
dk_1k(73) = [];
dk_2k = dk_2;
dk_2k(73) = [];
p_hk = p_h;
p_hk(73) = [];
p_hkplus1 = p_h;
p_hkplus1(1) = [];
sigmak = sigma;
sigmak(73) = [];
h_hk = h_h;
h_hk(73) = [];

%% Case 2

load('dk_1_mod1.mat')
load('dk_2_mod1.mat')
load('p_h_mod1.mat')
load('sigma_mod1.mat')

%for state validation:
dk_1k_mod1 = dk_1_mod1;
dk_1k_mod1(73) = [];
dk_2k_mod1 = dk_2_mod1;
dk_2k_mod1(73) = [];
p_hk_mod1 = p_h_mod1;
p_hk_mod1(73) = [];
p_hkplus1_mod1 = p_h_mod1;
p_hkplus1_mod1(1) = [];
sigmak_mod1 = sigma_mod1;
sigmak_mod1(73) = [];

%% Case 3

load('dk_1_mod2.mat')
load('dk_2_mod2.mat')
load('p_h_mod2.mat')
load('sigma_mod2.mat')

%for state validation:
dk_1k_mod2 = dk_1_mod2;
dk_1k_mod2(73) = [];
dk_2k_mod2 = dk_2_mod2;
dk_2k_mod2(73) = [];
p_hk_mod2 = p_h_mod2;
p_hk_mod2(73) = [];
p_hkplus1_mod2 = p_h_mod2;
p_hkplus1_mod2(1) = [];
sigmak_mod2 = sigma_mod2;
sigmak_mod2(73) = [];

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

%% Pressure calculation - case 2

%Pump1
pk_1_mod2 = 53.33-0.008334.*dk_1_mod2.^2;
%Pump2
pk_2_mod2 = 46.67-0.009525.*dk_2_mod2.^2;

%% Identification - Inlet pressures - case 1

X = [sigma, p_h + h_h, dk_1, dk_2]';
Y = [pk_1, pk_2]';

spread = 70;                 %25 %28
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
theta_k = Y/chi

Y_net_c = theta_k*chi;

%% Validation - case 2

X_mod1 = [sigma_mod1, p_h_mod1 + h_h, dk_1_mod1, dk_2_mod1]';
Y_mod1 = [pk_1_mod1, pk_2_mod1]';

Y_net_mod1 = net(X_mod1);

a_mod1{1} = radbas(netprod(dist(net.IW{1,1},X_mod1),net.b{1}))
chi_mod1 = [a_mod1{1} ; (p_h_mod1+h_h)' ; ones(1,73)];

Y_net_mod1_c = theta_k*chi_mod1;

%% Validation - case 3

X_mod2 = [sigma_mod2, p_h_mod2 + h_h, dk_1_mod2, dk_2_mod2]';
Y_mod2 = [pk_1_mod2, pk_2_mod2]';

a_mod2{1} = radbas(netprod(dist(net.IW{1,1},X_mod2),net.b{1}))
chi_mod2 = [a_mod2{1} ; (p_h_mod2+h_h)' ; ones(1,73)];

Y_net_mod2_c = theta_k*chi_mod2

%% Identification - Wt pressure - case 1

Xs = [sigmak, p_hk + h_hk, dk_1k, dk_2k]';
Ys = [p_hkplus1 - p_hk]';

spread_s = 8.5;                 %25 %28
% number of neurons
K_s = 10;                       %10 %8
% performance goal 
goal_s = 0.00005;
% neuron step
Ki_s = 1;

net_s = newrb(Xs,Ys,goal_s,spread_s,K_s,Ki_s);
Ys_net = net_s(Xs);

a_s{1} = radbas(netprod(dist(net_s.IW{1,1},Xs),net_s.b{1}));

chi_s = [a_s{1} ; dk_1k' ; dk_2k' ; sigmak' ; ones(1,72)];
theta_s = Ys/chi_s;

Ys_net_c = theta_s*chi_s;

set(0,'DefaultFigureVisible','on')
figure(1)
stairs(tk,p_hkplus1,'LineWidth',1.2)
hold on
stairs(tk, Ys_net_c' + p_hk ,'LineWidth',1.2)
xlim([0 73])
title('Inlet pressure - $\bar{p}_{\mathcal{K},1}$','interpreter','latex')
xlabel('Time [h]','interpreter','latex');
ylabel('Pressure  [m]','interpreter','latex')

% Validation - case 2

Xs_mod1 = [sigmak_mod1, p_hk_mod1 + h_hk, dk_1k_mod1, dk_2k_mod1]';
Ys_mod1 = [p_hkplus1_mod1 - p_hk_mod1]';

a_s_mod1{1} = radbas(netprod(dist(net_s.IW{1,1},Xs_mod1),net_s.b{1}));
chi_s_mod1 = [a_s_mod1{1} ; dk_1k_mod1' ; dk_2k_mod1' ; sigmak_mod1' ; ones(1,72)];

Ys_net_mod1_c = theta_s*chi_s_mod1;
Ys_net_mod1_c_try = net_s(Xs_mod1);

set(0,'DefaultFigureVisible','on')
figure(2)
stairs(tk,p_hkplus1_mod1,'LineWidth',1.2)
hold on
stairs(tk,  Ys_net_mod1_c' + p_hk_mod1 ,'LineWidth',1.2)
% hold on
% stairs(tk, Ys_net_mod1_c_try' + p_hk_mod1 ,'LineWidth',1.2)
% hold on
% stairs(tk,  p_hkplus1_mod1 - p_hk_mod1 ,'LineWidth',1.2)
% stairs(t, p_h ,'LineWidth',1.2)
% hold on
% stairs(tk, p_hkplus1 ,'LineWidth',1.2)
xlim([0 73])
title('Inlet pressure - $\bar{p}_{\mathcal{K},1}$','interpreter','latex')
xlabel('Time [h]','interpreter','latex');
ylabel('Pressure  [m]','interpreter','latex')


% Validation - case 3

Xs_mod2 = [sigmak_mod2, p_hk_mod2 + h_hk, dk_1k_mod2, dk_2k_mod2]';
Ys_mod2 = [p_hkplus1_mod2 - p_hk_mod2]';

a_s_mod2{1} = radbas(netprod(dist(net_s.IW{1,1},Xs_mod2),net_s.b{1}));
chi_s_mod2 = [a_s_mod2{1} ; dk_1k_mod2' ; dk_2k_mod2' ; sigmak_mod2' ; ones(1,72)];

Ys_net_mod2_c = theta_s*chi_s_mod2;

set(0,'DefaultFigureVisible','on')
figure(3)
stairs(tk,p_hkplus1_mod2,'LineWidth',1.2)
hold on
stairs(tk,  Ys_net_mod2_c' + p_hk_mod2 ,'LineWidth',1.2)
xlim([0 73])
title('Inlet pressure - $\bar{p}_{\mathcal{K},1}$','interpreter','latex')
xlabel('Time [h]','interpreter','latex');
ylabel('Pressure  [m]','interpreter','latex')

%% Plots


% 
% figure(2)
% stairs(t,pk_1(:,1),'LineWidth',1.2)
% hold on
% stairs(t,pk_2(:,1),'LineWidth',1.2)
% xlim([0 73])
% title('Inlet pressure - $\bar{p}_{\mathcal{K},1}$','interpreter','latex')
% xlabel('Time [h]','interpreter','latex');
% ylabel('Pressure  [m]','interpreter','latex')
% 
set(0,'DefaultFigureVisible','on')
figure(4)
stairs(t,dk_1_mod2(:,1),'LineWidth',1.2)
hold on
stairs(t,dk_2_mod2(:,1),'LineWidth',1.2)
xlim([0 73])
title('Inlet flow - $\bar{d}_{\mathcal{K},1}$','interpreter','latex')
xlabel('Time [h]','interpreter','latex');
ylabel('Flow  [LPS]','interpreter','latex')

set(0,'DefaultFigureVisible','on')
figure(5)
stairs(t,pk_1,'LineWidth',1.2)
hold on
stairs(t,Y_net_c(1,:),'LineWidth',1.2)
xlim([0 73])
title('Inlet pressure - $\bar{p}_{\mathcal{K},1}$','interpreter','latex')
xlabel('Time [h]','interpreter','latex');
ylabel('Pressure  [m]','interpreter','latex')

set(0,'DefaultFigureVisible','on')
figure(6)
stairs(t,pk_2,'LineWidth',1.2)
hold on
stairs(t,Y_net_c(2,:),'LineWidth',1.2)
xlim([0 73])
title('Inlet pressure - $\bar{p}_{\mathcal{K},2}$','interpreter','latex')
xlabel('Time [h]','interpreter','latex');
ylabel('Pressure  [m]','interpreter','latex')

set(0,'DefaultFigureVisible','on')
figure(7)
stairs(t,pk_1_mod1,'LineWidth',1.2)
hold on
stairs(t,Y_net_mod1_c(1,:),'LineWidth',1.2)
xlim([0 73])
title('Validation 1 - $\bar{p}_{\mathcal{K},1}$','interpreter','latex')
xlabel('Time [h]','interpreter','latex');
ylabel('Pressure  [m]','interpreter','latex')

set(0,'DefaultFigureVisible','on')
figure(8)
stairs(t,pk_2_mod1,'LineWidth',1.2)
hold on
stairs(t,Y_net_mod1_c(2,:),'LineWidth',1.2)
xlim([0 73])
title('Validation 1 - $\bar{p}_{\mathcal{K},2}$','interpreter','latex')
xlabel('Time [h]','interpreter','latex');
ylabel('Pressure  [m]','interpreter','latex')

set(0,'DefaultFigureVisible','on')
figure(9)
stairs(t,pk_1_mod2,'LineWidth',1.2)
hold on
stairs(t,Y_net_mod2_c(1,:),'LineWidth',1.2)
xlim([0 73])
title('Validation 2 - $\bar{p}_{\mathcal{K},1}$','interpreter','latex')
xlabel('Time [h]','interpreter','latex');
ylabel('Pressure  [m]','interpreter','latex')

set(0,'DefaultFigureVisible','on')
figure(10)
stairs(t,pk_2_mod2,'LineWidth',1.2)
hold on
stairs(t,Y_net_mod2_c(2,:),'LineWidth',1.2)
xlim([0 73])
title('Validation 2 - $\bar{p}_{\mathcal{K},2}$','interpreter','latex')
xlabel('Time [h]','interpreter','latex');
ylabel('Pressure  [m]','interpreter','latex')

%% Sigma_plots

set(0,'DefaultFigureVisible','on')
figure(11)
stairs(t,sigma,'LineWidth',1.2)
hold on
stairs(t,sigma_mod1,'LineWidth',1.2)
hold on
stairs(t,sigma_mod2,'LineWidth',1.2)
xlim([0 25])
%title('Total consumption - $\bar{p}_{\mathcal{K},2}$','interpreter','latex')
legend('\sigma_1','\sigma_2','\sigma_3','Interpreter', 'latex');
xlabel('Time [h]','interpreter','latex');
ylabel('Flow  [LPS]','interpreter','latex')
