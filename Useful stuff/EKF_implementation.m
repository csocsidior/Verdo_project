%Extended Kalman Filter

clear all
clc

%% Parameters
T = 100;
a= 0.95; 
k= 1; 
b= k*(1-a); 
c= 1; 
phif= 0; 
phih= 0; 
fu= 0.02;
sigmaw= 0.05*sqrt(1-a^2); 
sigmav= 0.1; 
sigmax0= sigmaw; 
x0= 0;

u= square((1:T)*fu*2*pi)';

%WGN 
w= sigmaw*randn(T,1);
v= sigmav*randn(T,1);

%Initial values 
P0= sigmax0^2; 
R= sigmav^2; 
Q= sigmaw^2;

x(1) = sigmax0*randn+x0;
z(1) = sin(c*x(1) + phih) + v(1);
 
z0= sin(c*x0+phih);

%% EKF  

x = zeros(T,1);
z_pred = zeros(T,1);
x_pred = zeros(T,1);
x_array = zeros(T,1);
P_array_p = zeros(T,1);
P_array_m = zeros(T,1);


for i= 2:T;
  x(i)= a*sin(x(i-1)+phif)+b*u(i-1)+w(i-1);
  z(i)= sin(c*x(i)+phih)+v(i);
end;

xhm = x0;
zhm = sin(c*xhm+phih);
Pm = P0;

%Slide 8 - K,H, x_pred, p_pred ... etc 
for i= 1:T;
XHM(i) = xhm;
ZHM(i) = zhm;
H= c*cos(xhm);
K= Pm*H'/(H*Pm*H'+R);
x_pred = xhm + K*(z_pred(i)-zhm);
x_array(i) = x_pred;                            %Save state predictions
P_pred = (1-K*H)*Pm*(1-K*H)'+K*R*K';
%P_array_p(i) = P_pred;                        %Save covariance predicted values
P_array_m(i) = Pm;                            %Save covariance measurement values
K_array(i) = K;

xhm= a*sin(x_pred+phif)+b*u(i);
Phi= a*cos(x_pred+phif);
Pm= Phi*P_pred*Phi'+Q;
zhm= sin(c*xhm+phih);

end;

figure(1)
subplot(221)
plot([x XHM x_array])
subplot(222)
plot(z- z_array)

