% Simulate the system in a discrete fashion
time_step = 5;
yd = [-canal.Yn];
h = [-canal.Yn];
qu = J1inflow-canal.Q0;
% qd = [-canal.Q0 -canal.Q0]; %Second 0 comes from manning's equation given yd(0)
qd = [0,0];

min_delay_index = floor(taud/time_step);

for t = 1:1:N
    if t <= min_delay_index
        h = [h,h(t)-(time_step/Ad)*qd(t)]; %Compute h(t+1)
        yd = [yd,h(t+1)-p22_inf*qd(t+1)];
%         yd = [yd,h(t+1)];
%         flow = 1/(canal.n)*canal.A(yd(t+1)+canal.Yn)*((canal.R(yd(t+1)+canal.Yn))^(2/3))*sqrt(canal.Sb);
        flow = 8*(yd(t+1)+canal.Yn);
        qd = [qd,flow-canal.Q0];
    else
        h = [h,h(t)+(time_step/Ad)*qu(t-floor(taud/time_step))-(time_step/Ad)*qd(t)];
        yd = [yd,h(t+1)+p21_inf*qu(t+1-floor(taud/time_step))-p22_inf*qd(t+1)];
%         yd = [yd,h(t+1)];
%         flow = 1/(canal.n)*canal.A(yd(t+1)+canal.Yn)*((canal.R(yd(t+1)+canal.Yn))^(2/3))*sqrt(canal.Sb);
        flow = 8*(yd(t+1)+canal.Yn);
        qd = [qd,flow-canal.Q0];
    end
end

%Recover the total quantity
yd = yd(2:end);
Yd = yd + canal.Yn*ones(1,N);

time = linspace(0,N,N);

figure;
plot(time,Yd)
hold on;
plot(time,J2level)
plot(time,0.2.*J1inflow);
title('Downstream Water Level')
legend('Model','Actual','Scaled-Rainfall');
% legend('Model','Actual');

figure;
qd = qd(3:end);
plot(time,J2outflow);
hold on;
plot(time,qd+canal.Q0*ones(1,N));
title('Downstream outflow');
legend('Actual','Model');

a=3;