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

net = newrb(X_W,Y_W,goal,spread,K,Ki);
Y_net = net(X_W);
a{1} = radbas(netprod(dist(net.IW{1,1},X_W),net.b{1}));

chi_K = [a{1} ; (p_WT_k + h_WT)' ; ones(1,148)];
theta_K = Y_K/chi_K
Z_K = theta_K*chi_K;

%Output weights
net.LW{2,1};

%Output bias
net.b{2};
net.biases{i}.learn=0