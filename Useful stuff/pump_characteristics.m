

% x = 0 : 0.1 : 3;
% y = 5.8 - 0.55*(x.^2);
% plot(x,y)
% axis([0 4 0 6.5])
% xlabel('flow [m^3/h]')
% ylabel('pressure [bar]')
% grid on
% set(gca,'GridLineStyle',':')

H = [1,1,0,0;
     1,0,1,0;
     0,0,1,0;
     0,1,0,1;
     0,0,0,1];