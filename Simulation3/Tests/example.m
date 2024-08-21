clear;
clc;

A = 0;
B = [1 -1];
C = 1;
D = [1 -1];
constant = 3;
plant = ss(A,B,C,D);
gain = ss(0,0,0,constant);

plant.InputName = {'u1','u2'};
plant.OutputName = 'y';
gain.InputName = 'y';
gain.OutputName = 'u2';

sys = connect(plant,gain,'u1','y')