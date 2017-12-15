clear all

%Load data
Data;
t=0:1:147; % Time vector

%% Output identification

spread = 121;                 %122 
% number of neurons
K = 10;                       %6
% performance goal 
goal = 0.0001;
% neuron step
Ki = 1;

net = newrb(X_K,Y_K,goal,spread,K,Ki);
Y_net = net(X_K);
a{1} = radbas(netprod(dist(net.IW{1,1},X_K),net.b{1}));

chi_K = [a{1} ; (p_WT_k + h_WT)' ; ones(1,148)];
theta_K = Y_K/chi_K
Z_K = theta_K*chi_K;
 
 %% Output validation 1 
 
a_v1{1} = radbas(netprod(dist(net.IW{1,1},X_K_v1),net.b{1}));
chi_K_v1 = [a_v1{1} ; (p_WT_k + h_WT)' ; ones(1,148)];
Z_K_v1 = theta_K*chi_K_v1;

 figure(1)
 subplot(2,1,1) 
 stairs(t,Z_K(1,:),'LineWidth',1.2)
 hold on
 stairs(t,pk_1,'LineWidth',1.2)
 xlim([0 148])
subplot(2,1,2) 
 stairs(t,Z_K_v1(1,:),'LineWidth',1.2)
 hold on
 stairs(t,pk_1_v1,'LineWidth',1.2)
 xlim([0 148])



