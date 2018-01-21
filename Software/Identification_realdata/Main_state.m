clear all;
Data;
t=0:1:2878; % Time vector

%% Create k-1 data

dk1_p1(2880) = [];
dk1_p2(2880) = [];
dk1_p3(2880) = [];

dk2_p1(2880) = [];
dk2_p2(2880) = [];
dk2_p3(2880) = [];

sigma_p1(2880) = [];
sigma_p2(2880) = [];
sigma_p3(2880) = [];

% W1
w1_k_p1 = w1_p1;
w1_k_p1(2880) = [];
w1_kp1_p1 = w1_p1;
w1_kp1_p1(1) = [];
%
w1_k_p2 = w1_p2;
w1_k_p2(2880) = [];
w1_kp1_p2 = w1_p2;
w1_kp1_p2(1) = [];
%
w1_k_p3 = w1_p3;
w1_k_p3(2880) = [];
w1_kp1_p3 = w1_p3;
w1_kp1_p3(1) = [];

%W2
w2_k_p1 = w2_p1;
w2_k_p1(2880) = [];
w2_kp1_p1 = w2_p1;
w2_kp1_p1(1) = [];
%
w2_k_p2 = w2_p2;
w2_k_p2(2880) = [];
w2_kp1_p2 = w2_p2;
w2_kp1_p2(1) = [];
%
w2_k_p3 = w2_p3;
w2_k_p3(2880) = [];
w2_kp1_p3 = w2_p3;
w2_kp1_p3(1) = [];

%W3
w3_k_p1 = w3_p1;
w3_k_p1(2880) = [];
w3_kp1_p1 = w3_p1;
w3_kp1_p1(1) = [];

w3_k_p2 = w3_p2;
w3_k_p2(2880) = [];
w3_kp1_p2 = w3_p2;
w3_kp1_p2(1) = [];

w3_k_p3 = w3_p3;
w3_k_p3(2880) = [];
w3_kp1_p3 = w3_p3;
w3_kp1_p3(1) = [];

h_W = 50.8;
%%
%Training set for the state identification
X_W = [sigma_p1, w1_k_p1 + h_W, w2_k_p1 + h_W, w3_k_p1 + h_W, dk1_p1, dk2_p2]';
Y_W = [w1_kp1_p1, w2_kp1_p1, w3_kp1_p1]';

%Training set for the state validation 1
X_W_v1 = [sigma_p2, w1_k_p2 + h_W, w2_k_p2 + h_W, w3_k_p2 + h_W, dk1_p2, dk2_p2]';
Y_W_v1 = [w1_kp1_p2, w2_kp1_p2, w3_kp1_p2]';

%Training set for the state validation 1
X_W_v2 = [sigma_p3, w1_k_p3 + h_W, w2_k_p3 + h_W, w3_k_p3 + h_W, dk1_p3, dk2_p3]';
Y_W_v2 = [w1_kp1_p3, w2_kp1_p3 , w3_kp1_p3]';


%% State identification

spread = 225;                 %120
% number of neurons
K = 12;                       %20
% performance goal 
goal = 0.000001;
% neuron step
Ki = 1;

net = newrb(X_W,Y_W,goal,spread,K,Ki);
Y_net = net(X_W);
a{1} = radbas(netprod(dist(net.IW{1,1},X_W),net.b{1}));

chi_W = [a{1} ; dk1_p1' ; dk2_p1' ; sigma_p1' ; zeros(1,2879)];
theta_W = Y_W/chi_W;
Z_W = theta_W*chi_W;

cost_func = 'NMSE';
 fit_w1_p1 = 100*goodnessOfFit(Z_W(1,:)',w1_kp1_p1,cost_func)
 fit_w2_p1 = 100*goodnessOfFit(Z_W(2,:)',w2_kp1_p1,cost_func)
 fit_w3_p1 = 100*goodnessOfFit(Z_W(3,:)',w3_kp1_p1,cost_func)
 

figure(1)
subplot(3,1,1) 
 plot(w1_kp1_p1)
  hold on 
plot(Z_W(1,:))
subplot(3,1,2) 
 plot(w2_kp1_p1)
  hold on 
plot(Z_W(2,:))
subplot(3,1,3) 
 plot(w3_kp1_p1)
  hold on 
plot(Z_W(3,:))

%% State validation - Period 2

a_v1{1} = radbas(netprod(dist(net.IW{1,1},X_W_v1),net.b{1}));
chi_W_v1 = [a_v1{1} ; dk1_p2' ; dk2_p2' ; sigma_p2'  ; zeros(1,2879)];
Z_W_v1 = theta_W*chi_W_v1;

figure(1)
subplot(3,1,1) 
 plot(w1_kp1_p2)
  hold on 
plot(Z_W_v1(1,:))
subplot(3,1,2) 
 plot(w2_kp1_p2)
  hold on 
plot(Z_W_v1(2,:))
subplot(3,1,3) 
 plot(w3_kp1_p2)
  hold on 
plot(Z_W_v1(3,:))

%% State validation - Period 3

a_v2{1} = radbas(netprod(dist(net.IW{1,1},X_W_v2),net.b{1}));
chi_W_v2 = [a_v2{1} ; dk1_p3' ; dk2_p3' ; sigma_p3'  ; zeros(1,2879)];
Z_W_v2 = theta_W*chi_W_v2;

figure(1)
subplot(3,1,1) 
 plot(w1_kp1_p3)
  hold on 
plot(Z_W_v2(1,:))
subplot(3,1,2) 
 plot(w2_kp1_p3)
  hold on 
plot(Z_W_v2(2,:))
subplot(3,1,3) 
 plot(w3_kp1_p3)
  hold on 
plot(Z_W_v2(3,:))


%% W1 - W2
figure(1)
subplot(1,2,1)
 plot(w1_kp1_p3)
  hold on 
plot(Z_W_v2(1,:))
xlim([0 2880])
 ylim([2.2 2.66])
 xlabel('Time [min]','interpreter','latex');
 ylabel('Head  [m]','interpreter','latex')
 h1 = legend('Measurement','Model','Location','NorthEast');
 set(h1, 'Interpreter', 'latex');
  title('$\hat{p}_{\mathcal{W}1}$ - water level','interpreter','latex')
subplot(1,2,2)
 plot(w2_kp1_p3)
  hold on 
plot(Z_W_v2(2,:))
xlim([0 2880])
 ylim([2.24 2.7])
 xlabel('Time [min]','interpreter','latex');
 ylabel('Head  [m]','interpreter','latex')
 h1 = legend('Measurement','Model','Location','NorthEast');
 set(h1, 'Interpreter', 'latex');
 title('$\hat{p}_{\mathcal{W}2}$ - water level','interpreter','latex')
 
 %% W3
figure(1)
 plot(w3_kp1_p3)
  hold on 
plot(Z_W_v2(3,:))
 xlim([0 2880])
 ylim([2.46 2.6])
 xlabel('Time [min]','interpreter','latex');
 ylabel('Head  [m]','interpreter','latex')
 h1 = legend('Meas.','Model','Location','NorthEast');
 set(h1, 'Interpreter', 'latex');
 title('$\hat{p}^{k+1}_{\mathcal{W}3}$ - water level','interpreter','latex')



