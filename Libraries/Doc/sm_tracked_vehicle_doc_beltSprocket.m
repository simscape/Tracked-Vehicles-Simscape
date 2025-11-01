%% Tracked Vehicle Documentation, Sprocket for Belt Track
% 
% Documentation for parameters of sprocket used on belted track, which
% includes spokes, rollers, and rim.
%
% Copyright 2023-2025 The MathWorks, Inc.

%% Sprocket Model
%
% Model

load_system('sm_trackV_lib_belt_underc_elem');
open_system('sm_trackV_lib_belt_underc_elem/Sprocket Planar t21','force');

%% Diagram 
%
% <<sm_tracked_vehicle_doc_beltSprocket_dims.png>>

%% Parameters, Sprocket.Roller
%
% |Trac.Sprocket.Roller| 
Trac.Sprocket.Roller

%% Parameters, Sprocket.Spoke
% |Trac.Sprocket.Spoke| 
Trac.Sprocket.Spoke

%% Parameters, Sprocket.Rim
% |Trac.Sprocket.Rim| 
Trac.Sprocket.Rim

%%
% |Sprocket.Rim.spoke_xc = Extr_Data_Sprocket_Spoke(Sprocket.nSpokes,
% Sprocket.Roller.rad, sproket_rim_ir, sproket_rim_hcr, sproket_rim_hr)|
Extr_Data_Sprocket_Spoke

%%
close all
bdclose all
