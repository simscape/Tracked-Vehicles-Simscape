%% Tracked Vehicle Documentation, Roller for Belt Track
% 
% Documentation for parameters of roller used on belted track, which
% includes two rollers rigidly connected to an axle.
%
% Copyright 2023-2025 The MathWorks, Inc.

%% Idler Model
%
% Model

load_system('sm_trackV_lib_belt_underc_elem');
open_system('sm_trackV_lib_belt_underc_elem/Roller Lower Rubber Track Planar','force');

%% Reference Frames
%
% <<sm_tracked_vehicle_doc_beltRoller_dims.png>>

%% Parameters, Roller.Lower
%
% |Trac.Roller.Lower| 
Trac.Roller.Lower

%% Parameters, Roller.Lower.Axle
% |Trac.Roller.Lower.Axle| 
Trac.Roller.Lower.Axle

%%
close all
bdclose all
