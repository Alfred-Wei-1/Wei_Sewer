clear;
clc;

% load('scs10_dw.mat'); 
% load('scs10_sf.mat'); 
load('hurricane_dw.mat');
% load('hurricane_sf.mat');
N = length(J1inflow);
time_step = 5;
time = 0:time_step:N*time_step-time_step;

%Conduit in PCSWMM Test
%scs10 data
Qmax = 100;
Qmin = 10;

%hurricane data
Qmax = 2500;
Qmin = 500;
X = 6000;
m = 1.5;
B = 8;
Sb = 0.0008;
n = 0.02;
YX = 0;

Q0 = 1250;
% Q = [Qmax,Qmin,Qmax/2];
Q = [Qmax,Qmin,Q0];
canal = link('trapezoid',{X,n,Sb,Q,YX,[B,m]});

%Extract the parameters
Ad = canal.Ad;
taud = canal.taud;
Au = canal.Au;
tauu = canal.tauu;
p21_inf = canal.p21_inf;
p22_inf = canal.p22_inf;
p11_inf = canal.p11_inf;
p12_inf = canal.p12_inf;

%Define transfer functions
s = tf('s');
p21 = (1/(Ad*s) + p21_inf)*exp(-taud*s);
p22 = -1/(Ad*s) - p22_inf;

yd = [p21 p22];
yd.u = {'qu','qd'};
yd.y = 'yd';

yd_ds = c2d(yd,time_step);
yd_ds = ss(yd_ds);

gain = ss(0,0,0,20.25); % 28 comes from differentiating manning's equation around YX/2
gain.u = 'yd';
gain.y = 'qd';
sys = connect(yd,gain,'qu','yd');

sys = c2d(sys,time_step);

%Simulate the discretized system
qu = J1inflow;

% yd = lsim(sys,qu',time);
% 
% plot(time,yd)
% hold on;
% plot(time,J2level)
% legend('Model','Actual');
