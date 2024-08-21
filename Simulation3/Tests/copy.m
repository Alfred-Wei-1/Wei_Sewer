n = length(inflows) - 2;
% Obtain system
yd = [];
for i = 1:1:n
    yd = [yd, conduit.p2k{i}];
end
yd = [yd, conduit.p2n];
yd_ds = c2d(yd,time_step);
temp = ss(yd_ds);
taud = temp.InputDelay;
[taud_ordered,order_index] = sort(taud);

%% Start Simulation

% Initialize variables
for i = 1:1:n
    Q_k{i} = inflows{i};
end

Y_X = nan(1,N);
x = nan(1,N);
our_inflow = nan(n+2,N);

% Initialize the system at time 1
Y_X(1) = 0;

temp = cell(1,n+2);
for i = 1:1:n
        temp{i} = 0;
end
temp{n+1} = inflows{n+1}(1);
temp{n+2} = inflows{n+2}(1);
temp = cell2mat(temp);
our_inflow(:,1) = temp;
x(1) = 0;

% Simulate system after time 1
for t = 2:1:N
    % Determine flow by incorporating delay
    
    my_case = my_t_case(taud_ordered,t);
    t_array = 1:1:my_case;
    choose = order_index(t_array);

    temp = cell(1,n+2);
    for i = 1:1:n
        if ismember(i,choose)
            inflow = Q_k{i};
            temp{i} = inflow(t - taud(i));
        else
                temp{i} = 0;
        end
    end
    temp{n+1} = inflows{n+1}(1);
    temp{n+2} = inflows{n+2}(1);
    temp = cell2mat(temp);
    our_inflow(:,t) = temp;
   

    % Update state and output
    x(t) = A*x(t-1)+E*our_inflow(:,t-1);
    Y_X(t) = C*x(t) + F*our_inflow(:,t);
end

Y_downstream = Y_X;