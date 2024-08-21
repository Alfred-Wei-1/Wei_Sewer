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

figure('Renderer','painters');
my_figure_rainfall = tiledlayout(3,2);
set(gcf, 'Position',  [100, 100, 1100, 500])

nexttile;
plot(hours,rainfall,'color',"#0072BD");
title('Rainfall','interpreter','latex');
xlabel('Time(hh:mm)','interpreter','latex');
ylabel("Rainfall (mm/hr)",'interpreter','latex');
grid on;

inflows = {J1inflow,J2inflow,J3inflow,J4inflow,J5inflow};

if length(inflows) == 0
else
    for i = 1:1:length(inflows)
        nexttile;
        plot(hours,inflows{i},'color',"#0072BD");
        if i == 1
            title_name = "Lateral Inflow $Q^1(0,t)$ at Upstream of Conduit" + " " + num2str(i);
        else
            title_name = "Lateral Inflow $Q^"+ num2str(i) +  "_l(t)$ at Upstream of Conduit" + " " + num2str(i);
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
Qmax{index} = max(abs(C1flow)); %Maximum flow working around
Qmin{index} = min(abs(C1flow))+0.1; %Minimum flow
X{index} = 300; %length
B{index} = 1;
m{index} = 1.5;
Sb{index} = 0.0004; %Bed slope
n{index} = 0.013; %Manning Coefficients
YX{index} = linear_factor*max(C1downlevel); % Downstream water depth
Y_up{index} = 0;
Q0{index} = mean(C5flow)/4; % Average flow
Q{index} = [Qmax{index},Qmin{index},Q0{index}];

index = 2;
%Link C2:
Qmax{index} = max(abs(C2flow)); %Maximum flow working around
Qmin{index} = min(abs(C2flow))+0.1; %Minimum flow
X{index} = 200; %length
B{index} = 1;
m{index} = 1.5;
Sb{index} = 0.0006; %Bed slope
n{index} = 0.013; %Manning Coefficients
YX{index} = linear_factor*max(C2downlevel); % Downstream water depth
Y_up{index} = 0;
Q0{index} = mean(C5flow)/4; % Average flow
Q{index} = [Qmax{index},Qmin{index},Q0{index}];

index = 3;
%Link C3:
Qmax{index} = max(abs(C3flow)); %Maximum flow working around
Qmin{index} = min(abs(C3flow))+0.1; %Minimum flow
X{index} = 600; %length
B{index} = 1.5;
m{index} = 1.5;
Sb{index} = 0.0002; %Bed slope
n{index} = 0.013; %Manning Coefficients
YX{index} = linear_factor*max(C3downlevel); % Downstream water depth
Y_up{index} = YX{index-1};
Q0{index} = mean(C5flow)/2; % Average flow
Q{index} = [Qmax{index},Qmin{index},Q0{index}];

index = 4;
%Link C4:
Qmax{index} = max(abs(C4flow)); %Maximum flow working around
Qmin{index} = min(abs(C4flow))+0.1; %Minimum flow
X{index} = 200; %length
B{index} = 0.5;
m{index} = 1.5;
Sb{index} = 0.0006; %Bed slope
n{index} = 0.013; %Manning Coefficients
YX{index} = linear_factor*max(C4downlevel); % Downstream water depth
Y_up{index} = 0;
Q0{index} = mean(C5flow)/2; % Average flow
Q{index} = [Qmax{index},Qmin{index},Q0{index}];

index = 5;
%Link C5:
Qmax{index} = max(abs(C5flow)); %Maximum flow working around
Qmin{index} = min(abs(C5flow))+0.1; %Minimum flow
X{index} = 800; %length
B{index} = 2;
m{index} = 1.5;
Sb{index} = 0.00015; %Bed slope
n{index} = 0.013; %Manning Coefficients
YX{index} = linear_factor*max(C5downlevel); % Downstream water depth
Y_up{index} = YX{index-1};
Q0{index} = mean(C5flow); % Average flow
Q{index} = [Qmax{index},Qmin{index},Q0{index}];

% 
% flow_factor = 0.5;
% Q0{1} = mean(C1flow); 
% Q0{2} = mean(C2flow);
% Q0{3} = mean(C3flow);
% Q0{4} = mean(C4flow);
% Q0{5} = mean(C5flow);
% Y_up{3} = 0;
% Y_up{5} = 0;


C1 = link('trapezoid',{X{1},n{1},Sb{1},Q{1},YX{1},Y_up{1},[B{1},m{1}]});
C2 = link('trapezoid',{X{2},n{2},Sb{2},Q{1},YX{2},Y_up{2},[B{2},m{2}]});
C3 = link('trapezoid',{X{3},n{3},Sb{3},Q{1},YX{3},Y_up{3},[B{3},m{3}]});
C4 = link('trapezoid',{X{4},n{4},Sb{4},Q{1},YX{4},Y_up{4},[B{4},m{4}]});
C5 = link('trapezoid',{X{5},n{5},Sb{5},Q{1},YX{5},Y_up{5},[B{5},m{5}]});

C1_model = model_link({C1.p11},C1.p12,{C1.p21},C1.p22);
C2_model = model_link({C2.p11},C2.p12,{C2.p21},C2.p22);
C3_model = model_link({C3.p11},C3.p12,{C3.p21},C3.p22);
C4_model = model_link({C4.p11},C4.p12,{C4.p21},C4.p22);
C5_model = model_link({C5.p11},C5.p12,{C5.p21},C5.p22);

C123_model = advanced_link_merging({C1_model,C2_model,C3});
C_model = advanced_link_merging({C123_model,C4_model,C5});


Cd = 0.65;
A0 = 2*0.5;
g = 9.81;
Yfull = 0.5;
Z0 = 0;
OR = [Cd,A0,g,Yfull,Z0];

% The orifice closes at 06:00, reopens at 13:00 (simulation starts at
% 00:00). Takes timestep of 5s, first period is 
% W = ones(1,(6*60*60)/time_step);
% W = [W, zeros(1,(7*60*60)/time_step)];
% W = [W, ones(1,(11*60*60)/time_step)];
% W = zeros(1,(13*60*60)/time_step);
% W = [W, ones(1,(11*60*60)/time_step)];

% The orifice has 10% open at 00:00, fully open at 15:00 (simulation starts at
% 00:00). Takes timestep of 5s, first period is 
% W = 0*ones(1,(15*60*60)/time_step);
% W = [W, ones(1,(9*60*60)/time_step)];

W = zeros(1,(2*60*60)/time_step);
W = [W, ones(1,(22*60*60)/time_step)];

% The orifice is closed at first, and close/open periodically every 1 hour
% W = [];
% for i = 1:1:12
%     W = [W, 0*ones(1,(1*60*60)/time_step)];
%     W = [W, 1*ones(1,(1*60*60)/time_step)];
% end

% W = ORflow;
% W = ceil(W/100);


inflows = {J1inflow,J2inflow,J3inflow,J4inflow,J5inflow};
inflows = delay_inflow_ds(inflows,C_model,time_step);
[Y_wz,outflow_wz] = ds_capital_nonlinear_1o_wo_simulation(inflows,C_model,OR,W,1,time_step,N);

[Y_nwz,outflow_nwz] = ds_capital_nonlinear_1o_wo_simulation(inflows,C_model,OR,W,0,time_step,N);

print_model_link_parameters(C1_model,'C1')
print_model_link_parameters(C2_model,'C2')
print_model_link_parameters(C3_model,'C3')
print_model_link_parameters(C4_model,'C4')
print_model_link_parameters(C5_model,'C5')
print_model_link_parameters(C_model,'C')


%% Plot the results

figure('Renderer', 'painters');
my_figure_2 = tiledlayout(1,2);
sgtitle('Depth and Outflow at the Downstream of Merging Conduits','interpreter','latex','fontsize',15);
set(gcf, 'Position',  [100, 0, 1200, 500])

nexttile;
plot(hours,SUlevel,'color',"#77AC30");
hold on;
plot(hours,Y_nwz,'LineStyle',':','color',"#D95319");
plot(hours,Y_wz,'color',	"#7E2F8E",'LineStyle','-.');
grid on;
ylabel('Water Depth (m)','interpreter','latex');
xlabel('Time(hh:mm)','interpreter','latex')
% legend('With Zero','Without Zero','PCSWMM Simulation','interpreter','latex','Location','northeast');
title('Downstream Level $Y^5(X,t)$','interpreter','latex');
start_time = hours((0.1*60*60)/time_step);
start_time.Format = 'hh:mm';
end_time = hours((6*60*60)/time_step);
end_time.Format = 'hh:mm';
xlim([start_time end_time]);
ylim([0,inf]);

nexttile;
plot(hours,ORflow,'color',"#77AC30");
hold on;
plot(hours,outflow_nwz,'LineStyle',':','color',"#D95319");
plot(hours,outflow_wz,'color',	"#7E2F8E",'LineStyle','-.');
grid on;
ylabel('Water Depth (m)','interpreter','latex');
xlabel('Time(hh:mm)','interpreter','latex')
legend('PCSWMM Simulation','Without Zero','With Zero','interpreter','latex','Location','northeast');
title('Downstream Outflow $Q^5(X,t)$','interpreter','latex');
start_time = hours((0.1*60*60)/time_step);
start_time.Format = 'hh:mm';
end_time = hours((6*60*60)/time_step);
end_time.Format = 'hh:mm';
xlim([start_time end_time]);
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




