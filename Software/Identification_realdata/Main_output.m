clear all;
Data;
t=0:1:2879; % Time vector

%% Filtering pk2_p1
BB = smooth(pk2_p1,'rlowess');
BB1 = smooth(BB,'rlowess');
BB2 = smooth(BB1);
BB3 = smooth(BB2,'rlowess');
pk2_p1 = smooth(BB3);

%%
BB4 = smooth(BB3,'sgolay');
BB5 = smooth(BB4,'sgolay');
BB6 = smooth(BB5,'sgolay');
pk2_p1 = smooth(BB6,'loess');

plot(pk2_p1)

%% Filtering dk2_p1
AA = smooth(dk2_p1);
dk2_p1 = smooth(AA);

%% Training set for the output identification - Period 1
X_K = [sigma_p1, smooth(w1_p1), smooth(w2_p1), smooth(w3_p1), dk1_p1, dk2_p1]';   %(maybe add elevations)
Y_K = [pk2_p1]';

%% Training set for the output validation - Period 2
X_K_v1 = [sigma_p2, smooth(w1_p2), smooth(w2_p2), smooth(w3_p2), dk1_p2, smooth(dk2_p2)]';   %(maybe add elevations)
Y_K_v1 = [pk2_p2]';

%% Training set for the output validation - Period 3
X_K_v2 = [sigma_p3, w1_p3, w2_p3, w3_p3, dk1_p3, dk2_p3]';   %(maybe add elevations)
Y_K_v2 = [pk2_p3]';

%% Output identification
spread = 125;                %30  60
% number of neurons
K = 10;                       %20  10
% performance goal 
goal = 0.001;
% neuron step
Ki = 1;

net = newrb(X_K,Y_K,goal,spread,K,Ki);
Y_net = net(X_K);
a{1} = radbas(netprod(dist(net.IW{1,1},X_K),net.b{1}));

 chi_K = [a{1} ; smooth(w1_p1)' ; smooth(w2_p1)'; smooth(w3_p1)'; ones(1,2880)];
 theta_K = Y_K/chi_K
 Z_K = theta_K*chi_K;
 
  figure(1)
 plot(t,pk2_p1,'LineWidth',1)
  hold on
 plot(t,Z_K,'LineWidth',1)
 xlim([0 2880])
  ylim([50.6 54.7])
 xlabel('Time [min]','interpreter','latex');
 ylabel('Head  [m]','interpreter','latex')
 h1 = legend('Measurement','Model','Location','SouthEast');
 set(h1, 'Interpreter', 'latex');
 title('$\bar{p}_{\mathcal{K},2}$ - inlet pressure','interpreter','latex')
 
 cost_func = 'NMSE'; %normalized mean squared error
 fit_pk2_p1 = 100*goodnessOfFit(Z_K',pk2_p1,cost_func)
 
 %% Output validation 1 - Period 2
 
a_v1{1} = radbas(netprod(dist(net.IW{1,1},X_K_v1),net.b{1}));
chi_K_v1 = [a_v1{1} ; smooth(w2_p2)' ; smooth(w1_p2)'; smooth(w3_p2)'; ones(1,2880)];
Z_K_v1 = theta_K*chi_K_v1;

 figure(1)
 plot(t,pk2_p2,'LineWidth',1)
 hold on
 plot(t,Z_K_v1,'LineWidth',1)
 xlim([0 2880])
 ylim([50 54.7])
 xlabel('Time [min]','interpreter','latex');
 ylabel('Head  [m]','interpreter','latex')
 h1 = legend('Measurement','Model','Location','SouthEast');
 set(h1, 'Interpreter', 'latex');
 title('$\bar{p}_{\mathcal{K},2}$ - inlet pressure','interpreter','latex')
 
% AA = smooth(pk2_p2,'rlowess');
% AA1 = smooth(AA,'rlowess');
% AA2 = smooth(AA1);
% AA3 = smooth(AA2,'rlowess');
% pk2_p2 = smooth(AA3);
 
 fit_pk2_p2 = 100*goodnessOfFit(Z_K_v1',pk2_p2,cost_func)
 
  %% Output validation 2 - Period 3
 
a_v2{1} = radbas(netprod(dist(net.IW{1,1},X_K_v2),net.b{1}));
chi_K_v2 = [a_v2{1} ; w2_p3' ; w1_p3'; w3_p3'; ones(1,2880)];
Z_K_v2 = theta_K*chi_K_v2;

  figure(1)
 plot(t,pk2_p3,'LineWidth',1)
 hold on
 plot(t,Z_K_v2,'LineWidth',1)
 xlim([0 2880])
  ylim([50 54.7])
 xlabel('Time [min]','interpreter','latex');
 ylabel('Head  [m]','interpreter','latex')
 h1 = legend('Measurement','Model','Location','SouthEast');
 set(h1, 'Interpreter', 'latex');
 title('$\bar{p}_{\mathcal{K},2}$ - inlet pressure','interpreter','latex')
 
 fit_pk2_p3 = 100*goodnessOfFit(Z_K_v2',pk2_p3,cost_func)
 
 %%
 figure(2)
 plot(t,a{1}(1,:),'LineWidth',1.2)
 hold on
  plot(t,a{1}(2,:),'LineWidth',1.2)
  hold on
   plot(t,a{1}(3,:),'LineWidth',1.2)
   hold on
    plot(t,a{1}(4,:),'LineWidth',1.2)
    hold on
     plot(t,a{1}(5,:),'LineWidth',1.2)
     hold on
      plot(t,a{1}(6,:),'LineWidth',1.2)
      hold on
      plot(t,a{1}(7,:),'LineWidth',1.2)
      hold on
      plot(t,a{1}(8,:),'LineWidth',1.2)
      hold on
      plot(t,a{1}(9,:),'LineWidth',1.2)
      hold on
      plot(t,a{1}(10,:),'LineWidth',1.2)
      
 %% Residuals
 
   figure(1)
 plot(t,pk2_p1-Z_K','LineWidth',1)
 xlim([0 2880])
  ylim([-1.5 1.5])
  grid on;
 xlabel('Time [min]','interpreter','latex');
 ylabel('Head  [m]','interpreter','latex')
 h1 = legend('Residual 1','Location','NorthEast');
 set(h1, 'Interpreter', 'latex');
 title('$\bar{p}_{\mathcal{K},2}$ - Identification residual','interpreter','latex')
 
 %%
 figure(2)
 plot(t,pk2_p2-Z_K_v1','LineWidth',1)
 xlim([0 2880])
 ylim([-2 3])
 grid on;
 xlabel('Time [min]','interpreter','latex');
 ylabel('Head  [m]','interpreter','latex')
 h1 = legend('Residual 2','Location','NorthEast');
 set(h1, 'Interpreter', 'latex');
 title('$\bar{p}_{\mathcal{K},2}$ - First validation residual','interpreter','latex')
 
 %%
 figure(3)
 plot(t,pk2_p3-Z_K_v2','LineWidth',1)
 xlim([0 2880])
 ylim([-2 3])
 grid on;
 xlabel('Time [min]','interpreter','latex');
 ylabel('Head  [m]','interpreter','latex')
 h1 = legend('Residual 3','Location','NorthEast');
 set(h1, 'Interpreter', 'latex');
 title('$\bar{p}_{\mathcal{K},2}$ - Second validation residual','interpreter','latex')
 
 
 %%
  figure(3)
 plot(t,w1_p3,'LineWidth',1)
 hold on
 plot(t,w2_p3,'LineWidth',1)
 xlim([0 2880])
 xlabel('Time [min]','interpreter','latex');
 ylabel('Head  [m]','interpreter','latex')
 h1 = legend('$\hat{p}_{\mathcal{W}1}$','$\hat{p}_{\mathcal{W}2}$','Location','NorthEast');
 set(h1, 'Interpreter', 'latex');
 title('Level in the WTs at HBP','interpreter','latex')
      

 