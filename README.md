# Chuanning Wei's Master Thesis Matlab Code
I introduce the parts associated to the Matlab Code. In this work, we use PCSWMM, a simulation software designed for hydraulic systems, for the numerical analysis. Moreover, we also use Pyswmm, an open-source python interface, to read data from PCSWMM files.

The PCSWMM file is contained in `SWMM File/~`, where ~ is either cascade, merge, or system. The python script `pyswmm_interface` is responsible for reading data from the PCSWMM file. To read the data, open Matlab and type the command `matlab.engine.shareEngine` and run the python script, and then all the data are saved in `hurricane_dw.mat` via the Matlab function `save_system_data.m`.

Once the data becomes avaliable, the file `main.m` starts system modelling and simulation. Simply follow the code there and you will realize the code is divided into two parts: IDZ model identification and its simulation. 

The folder `Identification` saves all functions related to IDZ model identifications, and the folder `Simulation` saves all functions related to IDZ model simulation. Each individual conduit can be constructed as a class `link` as saved in `Identification/@link` and each equivalent conduit can be constructed as a class `model_link` as saved in `Identification/@model_link`.
