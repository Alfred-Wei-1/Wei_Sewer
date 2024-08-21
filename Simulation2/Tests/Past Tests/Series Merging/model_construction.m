clear;
clc;

%% Read Data
load('hurricane_dw.mat');
N = length(J1inflow);
time_step = 5;
time = 0:time_step:N*time_step-time_step;

%% Define parameters

linear_factor = 0.58;

index = 1;
%Link C11: J11-J12
Qmax{index} = max(abs(C11flow)); %Maximum flow working around
Qmin{index} = min(abs(C11flow)) + 10; %Minimum flow
X{index} = 6000; %length
m{index} = 1.5; %trapezoid side slope
B{index} = 8; %trapezoid bottom lenth
Sb{index} = 0.0008; %Bed slope
n{index} = 0.02; %Manning Coefficients
YX{index} = linear_factor*max(C11downlevel); % Downstream water depth
Q0{index} = 0.4*max(abs(C11flow)); % Average flow
Q{index} = [Qmax{index},Qmin{index},Q0{index}];

index = 2;
%Link C12: J12-J13
Qmax{index} = max(abs(C12flow)); %Maximum flow working around
Qmin{index} = min(abs(C12flow)) + 10; %Minimum flow
X{index} = 6000; %length
m{index} = 1.5; %trapezoid side slope
B{index} = 8; %trapezoid bottom lenth
Sb{index} = 0.00083; %Bed slope
n{index} = 0.02; %Manning Coefficients
YX{index} = linear_factor*max(C12downlevel); % Downstream water depth
Q0{index} = 0.35*max(abs(C12flow)); % Average flow
Q{index} = [Qmax{index},Qmin{index},Q0{index}];

index = 3;
%Link C13: J13-J1
Qmax{index} = max(abs(C13flow)); %Maximum flow working around
Qmin{index} = min(abs(C13flow)) + 10; %Minimum flow
X{index} = 6000; %length
m{index} = 1.5; %trapezoid side slope
B{index} = 8; %trapezoid bottom lenth
Sb{index} = 0.00067; %Bed slope
n{index} = 0.02; %Manning Coefficients
YX{index} = linear_factor*max(C13downlevel); % Downstream water depth
Q0{index} = 0.5*max(abs(C13flow)); % Average flow
Q{index} = [Qmax{index},Qmin{index},Q0{index}];

index = 4;
%Link C21: J21-J22
Qmax{index} = max(abs(C21flow)); %Maximum flow working around
Qmin{index} = min(abs(C21flow)) + 10; %Minimum flow
X{index} = 6000; %length
m{index} = 1.5; %trapezoid side slope
B{index} = 8; %trapezoid bottom lenth
Sb{index} = 0.0008; %Bed slope
n{index} = 0.02; %Manning Coefficients
YX{index} = linear_factor*max(C21downlevel); % Downstream water depth
Q0{index} = 0.5*max(abs(C21flow)); % Average flow
Q{index} = [Qmax{index},Qmin{index},Q0{index}];

index = 5;
%Link C22: J22-J23
Qmax{index} = max(abs(C22flow)); %Maximum flow working around
Qmin{index} = min(abs(C22flow)) + 10; %Minimum flow
X{index} = 2000; %length
m{index} = 1.5; %trapezoid side slope
B{index} = 8; %trapezoid bottom lenth
Sb{index} = 0.0025; %Bed slope
n{index} = 0.02; %Manning Coefficients
YX{index} = linear_factor*max(C22downlevel); % Downstream water depth
Q0{index} = 0.5*max(abs(C22flow)); % Average flow
Q{index} = [Qmax{index},Qmin{index},Q0{index}];

index = 6;
%Link C23: J23-J2
Qmax{index} = max(abs(C23flow)); %Maximum flow working around
Qmin{index} = min(abs(C23flow)) + 10; %Minimum flow
X{index} = 6000; %length
m{index} = 1.5; %trapezoid side slope
B{index} = 8; %trapezoid bottom lenth
Sb{index} = 0.0005; %Bed slope
n{index} = 0.02; %Manning Coefficients
YX{index} = linear_factor*max(C23downlevel); % Downstream water depth
Q0{index} = 0.5*max(abs(C23flow)); % Average flow
Q{index} = [Qmax{index},Qmin{index},Q0{index}];

index = 7;
%Link C31: J31-J32
Qmax{index} = max(abs(C31flow)); %Maximum flow working around
Qmin{index} = min(abs(C31flow)) + 10; %Minimum flow
X{index} = 6000; %length
m{index} = 1.5; %trapezoid side slope
B{index} = 8; %trapezoid bottom lenth
Sb{index} = 0.0008; %Bed slope
n{index} = 0.02; %Manning Coefficients
YX{index} = linear_factor*max(C31downlevel); % Downstream water depth
Q0{index} = 0.5*max(abs(C31flow)); % Average flow
Q{index} = [Qmax{index},Qmin{index},Q0{index}];

index = 8;
%Link C32: J32-J33
Qmax{index} = max(abs(C32flow)); %Maximum flow working around
Qmin{index} = min(abs(C32flow)) + 10; %Minimum flow
X{index} = 2000; %length
m{index} = 1.5; %trapezoid side slope
B{index} = 8; %trapezoid bottom lenth
Sb{index} = 0.0025; %Bed slope
n{index} = 0.02; %Manning Coefficients
YX{index} = linear_factor*max(C32downlevel); % Downstream water depth
Q0{index} = 0.5*max(abs(C32flow)); % Average flow
Q{index} = [Qmax{index},Qmin{index},Q0{index}];

index = 9;
%Link C33: J33-J2
Qmax{index} = max(abs(C33flow)); %Maximum flow working around
Qmin{index} = min(abs(C33flow)) + 10; %Minimum flow
X{index} = 6000; %length
m{index} = 1.5; %trapezoid side slope
B{index} = 8; %trapezoid bottom lenth
Sb{index} = 0.0005; %Bed slope
n{index} = 0.02; %Manning Coefficients
YX{index} = linear_factor*max(C33downlevel); % Downstream water depth
Q0{index} = 0.5*max(abs(C33flow)); % Average flow
Q{index} = [Qmax{index},Qmin{index},Q0{index}];

index = 10;
%Link C1: J2-J1
Qmax{index} = max(abs(C1flow)); %Maximum flow working around
Qmin{index} = min(abs(C1flow)) + 10; %Minimum flow
X{index} = 6000; %length
m{index} = 1.5; %trapezoid side slope
B{index} = 12; %trapezoid bottom lenth
Sb{index} = 0.00017; %Bed slope
n{index} = 0.02; %Manning Coefficients
YX{index} = linear_factor*max(C1downlevel); % Downstream water depth
Q0{index} = 0.5*max(abs(C1flow)); % Average flow
Q{index} = [Qmax{index},Qmin{index},Q0{index}];

index = 11;
%Link C2: J1-SU
Qmax{index} = max(abs(C2flow)); %Maximum flow working around
Qmin{index} = min(abs(C2flow)) + 10; %Minimum flow
X{index} = 6000; %length
m{index} = 1.5; %trapezoid side slope
B{index} = 16; %trapezoid bottom lenth
Sb{index} = 0.00033; %Bed slope
n{index} = 0.02; %Manning Coefficients
YX{index} = linear_factor*max(C2downlevel); % Downstream water depth
Q0{index} = 0.5*max(abs(C2flow)); % Average flow
Q{index} = [Qmax{index},Qmin{index},Q0{index}];


%% Compute Parameters
C11 = link('trapezoid',{X{1},n{1},Sb{1},Q{1},YX{1},[B{1},m{1}]});
disp('C11 is done');
C12 = link('trapezoid',{X{2},n{2},Sb{2},Q{2},YX{2},[B{2},m{2}]});
disp('C12 is done');
C13 = link('trapezoid',{X{3},n{3},Sb{3},Q{3},YX{3},[B{3},m{3}]});
disp('C13 is done');
C21 = link('trapezoid',{X{4},n{4},Sb{4},Q{4},YX{4},[B{4},m{4}]});
disp('C21 is done');
C22 = link('trapezoid',{X{5},n{5},Sb{5},Q{5},YX{5},[B{5},m{5}]});
disp('C22 is done');
C23 = link('trapezoid',{X{6},n{6},Sb{6},Q{6},YX{6},[B{6},m{6}]});
disp('C23 is done');
C31 = link('trapezoid',{X{7},n{7},Sb{7},Q{7},YX{7},[B{7},m{7}]});
disp('C31 is done');
C32 = link('trapezoid',{X{8},n{8},Sb{8},Q{8},YX{8},[B{8},m{8}]});
disp('C32 is done');
C33 = link('trapezoid',{X{9},n{9},Sb{9},Q{9},YX{9},[B{9},m{9}]});
disp('C33 is done');
C1 = link('trapezoid',{X{10},n{10},Sb{10},Q{10},YX{10},[B{10},m{10}]});
disp('C1 is done');
C2 = link('trapezoid',{X{11},n{11},Sb{11},Q{11},YX{11},[B{11},m{11}]});
disp('C2 is done');

C_branch1 = link_cascade({C11,C12,C13});
C_branch2 = link_cascade({C21,C22,C23});
C_branch3 = link_cascade({C31,C32,C33});

C_branch23 = elementary_link_merging(C_branch2,C_branch3,C1);

C = model_link_merging(C_branch1,C_branch23,C2);

yd = [C.p_up{1},C.p_up{2},C.p_up{3},C.p_down];
yd_ds = c2d(yd,time_step);

%% Construct transfer functions for upstream


%% Simulation
% q1 = J1inflow;
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








