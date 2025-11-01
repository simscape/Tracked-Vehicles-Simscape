%% Tracked Vehicle Documentation, Belt Segment
% 
% Documentation for parameters of belt segment, which includes carcass and lug.
%
% Copyright 2024-2025 The MathWorks, Inc.

%% Chain Shoe Assembly
%
% Model

load_system('sm_trackV_lib_belt_segment');
open_system('sm_trackV_lib_belt_segment/Track Segment Belt Planar','force');

%% Reference Frames
%
% <<sm_tracked_vehicle_doc_beltSegment_refFrames_dims.png>>

%% Parameters, Belt
%
% |Trac.Belt| 
Trac.Belt

%% Parameters, Lug
%
% |Trac.Belt.Lug| 
Trac.Belt.Lug

%%
close all
bdclose all
