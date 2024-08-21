clear;
clc;

%% Read Data
load('hurricane_dw.mat');
N = length(J1inflow);
time_step = 5;
time = 0:time_step:N*time_step-time_step;

%% Define parameters
%Link C1
Qmax{1} = 2000; %Maximum flow working around
Qmin{1} = 100; %Minimum flow
X{1} = 6000; %length
m{1} = 1.5; %trapezoid side slope
B{1} = 8; %trapezoid bottom lenth
Sb{1} = 0.0008; %Bed slope
n{1} = 0.02; %Manning Coefficients
YX{1} = 15; % Downstream water depth
Q0{1} = 750; % Average flow
Q{1} = [Qmax{1},Qmin{1},Q0{1}];

%Link C2
Qmax{2} = 1400;
Qmin{2} = 100;
X{2} = 6000;
m{2} = 1.5;
B{2} = 8;
Sb{2} = 0.00017;
n{2} = 0.02;
YX{2} = 10;
Q0{2} = 700;
Q{2} = [Qmax{2},Qmin{2},Q0{2}];


%% Compute Parameters
C1 = link('trapezoid',{X{1},n{1},Sb{1},Q{1},YX{1},[B{1},m{1}]});
C2 = link('trapezoid',{X{2},n{2},Sb{2},Q{2},YX{2},[B{2},m{2}]});


%% Construct transfer functions for upstream

C1_down = [C1.p21,C1.p22];
C2_up = [C2.p11,C2.p12];
C2_down = [C2.p21,C2.p22];

C1_down = c2d(C1_down,time_step);
C2_up = c2d(C2_up,time_step);
C2_down = c2d(C2_down,time_step);


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








