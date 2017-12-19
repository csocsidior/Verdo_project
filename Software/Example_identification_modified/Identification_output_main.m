clear all

%Load data
Data;
t=0:1:147; % Time vector

%% Output identification

spread = 66;                 %66 
% number of neurons
K = 6;                       %6
% performance goal 
goal = 0.001;
% neuron step
Ki = 1;

net = newrb(X_K,Y_K,goal,spread,K,Ki);
Y_net = net(X_K);
a{1} = radbas(netprod(dist(net.IW{1,1},X_K),net.b{1}));

chi_K = [a{1} ; (p_WT_k + h_WT)' ; ones(1,148)];
theta_K = Y_K/chi_K
Z_K = theta_K*chi_K;

%Output weights
net.LW{2,1};
 
 %% Output validation 1 
 
a_v1{1} = radbas(netprod(dist(net.IW{1,1},X_K_v1),net.b{1}));
chi_K_v1 = [a_v1{1} ; (p_WT_k_v1 + h_WT)' ; ones(1,148)];
Z_K_v1 = theta_K*chi_K_v1;

 %% Output validation 2 
 
a_v2{1} = radbas(netprod(dist(net.IW{1,1},X_K_v2),net.b{1}));
chi_K_v2 = [a_v2{1} ; (p_WT_k_v2 + h_WT)' ; ones(1,148)];
Z_K_v2 = theta_K*chi_K_v2;

 figure(1)
 subplot(3,1,1) 
 stairs(t,Z_K(2,:),'LineWidth',1.2)
 hold on
 stairs(t,pk_2,'LineWidth',1.2)
 xlim([0 96])
subplot(3,1,2) 
 stairs(t,Z_K_v1(2,:),'LineWidth',1.2)
 hold on
 stairs(t,pk_2_v1,'LineWidth',1.2)
 xlim([0 96])
 subplot(3,1,3) 
  stairs(t,Z_K_v2(2,:),'LineWidth',1.2)
 hold on
 stairs(t,pk_2_v2,'LineWidth',1.2)
 xlim([0 96])

% figure(8)
% plot(t,a{1}(1,:),'LineWidth',1.2)
% hold on
% plot(t,a{1}(2,:),'LineWidth',1.2)
% hold on
% plot(t,a{1}(3,:),'LineWidth',1.2)
% hold on
% plot(t,a{1}(4,:),'LineWidth',1.2)
% hold on
% plot(t,a{1}(5,:),'LineWidth',1.2)
% hold on
% plot(t,a{1}(6,:),'LineWidth',1.2)
% hold on
% plot(t,a{1}(7,:),'LineWidth',1.2)
% hold on
% plot(t,a{1}(8,:),'LineWidth',1.2)

