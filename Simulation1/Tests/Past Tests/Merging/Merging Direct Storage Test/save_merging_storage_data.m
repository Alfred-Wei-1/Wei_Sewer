function output = save_merging_storage_data(J1inflow,J2inflow,Merglevel)
J1inflow = cell2mat(J1inflow);
J2inflow = cell2mat(J2inflow);
Merglevel = cell2mat(Merglevel);
save('hurricane_dw.mat',"J1inflow","J2inflow","Merglevel");

output = 1;
end



