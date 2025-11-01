%% Tracked Vehicle Documentation, Idler for Belt Track
% 
% Documentation for parameters of idler used on belted track, which
% includes wheel, rim, and axle
%
% Copyright 2023-2025 The MathWorks, Inc.

%% Idler Model
%
% Model

load_system('sm_trackV_lib_belt_underc_elem');
open_system('sm_trackV_lib_belt_underc_elem/Idler Rubber Track Planar','force');

%% Reference Frames
%
% <<sm_tracked_vehicle_doc_beltIdler_dims.png>>

%% Parameters, IdlerF / IdlerR
%
% |Trac.IdlerF| 
Trac.IdlerF

%% Parameters, IdlerF.Rim
% |Trac.IdlerF.Rim| 
Trac.IdlerF.Rim

%% Parameters, IdlerF.Rim.rim_xc
% |IdlerF.Rim.rim_xc = Extr_Data_Idler_Rim(IdlerF.Rim.rad, idler_hub_rad, idler_lip_rad, IdlerF.len);| 
Extr_Data_Idler_Rim


%%
close all
bdclose all
