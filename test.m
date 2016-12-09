clear all; close all;
addpath(genpath(pwd));

%% INP TO GIS
inpname = 'Net1.inp';
d=epanet(inpname,'bin','LoadFile');
inp2gis_main(d,inpname)
[~,foldername]=fileparts(inpname);
winopen(foldername);

%% GIS TO INP
newInpname = [foldername,'_gis2inp.inp'];
gis2inp_main(newInpname,foldername);
winopen(newInpname);
