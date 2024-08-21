clear;
clc;

% load('scs10_sf.mat');
% load('hurricane_sf.mat');
% load('scs10_dw.mat');
load('hurricane_dw.mat');

N = length(J1inflow);
t = linspace(0,N,N);

% figure;
% plot(t,J1inflow);
% hold;
% plot(t,J2inflow);
% title('Lateral Inflow');
% legend('J1inflow','J2inflow');
% 
% figure;
% plot(t,Merglevel);
% hold on;
% title('Merg Water Level');

figure;
plot(t,J11inflow)
title('J11inflow');

figure;
plot(t,J1level)
title('J1level');

figure;
plot(t,C1flow)
title('C1inflow');

figure;
plot(t,C1downlevel)
title('C1downlevel');
