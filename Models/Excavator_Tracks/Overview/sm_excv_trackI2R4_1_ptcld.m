%% Excavator Track (Single), Ground Contact Point Cloud
% 
% <<sm_excv_trackI2R4_1_ptcld_terrain_Overview.png>>
%
% (<matlab:web('Tracked_Vehicle_Simscape_Overview.html') return to Tracked Vehicle Model with Simscape Overview>)
%
% This example models a single track from an excavator. Contact between the
% track and the ground is modeled using a point cloud on the track shoes.
% The track can be tested on uneven terrain, a slope, or a flat road with
% bumps. The sprocket is driven with a flexible driveshaft.
%
% Copyright 2023-2025 The MathWorks, Inc.

%% Model
%
% In this example, one track is modeled and half of the excavator mass is
% centered on the track.  This enables faster adjustments of the track
% model which can then be mirrored to the second track.
%
% <matlab:open_system('sm_excv_trackI2R4_1_ptcld'); Open Model>

open_system('sm_excv_trackI2R4_1_ptcld')

set_param(find_system('sm_excv_trackI2R4_1_ptcld','FindAll', 'on','type','annotation','Tag','ModelFeatures'),'Interpreter','off')

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
% <matlab:open_system('sm_excv_trackI2R4_1_ptcld');open_system('sm_excv_trackI2R4_1_ptcld/Track%20L','force'); Open Subsystem>

set_param('sm_excv_trackI2R4_1_ptcld/Track L','LinkStatus','none')
open_system('sm_excv_trackI2R4_1_ptcld/Track L','force')

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
% <matlab:open_system('sm_excv_trackI2R4_1_ptcld');open_system('sm_excv_trackI2R4_1_ptcld/Track%20L/Undercarriage/Rollers','force'); Open Subsystem>

set_param('sm_excv_trackI2R4_1_ptcld/Track L/Undercarriage','LinkStatus','none')
set_param('sm_excv_trackI2R4_1_ptcld/Track L/Undercarriage/Rollers','LinkStatus','none')
open_system('sm_excv_trackI2R4_1_ptcld/Track L/Undercarriage/Rollers','force')

%% Track Subsystem
%
% A set of track segments are joined using Revolute Joints to model the
% track. The joints are contained in each segment. Joint targets are
% assigned in the mask to ensure the track meshes with the sprocket and
% wraps loosely around the rollers and idler.
%
% <matlab:open_system('sm_excv_trackI2R4_1_ptcld');open_system('sm_excv_trackI2R4_1_ptcld/Track%20L/Track','force'); Open Subsystem>

set_param('sm_excv_trackI2R4_1_ptcld/Track L/Track','LinkStatus','none')
open_system('sm_excv_trackI2R4_1_ptcld/Track L/Track','force')

%% Track Segment Subsystem
%
% Each track segment is composed of a chain link and a shoe. To streamline
% the contact force calculation, simpler geometry is connected to the
% Spatial Contact Force block.  
%
% # A spherical solid is used to model the pin contacting the sprocket.
% # A brick solid is used to model the chain contacting the rollers and idler.
% # A point cloud is used to model the shoe contacting the ground.
%
% The point cloud for the shoe-ground contact is parameterized, so the
% point locations and density can be varied. For example, points can be
% placed on the shoe plate, or on the plate and grousers simply by varying
% the matrix of point locations.
%
% Points on shoe plate only
%
% <<sm_excv_contact_trackSeg_PtcldPlate_Overview.png>>
%
% Points on shoe plate and grouser
% 
% <<sm_excv_contact_trackSeg_PtcldAll_Overview.png>>
%
% <matlab:open_system('sm_excv_trackI2R4_1_ptcld');open_system('sm_excv_trackI2R4_1_ptcld/Track%20L/Track/Seg%2001','force'); Open Subsystem>

set_param('sm_excv_trackI2R4_1_ptcld/Track L/Track/Seg 01','LinkStatus','none')
open_system('sm_excv_trackI2R4_1_ptcld/Track L/Track/Seg 01','force')


%% Simulation Results: Terrain Test
%%
%
% Below are the simulation results from a test where the track is driven
% over a hilly terrain.  The terrain is defined using the Grid Surface
% block.An STL file was imported and interpolation was used to create a
% regular grid composed of 100x100 points.
%
% For ground contact, points are distributed across the shoe plate and not
% the grousers.  

stl_to_gridsurface('hills_terrain.stl',100,100,'plot');

set_param('sm_excv_trackI2R4_1_ptcld/Scene','LabelModeActiveChoice','Terrain');
ExcvI2R4.Shoe.ground_contact.ptcld.pts = ExcvI2R4.Shoe.ptcld_sets.plate;
set_param([bdroot '/Track L'],'popup_sense_roller','Constraint Force')

sim('sm_excv_trackI2R4_1_ptcld');

sm_excv_track_plot1loc(simlog_sm_excv_trackI2R4_1_ptcld,logsout_sm_excv_trackI2R4_1_ptcld);
sm_excv_track_plot2trq(simlog_sm_excv_trackI2R4_1_ptcld);
sm_excv_track_plot3fcroller(logsout_sm_excv_trackI2R4_1_ptcld,'magnitude');

%% Simulation Results: Static Load Test
%
% In this test, we let vehicle settle on flat ground and check final value
% of roller loads along vehicle vertical axis.  This static test helps us
% see if the abstract representation of the masses is correct (amount,
% location).  Note that measuring the roller loads does not take into
% account any mass below the roller.

set_param('sm_excv_trackI2R4_1_ptcld/Track Speeds','LabelModeActiveChoice','None')
set_param('sm_excv_trackI2R4_1_ptcld/Scene',       'LabelModeActiveChoice','Road');
set_param('sm_excv_trackI2R4_1_ptcld/Track L','popup_sense_roller','Constraint Force')
sim('sm_excv_trackI2R4_1_ptcld')
set_param('sm_excv_trackI2R4_1_ptcld/Track L','popup_sense_roller','Actuator Torque')

fcR = sm_excv_track_plot3fcroller(logsout_sm_excv_trackI2R4_1_ptcld,'vertical');
close(gcf)
sm_excv_track_plot5fcrollerFinal('sm_excv_trackI2R4_1_ptcld', fcR);

%%

close all
bdclose('sm_excv_trackI2R4_1_ptcld');
