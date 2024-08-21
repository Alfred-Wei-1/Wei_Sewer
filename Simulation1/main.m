clear;
clc;
close all;

format shortG
%% Read Data
load('hurricane_dw.mat');
N = length(J1inflow);
time_step = 5;
time = 0:time_step:N*time_step-time_step;

hours = seconds(time);
hours.Format = 'hh:mm';
set(0, 'DefaultLineLineWidth', 2.5);
set(0,'DefaultAxesFontName','Times')
set(0,'DefaultAxesFontSize',15)

raintable = readtable('rainfall.dat');
rainfall = construct_rainfall(raintable,N);

figure;
my_figure_rainfall = tiledlayout(2,2);
set(gcf, 'Position',  [100, 100, 1100, 500])

nexttile;
plot(hours,rainfall,'color',"#0072BD");
title('Rainfall','interpreter','latex');
xlabel('Time(hh:mm)','interpreter','latex');
ylabel("Rainfall (mm/hr)",'interpreter','latex');
grid on;

inflows = {J1inflow,J2inflow,J3inflow};

if length(inflows) == 0
else
    for i = 1:1:length(inflows)
        nexttile;
        plot(hours,inflows{i},'color',"#0072BD");
        switch i 
            case 1
                title_name = "Lateral Inflow $Q^1(0,t)$ at Upstream of Conduit" + " " + num2str(i);
            case 2
                title_name = "Lateral Inflow $Q^2_l(t)$ at Upstream of Conduit" + " " + num2str(i);
            case 3
                title_name = "Lateral Inflow $Q^3_l(t)$ at Upstream of Conduit" + " " + num2str(i);
        end
        title(title_name,'interpreter','latex');
        xlabel('Time(hh:mm)','interpreter','latex');
        ylabel("Inflow (m$^3$/s)",'interpreter','latex');
        grid on;
    end
end

%% Read Conduits data and Simulate System

linear_factor = 0.6;

index = 1;
%Link C1:
Qmax{index} = max(abs(C3flow)); %Maximum flow working around
Qmin{index} = min(abs(C3flow))+0.1; %Minimum flow
X{index} = 100; %length
B{index} = 2;
m{index} = 1.5;
Sb{index} = 0.0008; %Bed slope
n{index} = 0.013; %Manning Coefficients
YX{index} = linear_factor*max(C1downlevel); % Downstream water depth
Y_up{index} = 0;
Q0{index} = mean(C3flow); % Average flow
Q{index} = [Qmax{index},Qmin{index},Q0{index}];

index = 2;
%Link C2:
Qmax{index} = max(abs(C3flow)); %Maximum flow working around
Qmin{index} = min(abs(C3flow))+0.1; %Minimum flow
X{index} = 200; %length
B{index} = 2;
m{index} = 1.5;
Sb{index} = 0.0008; %Bed slope
n{index} = 0.013; %Manning Coefficients
YX{index} = linear_factor*max(C2downlevel); % Downstream water depth
Y_up{index} = YX{index-1};
Q0{index} = mean(C3flow); % Average flow
Q{index} = [Qmax{index},Qmin{index},Q0{index}];

index = 3;
%Link C3:
Qmax{index} = max(abs(C3flow)); %Maximum flow working around
Qmin{index} = min(abs(C3flow))+0.1; %Minimum flow
X{index} = 150; %length
B{index} = 2;
m{index} = 1.5;
Sb{index} = 0.0008; %Bed slope
n{index} = 0.013; %Manning Coefficients
YX{index} = linear_factor*max(C3downlevel); % Downstream water depth
Y_up{index} = YX{index-1};
Q0{index} = mean(C3flow); % Average flow
Q{index} = [Qmax{index},Qmin{index},Q0{index}];

C1 = link('trapezoid',{X{1},n{1},Sb{1},Q{1},YX{1},Y_up{1},[B{1},m{1}]});
C2 = link('trapezoid',{X{2},n{2},Sb{2},Q{1},YX{2},Y_up{2},[B{2},m{2}]});
C3 = link('trapezoid',{X{3},n{3},Sb{3},Q{1},YX{3},Y_up{3},[B{3},m{3}]});

C1_model = model_link({C1.p11},C1.p12,{C1.p21},C1.p22);
C123 = advanced_link_cascade({C1_model,C2,C3});
C123_model = C123;

Cd = 0.65;
A0 = 0.2*1.5;
g = 9.81;
Yfull = 0.2;
Z0 = 0.4;
OR = [Cd,A0,g,Yfull,Z0];

% Below two are nonlinear simulations
inflows = {J1inflow,J2inflow,J3inflow};
inflows = delay_inflow_ds(inflows,C123_model,time_step);
[Y_1d_n,outflow_n] = ds_capital_nonlinear_1o_simulation(inflows,C123_model,OR,time_step,N);

inflows = {J1inflow,J2inflow,J3inflow};
inflows = delay_inflow_us(inflows,C123_model,time_step);
Y_1u_n = us_capital_nonlinear_1o_simulation(inflows,C123_model,OR,outflow_n,time_step,N);

% Below two are linear simulations
h = 0.01;
OR_gain = (torri(YX{3}+h,OR) - torri(YX{3},OR))/h;

[A1,B1,E1,C1,D1,F1] = equivCond_matrix(C123_model,0,OR_gain,0,1);
[A1,B1,E1,C1,D1,F1] = discretize_matrices(A1,B1,E1,C1,D1,F1,time_step);

op_flow = Q0{end};
op_depth = YX{end};
OR_flow = torri(YX{end},OR);
inflows = {J1inflow,J2inflow,J3inflow};
inflows = delay_inflow_ds(inflows,C123_model,time_step);
K_constant = OR_gain;
[Y1_dlinear,outflow_linear] = ds_capital_linear_1o_simulation_notint(inflows,C123_model,K_constant,YX{end},OR_flow,time_step,N);


inflows = {J1inflow,J2inflow,J3inflow};
inflows = delay_inflow_us(inflows,C123_model,time_step);
Y1_ulinear = us_capital_linear_1o_simulation(inflows,C123_model,outflow_linear',time_step,N);


C2_model = model_link({C2.p11},C2.p12,{C2.p21},C2.p22);
C3_model = model_link({C3.p11},C3.p12,{C3.p21},C3.p22);
print_model_link_parameters(C1_model,'C1')
print_model_link_parameters(C2_model,'C2')
print_model_link_parameters(C3_model,'C3')
print_model_link_parameters(C123_model,'C123')
%% Plot the results

figure;
my_figure_2 = tiledlayout(1,2);
sgtitle('Depths in Cascading Conduits','interpreter','latex','fontsize',15);
set(gcf, 'Position',  [100, 100, 1200, 500])

nexttile;
plot(hours,Y_1u_n,'color',	"#7E2F8E",'LineStyle','-.');
hold on;
plot(hours,J1level,'color',"#77AC30");
grid on;
ylabel('Water Depth (m)','interpreter','latex');
xlabel('Time(hh:mm)','interpreter','latex')
% legend('Nonlinear Feedback','PCSWMM Simulation','interpreter','latex','Location','northeast');
title('Upstream Level $Y^1(0,t)$','interpreter','latex');
ylim([0,inf]);

nexttile;
plot(hours,Y_1d_n,'color',	"#7E2F8E",'LineStyle','-.');
hold on;
% plot(hours,Y1_dlinear);
plot(hours,SUlevel,'color',"#77AC30");
grid on;
ylabel('Water Depth (m)','interpreter','latex');
xlabel('Time(hh:mm)','interpreter','latex')
legend('Nonlinear Feedback','PCSWMM Simulation','interpreter','latex','Location','northeast');
title('Downstream Level $Y^3(X,t)$','interpreter','latex');
ylim([0,inf]);

figure;
my_figure_3 = tiledlayout(1,2);
sgtitle('Depths in Cascading Conduits with Linear Feedback','interpreter','latex','fontsize',15);
set(gcf, 'Position',  [100, 100, 1200, 500])

nexttile;
plot(hours,Y_1u_n,'color',	"#7E2F8E",'LineStyle','-.');
hold on;
plot(hours,Y1_ulinear,':');
plot(hours,J1level,'color',"#77AC30");
grid on;
ylabel('Water Depth (m)','interpreter','latex');
xlabel('Time(hh:mm)','interpreter','latex')
% legend('Nonlinear Feedback','Linear Feedback','PCSWMM Simulation','interpreter','latex','Location','northeast');
title('Upstream Level $Y^1(0,t)$','interpreter','latex');
ylim([0,inf]);

nexttile;
plot(hours,Y_1d_n,'color',	"#7E2F8E",'LineStyle','-.');
hold on;
plot(hours,Y1_dlinear,':');
plot(hours,SUlevel,'color',"#77AC30");
grid on;
ylabel('Water Depth (m)','interpreter','latex');
xlabel('Time(hh:mm)','interpreter','latex')
legend('Nonlinear Feedback','Linear Feedback','PCSWMM Simulation','interpreter','latex','Location','northeast');
title('Downstream Level $Y^3(X,t)$','interpreter','latex');
ylim([0,inf]);

 


%% The nonlinear Torricelli's Law

function Q = torri_full(Y,W,data)

% Import Orifice Data
Cd = data(1);
A0 = data(2);
g = data(3);
Yfull = data(4);
Z0 = data(5);

% Adjust Area Opening according to W
A0 = W*A0;

% Compute Outflow
if Y <= Z0
        Q = 0;
    elseif Y > Z0 && Y < Z0 + W*Yfull
        CwL = (Cd*A0*sqrt(g))/(W*Yfull);
        Q = CwL*(Y-Z0)^(1.5);
    else
        He = Y-(Z0 + (W*Yfull)/2);
        Q = Cd*A0*sqrt(2*g*He);
end

end

function Q = torri(Y,data)

% Import Orifice Data
Cd = data(1);
A0 = data(2);
g = data(3);
Yfull = data(4);
Z0 = data(5);

constant = sqrt(32/27);
boundary = 0.25*(3*Yfull + 4*Z0);

% constant = 1;
% boundary = Yfull + Z0;

% Compute Outflow
if Y <= Z0
        Q = 0;
    elseif Y > Z0 && Y < boundary
        CwL = (Cd*A0*sqrt(g))/(Yfull);
        CwL = constant*CwL;
        Q = CwL*(Y-Z0)^(1.5);
    else
        He = Y-(Z0 + Yfull/2);
        Q = Cd*A0*sqrt(2*g*He);
end
end




