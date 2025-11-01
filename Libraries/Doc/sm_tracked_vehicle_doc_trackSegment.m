%% Tracked Vehicle Documentation, Track Segment
% 
% Documentation for parameters of track segment, which includes chain link
% and shoe.
%
% Copyright 2023-2025 The MathWorks, Inc.

%% Chain Shoe Assembly
%
% Model

load_system('sm_trackV_lib_chain_segment');
open_system('sm_trackV_lib_chain_segment/Track Segment Shoe Point Cloud Contact','force');

%% Reference Frames
%
% <<sm_tracked_vehicle_doc_trackSegment_refFrames.png>>

%% Parameters, Chain
%

Excv.Chain

%% Chain Plate
% <<sm_tracked_vehicle_doc_trackSegment_chainPlate.png>>

%% Chain Segments
% <<sm_tracked_vehicle_doc_trackSegment_chainSegments.png>>

%% Chain Plate Angle
% <<sm_tracked_vehicle_doc_trackSegment_chainPlateAngle.png>>

%% Shoe, Side View
% <<sm_tracked_vehicle_doc_trackSegment_shoeSide.png>>

%% Shoe, Ground Contact, Points
% <<sm_tracked_vehicle_doc_trackSegment_shoeGroundContactPts.png>>

%% Shoe, Point Sets, Plate
% <<sm_tracked_vehicle_doc_trackSegment_shoePointSetsPlate.png>>

%% Shoe, Point Sets, Grouser
% <<sm_tracked_vehicle_doc_trackSegment_shoePointSetsGrouser.png>>

%%
close all
bdclose all
