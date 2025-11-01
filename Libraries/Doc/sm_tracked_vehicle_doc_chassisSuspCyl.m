%% Tracked Vehicle Documentation, Chassis Suspension Cylinder
% 
% Documentation for parameters of chassis suspension cylinder.
%
% Copyright 2023-2025 The MathWorks, Inc.

%% Chain Shoe Assembly
%
% Model

load_system('sm_trackV_lib_chain_underc_elem');
open_system('sm_trackV_lib_chain_underc_elem/Suspension Cylinder','force');

%% Reference Diagram
%
% <<sm_tracked_vehicle_doc_chassisSuspCyl_param.png>>

%% Parameters, Chassis Suspension
%

Excv.Chassis.Susp.Cylinder

%% Parameters, Chassis Suspension Piston
%
Excv.Chassis.Susp.Cylinder.Piston

%% Parameters, Chassis Suspension Cylinder
%
Excv.Chassis.Susp.Cylinder.Cylinder

%%
close all
bdclose all
