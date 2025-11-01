%% Tracked Vehicle Documentation, Track Frame
% 
% Documentation for parameters of track frame, which includes offsets for
% interface frames for parts and mass properties.  Excludes track.
%
% Copyright 2023-2025 The MathWorks, Inc.

%% Chain Shoe Assembly
%
% Model

load_system('sm_trackV_lib_frame_i1u2l7');
open_system('sm_trackV_lib_frame_i1u2l7/Frame Up2 Down7','force');

%% Reference Frames
%
% <<sm_tracked_vehicle_doc_trackFrame_paramFrame.png>>

%% Parameters, Frame
%

Excv.Frame

%%
close all
bdclose('sm_trackV_frame_i1u2l7_lib')
