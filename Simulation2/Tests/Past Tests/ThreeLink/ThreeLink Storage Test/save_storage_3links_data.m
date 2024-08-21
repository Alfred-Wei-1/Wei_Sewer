function output = save_storage_3links_data(J1inflow,J2level,J3level,SUlevel)
J1inflow = cell2mat(J1inflow);
J2level = cell2mat(J2level);
J3level = cell2mat(J3level);
SUlevel = cell2mat(SUlevel);
save('hurricane_dw.mat',"J1inflow", "J2level","J3level","SUlevel");

output = 1;
end

