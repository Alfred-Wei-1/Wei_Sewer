clear;
clc;

%% Read Data
load('hurricane_dw.mat');
N = length(J1inflow);
time_step = 5;
time = 0:time_step:N*time_step-time_step;

%% Define parameters
%Link C1
Qmax{1} = 2000;
Qmin{1} = 100;
X{1} = 6000;
m{1} = 1.5;
B{1} = 8;
Sb{1} = 0.0008;
n{1} = 0.02;
YX{1} = 17;
Q0{1} = 750;
Q{1} = [Qmax{1},Qmin{1},Q0{1}];

%Link C2
Qmax{2} = 1400;
Qmin{2} = 100;
X{2} = 6000;
m{2} = 1.5;
B{2} = 8;
Sb{2} = 0.0008;
n{2} = 0.02;
YX{2} = 17;
Q0{2} = 500;
Q{2} = [Qmax{2},Qmin{2},Q0{2}];

%Link C3
Qmax{3} = 3500;
Qmin{3} = 1000;
X{3} = 6000;
m{3} = 1.5;
B{3} = 8;
Sb{3} = 0.0008;
n{3} = 0.02;
YX{3} = 17;
Q0{3} = 1250;
Q{3} = [Qmax{3},Qmin{3},Q0{3}];

%% Compute Parameters
C1 = link('trapezoid',{X{1},n{1},Sb{1},Q{1},YX{1},[B{1},m{1}]});
C2 = link('trapezoid',{X{2},n{2},Sb{2},Q{2},YX{2},[B{2},m{2}]});
C3 = link('trapezoid',{X{3},n{3},Sb{3},Q{3},YX{3},[B{3},m{3}]});

yd_1 = [C1.p21,C1.p22];
yd_2 = [C2.p21,C2.p22];
yd_1_ds = c2d(yd_1,time_step);
yd_2_ds = c2d(yd_2,time_step);

C123 = elementary_link_merging(C1,C2,C3);

sys = [C123.p_up{1},C123.p_up{2},C123.p_down];
sys = c2d(sys,time_step);

%% Construct System

