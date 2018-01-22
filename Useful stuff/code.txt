%% Sliding mode control for Non-linear Control System course
% By Ignacio Trojaola Bolinaga, Jesper H. Jørgensen,
% Jonas Ørndrup Nielsen and Krisztian Balla
clear
close all
clc

format long
t=0:0.1:50; % Time vector

% Random variables to simulate uncertainties
global m l k g a b c
g = 9.81;           % gravity
m = rand+0.5;       % mass
l = rand*0.2+0.9;   % length
k = rand*0.2;       % friction coefficient
a = g/l;
b = k/m;
c = 1/(m*l^2);

init_theta = [0.5 0.5]; % Initial values for the states

[t,theta]=ode45(@slidingmodecontrol,t,init_theta); % Simulation of the Sliding mode controller

%--- Plots are made below here ---%
figure(1)
margin = 0.01*ones(1,length(t));

subplot(2,3,1)
plot(t,theta(:,1),'b',t,margin,'r',t,margin*(-1),'r');
h1 = legend('$\theta$','0.01 bound');
set(h1, 'Interpreter', 'latex');
h1.FontSize = 12;
grid
axis([0 50 -0.1 1])
xlabel('Time [s]');
ylabel('Angle [rad]')
title('Angle of pendulum')

subplot(2,3,2)
plot(t,theta(:,2),'b',t,margin,'r',t,margin*(-1),'r');
h2 = legend('$\dot{\theta}$','0.01 bound','location','SouthEast');
set(h2, 'Interpreter', 'latex');
h2.FontSize = 12;
grid
axis([0 50 -1 1])
xlabel('Time [s]');
ylabel('Angular velocity [rad/s]')
title('Angular velocity')

subplot(2,3,3)
plot(theta(:,1),theta(:,2));
grid
xlabel('Angle [rad]');
ylabel('Angular velocity [rad/s]')
title('Angle vs angular velocity')

subplot(2,3,4)
plot(t,theta(:,1),'b',t,margin,'r',t,margin*(-1),'r');
h1 = legend('$\theta$','0.01 bound');
set(h1, 'Interpreter', 'latex');
h1.FontSize = 12;
grid
axis([2 20 -0.1 0.1])
xlabel('Time [s]');
ylabel('Angle [rad]')
title('Zoom of angle')

subplot(2,3,5)
plot(t,theta(:,2),'b',t,margin,'r',t,margin*(-1),'r');
h2 = legend('$\dot{\theta}$','0.01 bound','location','SouthEast');
set(h2, 'Interpreter', 'latex');
h2.FontSize = 12;
grid
axis([2 20 -0.1 0.1])
xlabel('Time [s]');
ylabel('Angular velocity [rad/s]')
title('Zoom of angular velocity')

% Recalculation of input for plotting:
epsilon = 0.004; % Eqsilon decides the steepness of the saturation function
for i=1:length(t)
    s = theta(i,1)+theta(i,2); % Sliding manifold for sliding mode control
    z=s/epsilon;
    if z>1 % Saturation function to decrease chattering
        sat = 1;
    elseif z<-1
        sat = -1;
    else
        sat = z;
    end
    u(i) = -(16.1865*abs(theta(i,1))+1.815*abs(theta(i,2))+2)*sat;
end
subplot(2,3,6)
plot(t,u);
grid
xlabel('Time [s]');
ylabel('Torque input')
title('Torque input')

function dtheta=slidingmodecontrol(t,theta)
global l a b c
epsilon = 0.004; % Make sure this value is the same as the other local epsilon on line 81
s = theta(1)+theta(2); % Sliding manifold for sliding mode control
z=s/epsilon;
if z>1 % Saturation function to decrease chattering
    sat = 1;
elseif z<-1
    sat = -1;
else
    sat = z;
end

u = -(16.1865*abs(theta(1))+1.815*abs(theta(2))+2)*sat; % Control law
h = (rand-0.5)*2; % sin(t) for faster computation
% Dynamic equations below
dtheta(1,1) = theta(2);
dtheta(2,1) = -a*sin(theta(1))-b*theta(2)+1/l*h*cos(theta(1))+c*u;
end