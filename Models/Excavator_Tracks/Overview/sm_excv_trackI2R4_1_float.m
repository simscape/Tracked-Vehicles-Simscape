%% Excavator Track (Single, Two Idler) Suspended in Air
% 
% <<sm_excv_trackI2R4_1_float_Overview.png>>
%
% (<matlab:web('Tracked_Vehicle_Simscape_Overview.html') return to Tracked Vehicle Model with Simscape Overview>)
%
% This example models a single track from an excavator. The track is
% suspended in the air and has no contact with the ground. This test
% harness model enables faster testing of track segment layout and contact
% force parameters within the track. The sprocket is driven with a flexible
% driveshaft.
%
% Copyright 2023-2024 The MathWorks, Inc.

%% Model
%
% In this example, one track is modeled and half of the excavator mass is
% centered on the track.  This enables faster adjustments of the track
% model which can then be mirrored to the second track.
%
% <matlab:open_system('sm_excv_trackI2R4_1_float'); Open Model>


open_system('sm_excv_trackI2R4_1_float')

set_param(find_system('sm_excv_trackI2R4_1_float','FindAll', 'on','type','annotation','Tag','ModelFeatures'),'Interpreter','off')

%% Track Subsystem
%
% The track is composed of the undercarriage and the track segments
% connected into a loop.  The undercarriage contains the rollers, sprocket,
% and idler which are rigidly attached to the frame.  These are connected
% to the track chain through three sets of contact forces. 
% 
% 1. The chain wraps around the idler
%
% <<sm_excv_contact_idlerToChain_Overview.png>>
%
% 2. The rollers roll along the chains
%
% <<sm_excv_contact_rollerUToChain_Overview.png>>
%
% 3. The chain pins mesh with the sprocket teeth
%
% <<sm_excv_contact_sprocketToChain_Overview.png>>
%
% The Planar Track joint positions one of the chain pins at a gap between
% the sprocket teeth which is positioned facing the rear of the track.
% Joint targets applied to the track segments helps it to mesh with other
% teeth on the sprocket and loosely wrap around the rollers and idler. The
% block Transform Half Seg Angle orients the interface frame so that the
% two chain segments attached to that pin will wrap around the sprocket. 
%
% <matlab:open_system('sm_excv_trackI2R4_1_float');open_system('sm_excv_trackI2R4_1_float/Track%20L','force'); Open Subsystem>

set_param('sm_excv_trackI2R4_1_float/Track L','LinkStatus','none')
open_system('sm_excv_trackI2R4_1_float/Track L','force')

%% Rollers Subsystem
%
% This subsystem models the rollers, idler, and sprocket.  They each can
% rotate around shafts attached to the lower frame. A spring is included in
% the Prismatic Tensioner joint that pushes the idler against the chain to
% maintain tension. 
%
% The sprocket joint interfaces to 1D mechanical rotational port.  This
% represents a mechanical shaft connection to the sprocket. It can be
% attached to Simscape models of gears, hydrostatic transmissions, and
% electric motors.
%
% The bus of connections at port R contains the connections to the geometry
% that is used to model contact between the rollers, idler, and sprocket to
% the chain.
%
% <matlab:open_system('sm_excv_trackI2R4_1_float');open_system('sm_excv_trackI2R4_1_float/Track%20L/Undercarriage/Rollers','force'); Open Subsystem>

set_param('sm_excv_trackI2R4_1_float/Track L/Undercarriage','LinkStatus','none')
set_param('sm_excv_trackI2R4_1_float/Track L/Undercarriage/Rollers','LinkStatus','none')
open_system('sm_excv_trackI2R4_1_float/Track L/Undercarriage/Rollers','force')

%% Track Subsystem
%
% A set of track segments are joined using Revolute Joints to model the
% track. The joints are contained in each segment. Joint targets are
% assigned in the mask to ensure the track meshes with the sprocket and
% wraps loosely around the rollers and idler.
%
% <matlab:open_system('sm_excv_trackI2R4_1_float');open_system('sm_excv_trackI2R4_1_float/Track%20L/Track','force'); Open Subsystem>

set_param('sm_excv_trackI2R4_1_float/Track L/Track','LinkStatus','none')
open_system('sm_excv_trackI2R4_1_float/Track L/Track','force')

%% Track Segment Subsystem
%
% Each track segment is composed of a chain link and a shoe. To streamline
% the contact force calculation, simpler geometry is connected to the
% Spatial Contact Force block.  
%
% # A sphere is used to model the pin contacting the sprocket.
% # A brick is used to model the chain contacting the rollers and idler.
% # A point cloud is used to model the shoe plate contacting the ground
% (for this model, no contact with the ground is modeled).
%
% <<sm_excv_contact_trackSeg_PtcldAll_Overview.png>>
%
% <matlab:open_system('sm_excv_trackI2R4_1_float');open_system('sm_excv_trackI2R4_1_float/Track%20L/Track/Seg%2001','force'); Open Subsystem>

set_param('sm_excv_trackI2R4_1_float/Track L/Track/Seg 01','LinkStatus','none')
open_system('sm_excv_trackI2R4_1_float/Track L/Track/Seg 01','force')

%% Simulation Results
%%
%
% Below are the simulation results from a test where the sprocket is driven
% as the track is suspended in the air.  To help keep the track taut around
% the rollers, gravity is applied from the idler to the grouser.
%

ExcvI2R4.Shoe.ptcld.pts = ExcvI2R4.Shoe.ptcld_sets.plate;
sim('sm_excv_trackI2R4_1_float');

sm_excv_track_plot2trq(simlog_sm_excv_trackI2R4_1_float);

%%

close all
bdclose('sm_excv_trackI2R4_1_float');
