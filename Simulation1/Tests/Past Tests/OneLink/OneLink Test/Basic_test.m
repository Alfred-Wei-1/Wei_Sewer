clear;
clc;

load('scs10_dw.mat');
N = length(J1inflow);
time = linspace(0,N,N);

%Canal 2 from 53 
Qmax = 10;
Qmin = 0.5;
% Qmax = 40;
% Qmin = 10;
X = 6000;
m = 1.5;
B = 8;
Sb = 0.0008;
n = 0.02;
YX = 0;
bank = @(x) -Sb*x + (Sb*X);

%Find parameters
Q = [Qmax,Qmin,Qmax/2];
canal = link('trapezoid',{X,n,Sb,Q,YX,[B,m]});

J2_out_manning = 1/(canal.n).*canal.A(J2level).*((canal.R(J2level)).^(2/3)).*sqrt(canal.Sb);

%We only analyze the downstream water level
Ad = canal.Ad;
% Ad = 0.6e4;
taud = canal.taud;
% taud = 700;
p21_inf = canal.p21_inf;
p22_inf = canal.p22_inf;

s = tf('s');
p21 = (1/(Ad*s) + p21_inf)*exp(-taud*s);
p22 = -1/(Ad*s) - p22_inf;
% p21 = (1/(Ad*s))*exp(-taud*s);
% p22 = -1/(Ad*s);
% p21 = (1/(Ad*s));
% p22 = -1/(Ad*s);
yd = [p21 p22];
yd.u = {'qu','qd'};
yd.y = 'yd';
sys = yd;

%Simulation
% qu = J1inflow - canal.Q0;
% qd = J2outflow - canal.Q0;
qu = J1inflow ;
% qd = J2outflow;
qd = J2_out_manning;

yd = lsim(sys,[qu',qd'],time);

% figure;
% plot(time,yd + canal.YX*ones(N,1));
% % plot(time,yd);
% hold;
% plot(time,J2level);
% title('J2 Water Level');
% legend('Model','Actual');

% figure;
% plot(time,J1inflow);
% hold;
% plot(time,J2outflow);
% title('Inflow and Outflow');
% legend('Inflow','Outflow');

% figure;
% plot(time,J2level);
% hold;
% plot(time,J2outflow);
% title('J2 level and flow');
% legend('Level','Flow');

% in = @(x) trapz(J1inflow(1:x)-J2outflow(1:x));
% inte = [];
% for i  = 1:1:N
%     inte = [inte in(i)];
% end
% 
% figure;
% plot(time,inte);
% hold;
% plot(time,1e4*J2level);

J2_out_manning = 1/(canal.n).*canal.A(J2level).*((canal.R(J2level)).^(2/3)).*sqrt(canal.Sb);
plot(time,J2_out_manning)
hold;
plot(time,1.6*J2outflow)
plot(time,5*J2level);
legend('Manning_Flow','Actual_Flow','level_scalar_multiple');