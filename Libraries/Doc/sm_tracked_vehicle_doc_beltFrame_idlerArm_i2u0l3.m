%% Tracked Vehicle Documentation, Frame for Belt Track 
% 
% Documentation for parameters of frame used on belted track.  This frame
% has two idlers, 0 upper rollers, 3 lower rollers, and an idler arm to
% tension the belt.
%
% Copyright 2023-2024 The MathWorks, Inc.

%% Test Model for Undercarriage
%
% This test model shows the undercarriage, including sprocket, idlers,
% idler arm, and rollers.
%
% <matlab:open_system('sm_tVtest_belt_IdlerArm_i2u0r3_underc'); Open Model>

open_system('sm_tVtest_belt_IdlerArm_i2u0r3_underc');

%%
set_param('sm_tVtest_belt_IdlerArm_i2u0r3_underc/Undercarriage','LinkStatus','none');
open_system('sm_tVtest_belt_IdlerArm_i2u0r3_underc/Undercarriage','force');

%%
set_param('sm_tVtest_belt_IdlerArm_i2u0r3_underc/Undercarriage/Frame','LinkStatus','none');
open_system('sm_tVtest_belt_IdlerArm_i2u0r3_underc/Undercarriage/Frame','force');

Trac = sm_trackV_belt_param_machine_seg45i2u0r3_IdlerArm;

%% Diagram
%
% <<sm_tracked_vehicle_doc_beltFrame_IdlerArm_i2u0r3_dims.png>>

%% Parameters, Undercarriage Offsets
%
% Offsets for undercarriage elements are defined with respect to the center
% of the sprocket.  They are grouped into longitudinal (in the direction
% of travel), and vertical.
%
% Longitudinal offsets are in field SprkOffLon
%
% |Trac.Frame.SprkOffLon| 
Trac.Frame.SprkOffLon

%% 
%
% Vertical offsets are in field SprkOffVer
%
% |Trac.Frame.SprkOffVer| 
Trac.Frame.SprkOffVer

%% Parameters, Undercarriage Frames
%
% Inertia for the two portions of the frame of the undercarriage are
% modeled.  Mass, center of mass, and moments of inertia can be specified
% for the frame that holds the sprocket and the lower frame which holds the
% rollers, fixed idler, tensioner, and idler arm
%
% Parameters for the frame that holds the sprocket are in field "SprkFrame"
%
% |Trac.Frame.SprkFrame| 
Trac.Frame.SprkFrame

%%
%
% Parameters for the frame that holds the other components are in field "TrackFrame"
%
% |Trac.Frame.TrackFrame| 
Trac.Frame.TrackFrame


%%
close all
bdclose all
