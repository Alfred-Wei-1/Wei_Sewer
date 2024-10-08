%%% This function takes in: inflows, inflow_prop, model_link, and orifice data
%%% and outputs: the downstream water depth.

%%% The name "capital" means: it uses the equivalent initialization.
%%% 'ds' means the output is downstream water depth
%%% 'nonlinear' means the feedback function is nonlinear
%%% '1o' means there is only a side orifice

%%% 'inflow_prop' determines whether the corresponding inflow takes
%%% lower-letter (i.e., does it come in the middle or at the top). 0 means
%%% inflow at interconnection, 1 means inflow at most upstreams.

%%% wo means this function considers the setting of the orifice.

%%% Aside from outputting the downstream depth, this function also returns
%%% the flows out of the two orifices.

function [Y_downstream,OR_outflow] = ds_capital_nonlinear_1o_wo_simulation(inflows,C,OR,W,withzero,time_step,N)
n = length(inflows);
conduit = C;

% Obtain A,B,C,D matrices
yd = [];
for i = 1:1:n
    yd = [yd, C.p2k{i}];
end
yd = [yd, C.p2n];
yd_ds = c2d(yd,time_step);
temp = ss(yd_ds);
A = temp.A;
B = temp.B;
C = temp.C;
if withzero == 0
    D = zeros(1,length(conduit.p2k)+1);
else
    D = temp.D;
end
% A = 1;
% B = time_step*(1/C.Ad)*ones(1,length(C.p2k));
% B = [B, -(1/C.Ad)*time_step];
% C = 1;
% if withzero == 0
%     D = zeros(1,length(conduit.p2k)+1);
% else
%     D = [];
%     for i = 1:1:length(conduit.p2k)
%         D = [D,conduit.p2k_inf{i}];
%     end
%     D = [D,-conduit.p2n_inf];
% end
taud = temp.InputDelay;
taud = taud(1:end-1);

% Set inflows, note the inflows are function handles
time = 0:time_step:N*time_step-time_step;
simu_input = [time'];
for i = 1:1:length(inflows)
    simu_input = [simu_input, inflows{i}'];
end
W = [time',W'];

save('Simulation/ds_capital_nonlinear_1o_wo_simulation/ds_capital_nonlinear_1o_wo_simulation_data.mat');

% Simulate System
simu_file = 'ds_capital_nonlinear_1o_wo_simulation_simu';
simIn = Simulink.SimulationInput(simu_file);
simIn = loadVariablesFromMATFile(simIn,"ds_capital_nonlinear_1o_wo_simulation_data.mat");
warning('off');
out = sim(simIn);
clc;

Y_downstream = out.YX.data(1:end-1);
OR_outflow = out.ORflow.data(1:end-1);

end