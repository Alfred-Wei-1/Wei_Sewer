clear;
clc;

%% Read Data
load('hurricane_dw.mat');
N = length(J1inflow);
time_step = 5;
time = 0:time_step:N*time_step-time_step;

%% Define parameters
%Link C1
Qmax{1} = 2500;
Qmin{1} = 100;
X{1} = 6000;
m{1} = 1.5;
B{1} = 8;
Sb{1} = 0.0008;
n{1} = 0.02;
YX{1} = 0;
Q0{1} = 1250;
Q{1} = [Qmax{1},Qmin{1},Q0{1}];

%Link C2
Qmax{2} = 1200;
Qmin{2} = 100;
X{2} = 6000;
m{2} = 1.5;
B{2} = 8;
Sb{2} = 0.0008;
n{2} = 0.02;
YX{2} = 0;
Q0{2} = 600;
Q{2} = [Qmax{2},Qmin{2},Q0{2}];

%Link C3
Qmax{3} = 1200;
Qmin{3} = 100;
X{3} = 6000;
m{3} = 1.5;
B{3} = 8;
Sb{3} = 0.0008;
n{3} = 0.02;
YX{3} = 0;
Q0{3} = 600;
Q{3} = [Qmax{3},Qmin{3},Q0{3}];

%% Compute Parameters
C1 = link('trapezoid',{X{1},n{1},Sb{1},Q{1},YX{1},[B{1},m{1}]});
C2 = link('trapezoid',{X{2},n{2},Sb{2},Q{2},YX{2},[B{2},m{2}]});
C3 = link('trapezoid',{X{3},n{3},Sb{3},Q{3},YX{3},[B{3},m{3}]});

Ad{1} = C1.Ad_uni;
Ad{2} = C2.Ad_uni;
Ad{3} = C3.Ad_uni;
taud{1} = C1.taud_uni;
taud{2} = C2.taud_uni;
taud{3} = C3.taud_uni;

p21_inf{1} = C1.p21_inf;
p21_inf{2} = C2.p21_inf;
p21_inf{3} = C3.p21_inf;

p22_inf{1} = C1.p22_inf;
p22_inf{2} = C2.p22_inf;
p22_inf{3} = C3.p22_inf;

%% Construct System

%Construct water level system
s = tf('s');

for i = [1,2,3]
    p21{i} = (1/(Ad{i}*s) + p21_inf{i})*exp(-taud{i}*s);
    p22{i} = -1/(Ad{i}*s) - p22_inf{i};
    yd{i} = [p21{i} p22{i}];
    yd_ds{i} = c2d(yd{i},time_step);
    yd_ds{i} = ss(yd_ds{i});
end

% Construct linearization gain via manning's equation
operate_level = 1;

gain = C1.dmanning(operate_level);
