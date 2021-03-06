clear all
oldpath = path;
path(oldpath,...
'C:\users\CBalla\Documents\Aalborg_3\Verdo_project\Verdo_project\Software\Example_identification_modified\data_files')
t=0:1:147; % Time vector

%% 
%//////////Identification data, sigma = 35//////////
load('dk_1.mat');
load('dk_2.mat');
load('pk_1.mat');
load('pk_2.mat');
load('p_WT.mat');
load('sigma.mat');
h_WT = 21;

dk_1(149) = [];
dk_2(149) = [];
pk_1(149) = [];
pk_2(149) = [];
sigma(149) = [];
p_WT_k = p_WT;
p_WT_k(149) = [];
p_WT_kp1 = p_WT;
p_WT_kp1(1) = [];

%Training set for the output identification
X_K = [sigma, p_WT_k + h_WT, dk_1, dk_2]';
Y_K = [pk_1, pk_2]';

%Training set for the state identification
X_W = [sigma, p_WT_k + h_WT, dk_1, dk_2]';
Y_W = [p_WT_kp1 - p_WT_k]';

%% 
%//////////Validation data 1, sigma = 25//////////
load('dk_1_v1.mat');
load('dk_2_v1.mat');
load('pk_1_v1.mat');
load('pk_2_v1.mat');
load('p_WT_v1.mat');
load('sigma_v1.mat');

dk_1_v1(149) = [];
dk_2_v1(149) = [];
pk_1_v1(149) = [];
pk_2_v1(149) = [];
sigma_v1(149) = [];
p_WT_k_v1 = p_WT_v1;
p_WT_k_v1(149) = [];
p_WT_kp1_v1 = p_WT_v1;
p_WT_kp1_v1(1) = [];

%Training set for the output validation 1
X_K_v1 = [sigma_v1, p_WT_k_v1 + h_WT, dk_1_v1, dk_2_v1]';
Y_K_v1 = [pk_1_v1, pk_2_v1]';

%Training set for the state validation 1
X_W_v1 = [sigma_v1, p_WT_k_v1 + h_WT, dk_1_v1, dk_2_v1]';
Y_W_v1 = [p_WT_kp1_v1 - p_WT_k_v1]';

%%
%//////////Validation data 2, CONTROL: turn-off - 19.4,PU3 open if above 48, PU2 open if TA2 below 19.2, sigma = 35 //////////

load('dk_1_v2.mat');
load('dk_2_v2.mat');
load('pk_1_v2.mat');
load('pk_2_v2.mat');
load('p_WT_v2.mat');
load('sigma_v2.mat');

dk_1_v2(149) = [];
dk_2_v2(149) = [];
pk_1_v2(149) = [];
pk_2_v2(149) = [];
sigma_v2(149) = [];
p_WT_k_v2 = p_WT_v2;
p_WT_k_v2(149) = [];
p_WT_kp1_v2 = p_WT_v2;
p_WT_kp1_v2(1) = [];

%Training set for the output validation 1
X_K_v2 = [sigma_v2, p_WT_k_v2 + h_WT, dk_1_v2, dk_2_v2]';
Y_K_v2 = [pk_1_v2, pk_2_v2]';

%Training set for the state validation 1
X_W_v2 = [sigma_v2, p_WT_k_v2 + h_WT, dk_1_v2, dk_2_v2]';
Y_W_v2 = [p_WT_kp1_v2 - p_WT_k_v2]';

% %% Plot 1
%  figure(1)
%  stairs(t,dk_1_v2,'LineWidth',1.2)
%  hold on
%  stairs(t,dk_2_v2,'LineWidth',1.2)
%  xlim([0 120])
%  xlabel('Time [h]','interpreter','latex');
% %ylabel('Pressure  [m]','interpreter','latex')
% ylabel('Flow  [LPS]','interpreter','latex')
% h1 = legend('$\bar{d}_{\mathcal{K}1}$','$\bar{d}_{\mathcal{K}2}$','Location','SouthWest');
% set(h1, 'Interpreter', 'latex');
% %% Plot 2
% figure(2)
%  stairs(t,p_WT_k_v2,'LineWidth',1.2)
% xlim([0 120])
%  xlabel('Time [h]','interpreter','latex');
%  ylabel('Head  [m]','interpreter','latex');