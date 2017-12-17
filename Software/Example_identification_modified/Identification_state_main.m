clear all

%Load data
Data;
t=0:1:147; % Time vector

%% State identification

spread = 17;                 %17
% number of neurons
K = 5;                       %5
% performance goal 
goal = 0.0001;
% neuron step
Ki = 1;

net = newrb(X_W,Y_W,goal,spread,K,Ki);
Y_net = net(X_W);
a{1} = radbas(netprod(dist(net.IW{1,1},X_W),net.b{1}));

chi_W = [a{1} ; dk_1' ; dk_2' ; sigma' ; zeros(1,148)];
theta_W = Y_W/chi_W
Z_W = theta_W*chi_W;


%% State validation 1
 
a_v1{1} = radbas(netprod(dist(net.IW{1,1},X_W_v1),net.b{1}));
chi_W_v1 = [a_v1{1} ; dk_1_v1' ; dk_2_v1' ; sigma_v1' ; zeros(1,148)];
Z_W_v1 = theta_W*chi_W_v1;

%% State validation 2
 
a_v2{1} = radbas(netprod(dist(net.IW{1,1},X_W_v2),net.b{1}));
chi_W_v2 = [a_v2{1} ; dk_1_v2' ; dk_2_v2' ; sigma_v2' ; zeros(1,148)];
Z_W_v2 = theta_W*chi_W_v2;

%%
 figure(1)
 subplot(3,1,1) 
 stairs(t,p_WT_kp1 - p_WT_k ,'LineWidth',1.2)
 hold on
 stairs(t,Z_W','LineWidth',1.2)
 xlim([0 96])
  grid on
 subplot(3,1,2) 
 stairs(t,p_WT_kp1_v1 - p_WT_k_v1 ,'LineWidth',1.2)
 hold on
 stairs(t,Z_W_v1','LineWidth',1.2)
 xlim([0 96])
  grid on
 subplot(3,1,3) 
 stairs(t,p_WT_kp1_v2 - p_WT_k_v2 ,'LineWidth',1.2)
 hold on
 stairs(t,Z_W_v2','LineWidth',1.2)
 xlim([0 96])
 grid on
 
 figure(8)
stairs(t,a{1}(1,:),'LineWidth',1.2)
hold on
stairs(t,a{1}(2,:),'LineWidth',1.2)
hold on
stairs(t,a{1}(3,:),'LineWidth',1.2)
hold on
stairs(t,a{1}(4,:),'LineWidth',1.2)
hold on
stairs(t,a{1}(5,:),'LineWidth',1.2)

