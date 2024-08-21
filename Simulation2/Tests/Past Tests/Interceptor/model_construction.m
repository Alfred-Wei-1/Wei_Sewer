clear;
clc;

%% Read Data
load('hurricane_dw.mat');
N = length(J1inflow);
time_step = 5;
time = 0:time_step:N*time_step-time_step;

%% Define parameters

linear_factor = 0.6;

index = 1;
%Link C1:
Qmax{index} = max(abs(C1flow)); %Maximum flow working around
Qmin{index} = min(abs(C1flow)) + 10; %Minimum flow
X{index} = 6000; %length
m{index} = 1.5; %trapezoid side slope
B{index} = 8; %trapezoid bottom lenth
Sb{index} = 0.00033; %Bed slope
n{index} = 0.02; %Manning Coefficients
YX{index} = linear_factor*max(C1downlevel); % Downstream water depth
Q0{index} = 0.5*max(abs(C1flow)); % Average flow
Q{index} = [Qmax{index},Qmin{index},Q0{index}];


%% Compute Parameters
C1 = link('trapezoid',{X{1},n{1},Sb{1},Q{1},YX{1},[B{1},m{1}]});

yd = [C1.p21,C1.p22];
yd_ds = c2d(yd,time_step);
temp = ss(yd_ds);
A = temp.A;
B = temp.B;
C = temp.C;
D = temp.D;
taud = temp.InputDelay;

%% Determine the linear feedback gain
YX = YX{1};
middle_gate_gain = (torri_middle(YX)-torri_middle(YX-0.01))/0.01 + 0;
middle_gate_gain = 0.5*middle_gate_gain;
bottom_gate_gain = (torri_bottom(YX)-torri_bottom(YX-0.01))/0.01;

linear_gain = bottom_gate_gain + middle_gate_gain

%% Simulation
Cd = 0.65;
A0 = 1;
g = 9.81;
Yfull = 1;

% Initialize variables
x_nl = [0];
y_nl = [0];
u_nl = [0;0];

for t = 1:1:N-1
    % Determine u1(inflow) and u2(outflow)
    u1 = J1inflow(t);
    
    % Compute bottom gate outflow
    if  y_nl(t) >= Yfull
        He = y_nl(t) - Yfull/2;
        u2_1 = Cd*A0*sqrt(2*g*He);
    else
        CwL = (Cd*A0*sqrt(g))/(Yfull);
        u2_1 = CwL*y_nl(t)^(1.5);
    end

    % Compute middle gate outflow
    if y_nl(t) <= 10
        u2_2 = 0;
    elseif y_nl(t) > 10 && y_nl(t) < 15
        CwL = (Cd*25*sqrt(g))/(5);
        u2_2 = CwL*(y_nl(t)-10)^(1.5);
    else
        He = (y_nl(t)-10) - 2.5;
        u2_2 = Cd*25*sqrt(2*g*He);
    end

    % Add up gate flow
    u2 = u2_1 + u2_2;
    control = [u1;u2];
    u_nl = [u_nl [u1;u2]];

    % Update state and output
    x_nl = [x_nl A*x_nl(t)+B*control];
    y_nl = [y_nl C*x_nl(t+1) + D*control];
end

% The linear simulation part
x_l = [0];
y_l = [0];
u_l = [0;0];

for t = 1:1:N-1
    % Determine u1(inflow) and u2(outflow)
    u1 = J1inflow(t);

    % Add up gate flow
    u2 = linear_gain*y_l(t);
    control = [u1;u2];
    u_l = [u_l [u1;u2]];

    % Update state and output
    x_l = [x_l A*x_l(t)+B*control];
    y_l = [y_l C*x_l(t+1) + D*control];
end

set(0, 'DefaultLineLineWidth', 1.5);

figure;
plot(time,y_nl);
hold on;
plot(time,y_l);
plot(time,SU1level);
legend('Model Nonlinear','Model Linear','Actual');
title('SU1level Comparison');
xlabel('Time (5s)');
ylabel('Depth (m)');

%% The nonlinear Torricelli's Law

function q = torri_bottom(y)
    Yfull = 1;
    Cd = 0.65;
    A0 = 1;
    g = 9.81;
    % Compute bottom gate outflow
    if  y >= Yfull
        He = y - Yfull/2;
        q = Cd*A0*sqrt(2*g*He);
    else
        CwL = (Cd*A0*sqrt(g))/(Yfull);
        q = CwL*y^(1.5);
    end
end

function q = torri_middle(y)
    Cd = 0.65;
    g = 9.81;
    % Compute middle gate outflow
    if y <= 10
        q = 0;
    elseif y > 10 && y < 15
        CwL = (Cd*25*sqrt(g))/(5);
        q = CwL*(y-10)^(1.5);
    else
        He = (y-10) - 2.5;
        q = Cd*25*sqrt(2*g*He);
    end
end






