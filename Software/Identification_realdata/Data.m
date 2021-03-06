clear all
oldpath = path;
path(oldpath,...
'C:\users\CBalla\Documents\Aalborg_3\Verdo_project\Verdo_project\Software\Identification_realdata\Data_sets')

%% Load data
%dk1 OMV
load('dk1_p1.mat');
load('dk1_p2.mat');
load('dk1_p3.mat');
%dk2 TBP
load('dk2_p1.mat');
load('dk2_p2.mat');
load('dk2_p3.mat');
%sigma 
load('sigma_p1.mat');
load('sigma_p2.mat');
load('sigma_p3.mat');
%w1 HBP
load('w1_p1.mat');
load('w1_p2.mat');
load('w1_p3.mat');
%w2 HBP
load('w2_p1.mat');
load('w2_p2.mat');
load('w2_p3.mat');
%w3 HSP
load('w3_p1.mat');
load('w3_p2.mat');
load('w3_p3.mat');
%pk2 TBP
load('pk2_p1.mat');
load('pk2_p2.mat');
load('pk2_p3.mat');

%% Remove the last two days - 2880 elements 

dk1_p1(2881:5700) = [];
dk1_p2(2881:5700) = [];
dk1_p3(2881:5700) = [];

dk2_p1(2881:5700) = [];
dk2_p2(2881:5700) = [];
dk2_p3(2881:5700) = [];

sigma_p1(2881:5700) = [];
sigma_p2(2881:5700) = [];
sigma_p3(2881:5700) = [];

w1_p1(2881:5700) = [];
w1_p2(2881:5700) = [];
w1_p3(2881:5700) = [];

w2_p1(2881:5700) = [];
w2_p2(2881:5700) = [];
w2_p3(2881:5700) = [];

w3_p1(2881:5700) = [];
w3_p2(2881:5700) = [];
w3_p3(2881:5700) = [];

pk2_p1(2881:5700) = [];
pk2_p2(2881:5700) = [];
pk2_p3(2881:5700) = [];




