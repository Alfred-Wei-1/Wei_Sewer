# Chuanning Wei's Master Thesis Matlab Code
I introduce the parts associated to the Matlab Code. The PCSWMM file is contained in `SWMM File/~`, where ~ is either cascade, merge, or system. The python script `pyswmm_interface` is responsible for reading data from the SWMM file. To read the data, open Matlab and type the command `matlab.engine.shareEngine` and run the python script, and then all the data are saved in `hurricane_dw.mat` via the Matlab function `save_system_data.m`.

Once the data becomes avaliable, the file `main.m` starts system modelling and simulation. 
