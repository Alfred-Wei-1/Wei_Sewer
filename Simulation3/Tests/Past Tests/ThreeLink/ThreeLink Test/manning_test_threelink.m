clear;
clc;

%% Read Data
load('hurricane_dw.mat');
N = length(J1inflow);
time_step = 5;
time = 0:time_step:N*time_step-time_step;

%% Define parameters
%Link C1
% Qmax{1} = 100;
Qmax{1} = 2500;
Qmin{1} = 10;
X{1} = 6000;
m{1} = 1.5;
B{1} = 8;
Sb{1} = 0.0008;
n{1} = 0.02;
YX{1} = 0;
% Q0{1} = 50;
Q0{1} = 1250;
Q{1} = [Qmax{1},Qmin{1},Q0{1}];

%Link C2
% Qmax{2} = 100;
Qmax{2} = 2500;
Qmin{2} = 10;
X{2} = 2000;
m{2} = 1.5;
B{2} = 2;
Sb{2} = 0.0025;
n{2} = 0.04;
YX{2} = 0;
% Q0{2} = 50;
Q0{2} = 1250;
Q{2} = [Qmax{2},Qmin{2},Q0{2}];

%Link C3
% Qmax{3} = 100;
Qmax{3} = 2500;
Qmin{3} = 10;
X{3} = 2000;
m{3} = 1.5;
B{3} = 7;
Sb{3} = 0.0015;
n{3} = 0.03;
YX{3} = 0;
% Q0{3} = 50;
Q0{3} = 1250;
Q{3} = [Qmax{3},Qmin{3},Q0{3}];


%% Compute Parameters
C1 = link('trapezoid',{X{1},n{1},Sb{1},Q{1},YX{1},[B{1},m{1}]});
C2 = link('trapezoid',{X{2},n{2},Sb{2},Q{2},YX{2},[B{2},m{2}]});
C3 = link('trapezoid',{X{3},n{3},Sb{3},Q{3},YX{3},[B{3},m{3}]});

Ad{1} = C1.Ad;
Ad{2} = C2.Ad;
Ad{3} = C3.Ad;
taud{1} = C1.taud;
taud{2} = C2.taud;
taud{3} = C3.taud;

p21_inf{1} = C1.p21_inf;
p21_inf{2} = C2.p21_inf;
p21_inf{3} = C3.p21_inf;

p22_inf{1} = C1.p22_inf;
p22_inf{2} = C2.p22_inf;
p22_inf{3} = C3.p22_inf;

%% Construct System

%Construct water level system
s = tf('s');

q_name = {'q1','q2','q3','q4'};
y_name = {'yd1','yd2','yd3'};

for i = [1,2,3]
    p21{i} = (1/(Ad{i}*s) + p21_inf{i})*exp(-taud{i}*s);
    p22{i} = -1/(Ad{i}*s) - p22_inf{i};
%     p21{i} = (1/(Ad{i}*s))*exp(-taud{i}*s);
%     p22{i} = -1/(Ad{i}*s);
    yd{i} = [p21{i} p22{i}];
    yd{i}.u = {q_name{i},q_name{i+1}};
    yd{i}.y = y_name{i};
    yd_ds{i} = c2d(yd{i},time_step);
    yd_ds{i} = ss(yd_ds{i});
end

% Construct linearization gain via manning's equation
operate_level{1} = max(J2level)*0.4;
operate_level{2} = max(J3level)*0.4;
operate_level{3} = max(J4level)*0.4;

gain{1} = C1.dmanning(operate_level{1});
gain{2} = C2.dmanning(operate_level{2});
gain{3} = C3.dmanning(operate_level{3});

gain{1} = ss(0,0,0,gain{1});
gain{2} = ss(0,0,0,gain{2});
gain{3} = ss(0,0,0,gain{3});

gain{1}.u = y_name{1}; gain{1}.y = q_name{2};
gain{2}.u = y_name{2}; gain{2}.y = q_name{3};
gain{3}.u = y_name{3}; gain{3}.y = q_name{4};

% Connect the blocks
sys = connect(yd{1},yd{2},yd{3},gain{1},gain{2},gain{3},q_name{1},y_name);

sys = c2d(sys,time_step);

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








