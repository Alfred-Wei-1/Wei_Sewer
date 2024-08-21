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
YX{1} = 12;
Q0{1} = 750;
Q{1} = [Qmax{1},Qmin{1},Q0{1}];

%Link C2
Qmax{2} = 2300;
Qmin{2} = 100;
X{2} = 4653;
m{2} = 1.5;
B{2} = 8;
Sb{2} = 0.00021;
n{2} = 0.015;
YX{2} = 13;
Q0{2} = 750;
Q{2} = [Qmax{2},Qmin{2},Q0{2}];

%Link C3
Qmax{3} = 1200;
Qmin{3} = 100;
X{3} = 5672;
m{3} = 2;
B{3} = 5;
Sb{3} = 0.00018;
n{3} = 0.01;
YX{3} = 13;
Q0{3} = 400;
Q{3} = [Qmax{3},Qmin{3},Q0{3}];

%Link C4
Qmax{4} = 2000;
Qmin{4} = 100;
X{4} = 7000;
m{4} = 2;
B{4} = 12;
Sb{4} = 0.00014;
n{4} = 0.02;
YX{4} = 13;
Q0{4} = 1000;
Q{4} = [Qmax{4},Qmin{4},Q0{4}];

%Link C5
Qmax{5} = 1400;
Qmin{5} = 100;
X{5} = 7000;
m{5} = 1;
B{5} = 10;
Sb{5} = 0.00029;
n{5} = 0.01;
YX{5} = 7;
Q0{5} = 800;
Q{5} = [Qmax{5},Qmin{5},Q0{5}];

%Link C6
Qmax{6} = 1200;
Qmin{6} = 100;
X{6} = 9000;
m{6} = 2;
B{6} = 5;
Sb{6} = 0.00033;
n{6} = 0.01;
YX{6} = 6;
Q0{6} = 450;
Q{6} = [Qmax{6},Qmin{6},Q0{6}];

%Link C7
Qmax{7} = 1000;
Qmin{7} = 50;
X{7} = 8500;
m{7} = 1.5;
B{7} = 6;
Sb{7} = 0.00059;
n{7} = 0.02;
YX{7} = 7;
Q0{7} = 400;
Q{7} = [Qmax{7},Qmin{7},Q0{7}];

%Link C8
Qmax{8} = 2200;
Qmin{8} = 100;
X{8} = 6000;
m{8} = 1.5;
B{8} = 8;
Sb{8} = 0.0008;
n{8} = 0.02;
YX{8} = 8;
Q0{8} = 900;
Q{8} = [Qmax{8},Qmin{8},Q0{8}];

%% Construct transfer functions

C{1} = link('trapezoid',{X{1},n{1},Sb{1},Q{1},YX{1},[B{1},m{1}]});
C{2} = link('trapezoid',{X{2},n{2},Sb{2},Q{2},YX{2},[B{2},m{2}]});
C{3} = link('trapezoid',{X{3},n{3},Sb{3},Q{3},YX{3},[B{3},m{3}]});
C{4} = link('trapezoid',{X{4},n{4},Sb{4},Q{4},YX{4},[B{4},m{4}]});
C{5} = link('trapezoid',{X{5},n{5},Sb{5},Q{5},YX{5},[B{5},m{5}]});
C{6} = link('trapezoid',{X{6},n{6},Sb{6},Q{6},YX{6},[B{6},m{6}]});
C{7} = link('trapezoid',{X{7},n{7},Sb{7},Q{7},YX{7},[B{7},m{7}]});
C{8} = link('trapezoid',{X{8},n{8},Sb{8},Q{8},YX{8},[B{8},m{8}]});


C12 = link_cascade({C{1},C{2}});
C1234 = elementary_link_merging(C12,C{3},C{4});

C67 = link_cascade({C{6},C{7}});
C5678_down = elementary_link_merging(C{5},C67,C{8});
C5678_up = elementary_link_merging_up(C{5},C67,C{8},1);

sys_1 = [C1234.p_up{1},C1234.p_up{2},C1234.p_down];
sys_1_ds = c2d(sys_1,time_step);

sys_2 = [C5678_down.p_up{1},C5678_down.p_up{2},C5678_down.p_down];
sys_2_ds = c2d(sys_2,time_step);

sys_3 = [C5678_up.p_up{1},C5678_up.p_up{2},C5678_up.p_down];
sys_3_ds = c2d(sys_3,time_step);

  


