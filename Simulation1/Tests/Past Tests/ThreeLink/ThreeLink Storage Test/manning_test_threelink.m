clear;
clc;

%% Read Data
load('hurricane_dw.mat');
N = length(J1inflow);
time_step = 5;
time = 0:time_step:N*time_step-time_step;

%% Define parameters
%Link C1
Qmax{1} = 2500; %Maximum flow working around
Qmin{1} = 10; %Minimum flow
X{1} = 6000; %length
m{1} = 1.5; %trapezoid side slope
B{1} = 8; %trapezoid bottom lenth
Sb{1} = 0.0008; %Bed slope
n{1} = 0.02; %Manning Coefficients
YX{1} = 10; % Downstream water depth
Q0{1} = 750; % Average flow
Q{1} = [Qmax{1},Qmin{1},Q0{1}];

%Link C2
Qmax{2} = 2000;
Qmin{2} = 10;
X{2} = 2000;
m{2} = 1.5;
B{2} = 2;
Sb{2} = 0.0025;
n{2} = 0.04;
YX{2} = 15;
Q0{2} = 1000;
Q{2} = [Qmax{2},Qmin{2},Q0{2}];

%Link C3
Qmax{3} = 1600;
Qmin{3} = 10;
X{3} = 2000;
m{3} = 1.5;
B{3} = 7;
Sb{3} = 0.0015;
n{3} = 0.03;
YX{3} = 20;
Q0{3} = 800;
Q{3} = [Qmax{3},Qmin{3},Q0{3}];


%% Compute Parameters
C1 = link('trapezoid',{X{1},n{1},Sb{1},Q{1},YX{1},[B{1},m{1}]});
C2 = link('trapezoid',{X{2},n{2},Sb{2},Q{2},YX{2},[B{2},m{2}]});
C3 = link('trapezoid',{X{3},n{3},Sb{3},Q{3},YX{3},[B{3},m{3}]});

C123 = link_cascade({C1,C2,C3});

yd = [C123.p21,C123.p22];
yd_ds = c2d(yd,time_step);

%% Construct transfer functions for upstream


%% Simulation
qu = J1inflow;
% 
% level = lsim(sys,qu',time);
% 
% level1 = level(:,1);
% level2 = level(:,2);
% level3 = level(:,3);
% 
% figure;
% plot(time,J2level);
% hold;
% plot(time,level1);
% title('J2Level');
% legend('Actual','Model');
% 
% figure;
% plot(time,J3level);
% hold;
% plot(time,level2);
% title('J3Level');
% legend('Actual','Model');
% 
% figure;
% plot(time,J4level);
% hold;
% plot(time,level3);
% title('J4Level');
% legend('Actual','Model');








