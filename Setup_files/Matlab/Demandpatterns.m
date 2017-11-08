clear all 

d_parcel = [0.41, 0.28, 0.25, 0.26, 0.20, 0.72, 2.08, 1.90, 1.19, 1.06, 0.98, 0.8, 0.85, 0.83, 0.80, 1.20, 1.50, 1.50, 1.75, 1.60, 1.20, 1.1, 0.65, 0.41, 0.28 ];
d_industry = [0.42, 0.31, 0.26, 0.26, 0.38, 0.57, 0.86, 1.38, 1.55, 1.53, 1.47, 1.52, 1.4, 1.4, 1.24, 1.3, 1.25, 1.3, 1.28, 0.95, 0.94, 0.94, 0.85, 0.7, 0.42];
t=0:1:24; % Time vector

figure(1)
stairs(t,d_parcel(1,:),'LineWidth',1.2)
hold on;
stairs(t,d_industry(1,:),'LineWidth',1.2)
h1 = legend('Non-industrial','Industrial');
set(h1, 'Interpreter', 'latex');
h1.FontSize = 9;
grid
xlabel('Time [h]');
ylabel('Scale [\cdot]')
title('Industrial/non-industrial water consumption pattern')
xlim([0 25])
ylim([0 2.5])

% figure(2)
% stairs(t,d_industry(1,:),'LineWidth',1.2)
% h2 = legend('Industrial');
% set(h2, 'Interpreter', 'latex');
% h2.FontSize = 9;
% grid
% xlabel('Time [h]');
% ylabel('Scale [\cdot]')
% title('Industrial water consumption pattern')
% xlim([0 25])
% ylim([0 2.5])