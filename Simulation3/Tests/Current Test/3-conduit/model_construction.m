clear;
clc;

format shortG
%% Read Data
load('hurricane_dw.mat');
N = length(J1inflow);
time_step = 5;
time = 0:time_step:N*time_step-time_step;

%% Define parameters

linear_factor = 0.7;

index = 1;
%Link C1:
Qmax{index} = max(abs(C3flow)); %Maximum flow working around
Qmin{index} = min(abs(C3flow)) + 10; %Minimum flow
X{index} = 6000; %length
m{index} = 1.5; %trapezoid side slope
B{index} = 8; %trapezoid bottom lenth
Sb{index} = 0.0008; %Bed slope
n{index} = 0.02; %Manning Coefficients
YX{index} = linear_factor*max(C1downlevel); % Downstream water depth
Y_up{index} = 0;
Q0{index} = mean(C3flow); % Average flow
Q{index} = [Qmax{index},Qmin{index},Q0{index}];

index = 2;
%Link C2:
Qmax{index} = max(abs(C3flow)); %Maximum flow working around
Qmin{index} = min(abs(C3flow)) + 10; %Minimum flow
X{index} = 2000; %length
m{index} = 1.5; %trapezoid side slope
B{index} = 6; %trapezoid bottom lenth
Sb{index} = 0.002; %Bed slope
n{index} = 0.04; %Manning Coefficients
YX{index} = linear_factor*max(C2downlevel); % Downstream water depth
Y_up{index} = YX{index-1};
Q0{index} = mean(C3flow); % Average flow
Q{index} = [Qmax{index},Qmin{index},Q0{index}];

index = 3;
%Link C3:
Qmax{index} = max(abs(C3flow)); %Maximum flow working around
Qmin{index} = min(abs(C3flow)) + 10; %Minimum flow
X{index} = 5000; %length
m{index} = 1.5; %trapezoid side slope
B{index} = 8; %trapezoid bottom lenth
Sb{index} = 0.0004; %Bed slope
n{index} = 0.01; %Manning Coefficients
YX{index} = linear_factor*max(C3downlevel); % Downstream water depth
Y_up{index} = YX{index-1};
Q0{index} = mean(C3flow); % Average flow
Q{index} = [Qmax{index},Qmin{index},Q0{index}];


%% Compute Parameters
C1 = link('trapezoid',{X{1},n{1},Sb{1},Q{1},YX{1},Y_up{1},[B{1},m{1}]});
C2 = link('trapezoid',{X{2},n{2},Sb{2},Q{2},YX{2},Y_up{2},[B{2},m{2}]});
C3 = link('trapezoid',{X{3},n{3},Sb{3},Q{3},YX{3},Y_up{3},[B{3},m{3}]});

% C123 = elementary_link_cascade({C1,C2,C3});
% format shortG;
% print_link_parameters(C1,'C1')
% print_link_parameters(C2,'C2')
% print_link_parameters(C3,'C3')
% print_link_parameters(C123,'C123')

C1_model = model_link({C1.p11},C1.p12,{C1.p21},C1.p22);
C123 = advanced_link_cascade({C1_model,C2,C3});

yu = [C123.p1k{1},C123.p1k{2},C123.p1k{3},C123.p1n];
yd = [C123.p2k{1},C123.p2k{2},C123.p2k{3},C123.p2n];
yu_ds = c2d(yu,time_step);
yd_ds = c2d(yd,time_step);

% %[,,"#EDB120",	"#7E2F8E","#D95319"
hours = seconds(time);
hours.Format = 'hh:mm';
set(0, 'DefaultLineLineWidth', 1.8);

%% Simulation of yd
Cd = 0.65;
A0 = 100;
g = 9.81;
Yfull = 10;
Z0 = 10;

temp = ss(yd_ds);
A = temp.A;
B = temp.B;
C = temp.C;
D = temp.D;
taud = temp.InputDelay;
delay_steps_1 = taud(1);
delay_steps_2 = taud(2);
delay_steps_3 = taud(3);

% Initialize variables
Q_0 = J1inflow;
Q_1 = J2inflow;
Q_2 = J3inflow;
q_0 = Q_0 - Q0{1};
q_1 = Q_1;
q_2 = Q_2;
% q_0 = Q_0;
% q_1 = Q_1;
% q_2 = Q_2;

y_X = nan(1,N);
Y_X = nan(1,N);
Q_X = nan(1,N);
q_X = nan(1,N);
x = nan(1,N);
flow = nan(4,N);

Y_X(1)=0;
Q_X(1) = 0;
y_X(1)= Y_X(1)-YX{3};
q_X(1) = Q_X(1)-Q0{1};
% y_X(1) = Y_X(1);
% q_X(1) = Q_X(1);

for t = 1:1:N-1
    Y_X(t) = y_X(t) + YX{3};
    %     Y_X(t) = y_X(t);
    % Compute gate outflow
    if Y_X(t) <= Z0
        Q_X(t) = 0;
    elseif Y_X(t) > Z0 && Y_X(t) < Z0 + Yfull
        CwL = (Cd*A0*sqrt(g))/(Yfull);
        Q_X(t) = CwL*(Y_X(t)-Z0)^(1.5);
    else
        He = Y_X(t)-(Z0 + Yfull/2);
        Q_X(t) = Cd*A0*sqrt(2*g*He);
    end
    q_X(t) = Q_X(t) - Q0{1};
%     q_X(t) = Q_X(t);
    
    % Determine flow by incorporating delay
    if t <= delay_steps_3
        flow(:,t) = [0 - Q0{1};0;0;q_X(t)];
% flow(:,t) = [0;0;0;q_X(t)];
    elseif t > delay_steps_3 && t <= delay_steps_2
        flow(:,t) = [0 - Q0{1};0;q_2(t-delay_steps_3);q_X(t)];
% flow(:,t) = [0;0;q_2(t-delay_steps_3);q_X(t)];
    elseif t > delay_steps_2 && t <= delay_steps_1
        flow(:,t) = [0 - Q0{1};q_1(t-delay_steps_2);q_2(t-delay_steps_3);q_X(t)];
% flow(:,t) = [0;q_1(t-delay_steps_2);q_2(t-delay_steps_3);q_X(t)];
    else
        flow(:,t) = [q_0(t-delay_steps_1);q_1(t-delay_steps_2);q_2(t-delay_steps_3);q_X(t)];
    end
    
    % Set the initial condition of x
    if t == 1
        x(1) = inv(C)*(y_X(1)-D*flow(:,1));
%         x(1) = 0;
    end

    % Update state and output
    x(t+1) = A*x(t)+B*flow(:,t);
    y_X(t+1) = C*x(t+1) + D*flow(:,t);
end

Y_downstream = Y_X;

%% Simulation of yu


temp = ss(yu_ds);
A = temp.A;
B = temp.B;
C = temp.C;
D = temp.D;
tauu = temp.InputDelay;
delay_steps_1 = tauu(2);
delay_steps_2 = tauu(3);
delay_steps_3 = tauu(4);

% Initialize variables
y_0 = nan(1,N);
Y_0 = nan(1,N);
x = nan(1,N);

Y_0(1)=0;
%  y_0(1)= Y_0(1)-C1.Yn;
 y_0(1) = Y_0(1);

for t = 1:1:N-1
%     Y_0(t) = y_0(t) + C1.Yn;
Y_0(t) = y_0(t);
    
    % Set flow according to current delay
    if t <= delay_steps_1
        flow(:,t) = [q_0(t);0;0;0];
    elseif t > delay_steps_1 && t <= delay_steps_2
        flow(:,t) = [q_0(t);q_1(t - delay_steps_1);0;0];
    elseif t > delay_steps_2 && t <= delay_steps_3
        flow(:,t) = [q_0(t);q_1(t - delay_steps_1);q_2(t-delay_steps_2);0];
    else
        flow(:,t) = [q_0(t);q_1(t - delay_steps_1);q_2(t-delay_steps_2);q_X(t-delay_steps_3)];
    end
    
    % Set the initial condition of x
    if t == 1
%         x(1) = inv(C)*(y_0(1)-D*flow(:,1));
x(1) = 0;
    end

    % Update state and output
    x(t+1) = A*x(t)+B*flow(:,t);
    y_0(t+1) = C*x(t+1) + D*flow(:,t);
end

Y_upstream = Y_0;



my_figure = tiledlayout(1,2);
set(gcf, 'Position',  [100, 100, 900, 235])

nexttile;
plot(hours,Y_upstream,'color',"#0072BD");
hold on;
plot(hours,J1level,'color',"#77AC30");
grid on;
ylabel('Water Depth (m)','interpreter','latex');
xlabel('Time(hh:mm)','interpreter','latex')
% legend('IDZ Model with Nonlinear Feedback','PCSWMM Simulation','interpreter','latex','Location','northwest');
title('Upstream Level $Y^1(0,t)$','interpreter','latex');

nexttile;
plot(hours,Y_downstream,'color',"#0072BD");
hold on;
plot(hours,SUlevel,'color',"#77AC30");
grid on;
ylabel('Water Depth (m)','interpreter','latex');
xlabel('Time(hh:mm)','interpreter','latex')
legend('IDZ Model','PCSWMM Simulation','interpreter','latex','Location','southeast');
title('Downstream Level $Y^3(X,t)$','interpreter','latex');

%% Draw rainfall and inflow

% average_rainfall = nan(1,N/(3600/time_step));
% 
% counter = 1;
% for i=1:720:N
%     if counter == 1
%         average_rainfall(counter) = rainfall(720-1) - 0;
%     else
%         average_rainfall(counter) = rainfall(i+720-1) - rainfall(i-1);
%     end
%     if counter == N/(3600/time_step)
%         break;
%     end
%     counter = counter + 1;
% end
% 
% rainfall = zeros(1,N);
% for i = 1:1:N
%     rainfall(i) = average_rainfall(ceil(i/(3600/time_step)));
% end
% 
% my_figure = tiledlayout(2,2);
% set(gcf, 'Position',  [100, 100, 800, 400])
% 
% nexttile;
% plot(hours,rainfall,'color',"#0072BD");
% title('Rainfall','interpreter','latex');
% xlabel('Time(hh:mm)','interpreter','latex');
% ylabel("Rainfall (mm/hr)",'interpreter','latex');
% grid on;
% nexttile;
% plot(hours,J1inflow,'color',"#0072BD");
% title('Upstream Inflow $Q(0,t)$','interpreter','latex');
% xlabel('Time(hh:mm)','interpreter','latex');
% ylabel("Inflow (m$^3$/s)",'interpreter','latex');
% grid on;
% nexttile;
% plot(hours,J2inflow,'color',"#0072BD");
% title('Lateral Inflow $Q^2_l(t)$','interpreter','latex');
% xlabel('Time(hh:mm)','interpreter','latex');
% ylabel("Inflow (m$^3$/s)",'interpreter','latex');
% grid on;
% nexttile;
% plot(hours,J3inflow,'color',"#0072BD");
% title('Lateral Inflow $Q^3_l(t)$','interpreter','latex');
% xlabel('Time(hh:mm)','interpreter','latex');
% ylabel("Inflow (m$^3$/s)",'interpreter','latex');
% grid on;





%% Determine the linear feedback gain using Sigmoid
middle_gate_gain = (torri(YX{1})-torri(YX{1}-0.01))/0.01 + 0;
% middle_gate_gain = 0.5*middle_gate_gain;
% middle_gate_gain = (smoothed_torri(YX{1})-smoothed_torri(YX{1}-0.01))/0.01 + 0;

linear_gain = middle_gate_gain
% linear_gain = 21;

%% Linear Simulation Part
% Initialize variables
% Q_0 = J1inflow;
% q_0 = Q_0 - Q0{1};
% y_X = nan(1,N);
% Y_X = nan(1,N);
% Q_X = nan(1,N);
% q_X = nan(1,N);
% x = nan(1,N);
% flow = nan(2,N);
% 
% Y_X(1)=0;
% Q_X(1) = 0;
% y_X(1)= Y_X(1)-YX{1};
% q_X(1) = Q_X(1)-Q0{1};
% 
% for t = 1:1:N-1
%     % Compute gate outflow
%     Y_X(t) = y_X(t) + YX{1};
%     Q_X(t) = linear_gain*Y_X(t);
%     q_X(t) = Q_X(t) - Q0{1};
%     
%     % Determine flow by incorporating delay
%     if t <= delay_steps
%         flow(:,t) = [0 - Q0{1};q_X(t)];
%     else
%         flow(:,t) = [q_0(t-delay_steps);q_X(t)];
%     end
%     
%     % Set the initial condition of x
%     if t == 1
%         x(1) = inv(C)*(y_X(1)-D*flow(:,1));
%     end
% 
%     % Update state and output
%     x(t+1) = A*x(t)+B*flow(:,t);
%     y_X(t+1) = C*x(t+1) + D*flow(:,t);
% end

% my_figure = tiledlayout(1,1);
% set(gcf, 'Position',  [100, 100, 800, 235])
% plot(hours,Y_X_nonlinear,'color',"#0072BD");
% hold on;
% plot(hours,SUlevel,'color',"#77AC30");
% plot(hours,Y_X,'color',"#EDB120");
% grid on;
% ylabel('Water Depth (m)','interpreter','latex');
% xlabel('Time(hh:mm)','interpreter','latex')
% legend('IDZ Model with Nonlinear Feedback','PCSWMM Simulation','IDZ Model with Linear Feedback','interpreter','latex','Location','northeast');

% figure;
% Y_array = linspace(11,50,1000);
% Q_array_1 = zeros(1,1000);
% Q_array_2 = zeros(1,1000);
% for i = 1:1:1000
%     Q_array_1(i) = torri(Y_array(i));
%     Q_array_2(i) = smoothed_torri(Y_array(i));
% end
% plot(Y_array,Q_array_1);
% hold on;
% plot(Y_array,Q_array_2)
% legend('torri','smoothed torri');


%% The nonlinear Torricelli's Law

function Q = torri(Y)
Cd = 0.65;
A0 = 64;
g = 9.81;
Yfull = 8;
Z0 = 10;

    if Y <= Z0
        Q = 0;
    elseif Y > Z0 && Y < Z0 + Yfull
        CwL = (Cd*A0*sqrt(g))/(Yfull);
        Q = CwL*(Y-Z0)^(1.5);
    else
        He = Y-(Z0 + Yfull/2);
        Q = Cd*A0*sqrt(2*g*He);
    end
end

function Q = torri_nonzero(Y)
Cd = 0.65;
A0 = 64;
g = 9.81;
Yfull = 8;
Z0 = 10;

    if Y > Z0 && Y < Z0 + Yfull
        CwL = (Cd*A0*sqrt(g))/(Yfull);
        Q = CwL*(Y-Z0)^(1.5);
    elseif Y >= Z0 + Yfull/2
        He = Y-(Z0 + Yfull/2);
        Q = Cd*A0*sqrt(2*g*He);
    end
end

function Q = sigmoid(Y)
    a = 0.5;
    Z0 = 10;
    Q = 1/(1+exp((Z0-Y)/a));
end

function Q = smoothed_torri(Y)
    Q = torri_nonzero(Y)*sigmoid(Y);
end





