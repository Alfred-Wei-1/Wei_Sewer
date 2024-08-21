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
Qmin{1} = 10;
X{1} = 6000;
m{1} = 1.5;
B{1} = 8;
Sb{1} = 0.0008;
n{1} = 0.02;
YX{1} = 35;
Q0{1} = 1250;
Q{1} = [Qmax{1},Qmin{1},Q0{1}];

%Link C2
Qmax{2} = 1500;
Qmin{2} = 100;
X{2} = 4000;
m{2} = 1.5;
B{2} = 8;
Sb{2} = 0.0005;
n{2} = 0.015;
YX{2} = 35;
Q0{2} = 500;
Q{2} = [Qmax{2},Qmin{2},Q0{2}];

%Link C3
Qmax{3} = 1500;
Qmin{3} = 100;
X{3} = 5000;
m{3} = 2;
B{3} = 5;
Sb{3} = 0.0004;
n{3} = 0.01;
YX{3} = 35;
Q0{3} = 500;
Q{3} = [Qmax{3},Qmin{3},Q0{3}];

%Link C4
Qmax{4} = 250;
Qmin{4} = 50;
X{4} = 7000;
m{4} = 1;
B{4} = 10;
Sb{4} = 0.00029;
n{4} = 0.01;
YX{4} = 18;
Q0{4} = 150;
Q{4} = [Qmax{4},Qmin{4},Q0{4}];

%Link C5
Qmax{5} = 400;
Qmin{5} = 10;
X{5} = 6000;
m{5} = 1.5;
B{5} = 8;
Sb{5} = 0.0008;
n{5} = 0.02;
YX{5} = 20;
Q0{5} = 200;
Q{5} = [Qmax{5},Qmin{5},Q0{5}];

%Link C6
Qmax{6} = 500;
Qmin{6} = 10;
X{6} = 9440.316;
m{6} = 1.5;
B{6} = 8;
Sb{6} = 0.00051;
n{6} = 0.01;
YX{6} = 20;
Q0{6} = 200;
Q{6} = [Qmax{6},Qmin{6},Q0{6}];

%Link C7
Qmax{7} = 60;
Qmin{7} = 10;
X{7} = 3000;
m{7} = 1.5;
B{7} = 8;
Sb{7} = 0.0004;
n{7} = 0.01;
YX{7} = 1.8;
Q0{7} = 40;
Q{7} = [Qmax{7},Qmin{7},Q0{7}];

%Link C8
Qmax{8} = 15;
Qmin{8} = 1;
X{8} = 3000;
m{8} = 1.5;
B{8} = 8;
Sb{8} = 0.0004;
n{8} = 0.01;
YX{8} = 0.8;
Q0{8} = 8;
Q{8} = [Qmax{8},Qmin{8},Q0{8}];

%% Construct transfer functions

s = tf('s');
for i = 1:1:8
    canal{i} = link('trapezoid',{X{i},n{i},Sb{i},Q{i},YX{i},[B{i},m{i}]});

    Ad{i} = canal{i}.Ad;
    taud{i} = canal{i}.taud;
    Au{i} = canal{i}.Au;
    tauu{i} = canal{i}.tauu;

    p21_inf{i} = canal{i}.p21_inf;
    p22_inf{i} = canal{i}.p22_inf;
    p11_inf{i} = canal{i}.p11_inf;
    p12_inf{i} = canal{i}.p12_inf;
    
    p11{i} = (1/(Au{i}*s)) + p11_inf{i};
    p12{i} = -(1/(Au{i}*s) + p12_inf{i})*exp(-tauu{i}*s);
    p21{i} = (1/(Ad{i}*s) + p21_inf{i})*exp(-taud{i}*s);
    p22{i} = -1/(Ad{i}*s) - p22_inf{i};

    yu{i} = [p11{i} p12{i}];
    yd{i} = [p21{i} p22{i}];

    yu_ds{i} = c2d(yu{i},time_step);
    yu_ds{i} = ss(yu_ds{i});
    yd_ds{i} = c2d(yd{i},time_step);
    yd_ds{i} = ss(yd_ds{i});
end

  


