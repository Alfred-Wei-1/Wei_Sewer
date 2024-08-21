function output = save_storage_onelink_data(J1inflow,SU1level)
J1inflow = cell2mat(J1inflow);
SU1level = cell2mat(SU1level);

save('hurricane_dw.mat',"J1inflow", "SU1level");

output = 1;
end



