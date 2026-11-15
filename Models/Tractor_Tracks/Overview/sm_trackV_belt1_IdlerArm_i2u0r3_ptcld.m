%% Belt Track (Single), Ground Contact Point Cloud
% 
% <<sm_trackV_belt1_IdlerArm_i2u0r3_ptcld_terrain_Overview.png>>
%
% (<matlab:web('Tracked_Vehicle_Simscape_Overview.html') return to Tracked Vehicle Model with Simscape Overview>)
%
% This example models a single track from a tracked vehicle with a rubber
% belt. Contact between the track and the ground is modeled using a point
% cloud on the belt. The track can be tested on uneven terrain or a slope.
% The sprocket is driven with a flexible driveshaft.
%
% Copyright 2024-2026 The MathWorks, Inc.

%% Model
%
% In this example, one track is modeled and half of the chassis mass is
% centered on the track.  This enables faster adjustments of the track
% model which can then be mirrored to the second track.
%
% <matlab:sm_trackV_open_model('sm_trackV_belt1_IdlerArm_i2u0r3',{'Track%20L'},'BeltPts',''); Open Model>

open_system('sm_trackV_belt1_IdlerArm_i2u0r3')

set_param(find_system('sm_trackV_belt1_IdlerArm_i2u0r3','FindAll', 'on','MatchFilter',@Simulink.match.allVariants,'type','annotation','Tag','ModelFeatures'),'Interpreter','off')
set_param('sm_trackV_belt1_IdlerArm_i2u0r3/Track L','popup_trackModel','Belt, Points');
sm_trackV_measure_loads('sm_trackV_belt1_IdlerArm_i2u0r3/Track L','Actuator Torque');

%% Track Subsystem
%
% The track is composed of the undercarriage and the belt segments
% connected into a loop.  The undercarriage contains the rollers, sprocket,
% and two idlers. Everything is rigidly attached to the frame except one
% idler which is attached to an arm which is pushed against the belt to
% hold it in tension.  These exert forces on the belt through two
% sets of contact forces.
% 
% 1. The belt lugs press against the sprocket pins
%
% <<sm_belt_contact_sprocketToLugs_Overview.png>>
%
% 2. The belt carcass rolls along sprocket and roller surfaces
%
% <<sm_belt_contact_rollerToCarcass_Overview.png>>
%
% <<sm_belt_contact_sprocketToCarcass_Overview.png>>
%
% The Planar Track joint positions one of the belt lugs at a gap between
% the sprocket pins which is positioned facing straight down. Joint targets
% applied to the track segments helps it to mesh with other pins on the
% sprocket and loosely wrap around the rollers and idler. The block
% Transform Half Seg Angle orients the interface frame so that the two
% chain segments attached to that pin will wrap around the sprocket.
%
% <matlab:sm_trackV_open_model('sm_trackV_belt1_IdlerArm_i2u0r3',{'Track%20L'},'BeltPts','Track%20L/BeltPts'); Open Subsystem>

set_param('sm_trackV_belt1_IdlerArm_i2u0r3/Track L/BeltPts','LinkStatus','none')
open_system('sm_trackV_belt1_IdlerArm_i2u0r3/Track L/BeltPts','force')

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
% <matlab:sm_trackV_open_model('sm_trackV_belt1_IdlerArm_i2u0r3',{'Track%20L'},'BeltPts','Track%20L/BeltPts/Undercarriage/Rollers'); Open Subsystem>

set_param('sm_trackV_belt1_IdlerArm_i2u0r3/Track L/BeltPts/Undercarriage','LinkStatus','none')
set_param('sm_trackV_belt1_IdlerArm_i2u0r3/Track L/BeltPts/Undercarriage/Rollers','LinkStatus','none')
open_system('sm_trackV_belt1_IdlerArm_i2u0r3/Track L/BeltPts/Undercarriage/Rollers','force')

%% Track Subsystem
%
% A set of track segments are joined using Revolute Joints to model the
% track. The joints are contained in each segment. Joint targets are
% assigned in the mask to ensure the track meshes with the sprocket and
% wraps loosely around the rollers and idler.
%
% <matlab:sm_trackV_open_model('sm_trackV_belt1_IdlerArm_i2u0r3',{'Track%20L'},'BeltPts','Track%20L/BeltPts/Track'); Open Subsystem>

set_param('sm_trackV_belt1_IdlerArm_i2u0r3/Track L/BeltPts/Track','LinkStatus','none')
open_system('sm_trackV_belt1_IdlerArm_i2u0r3/Track L/BeltPts/Track','force')

%% Belt Segment Subsystem
%
% Each belt segment is composed of the carcass and lug. To streamline
% the contact force calculation, simpler geometry is connected to the
% Spatial Contact Force block.  
%
% # <matlab:web(fullfile(docroot,'sm/ref/disk.html')); Disk> geometry is used to model the pins in the sprocket.
% # <matlab:web(fullfile(docroot,'sm/ref/linesegment.html')); Line Segment> geometry are used to model the lugs and inner carcass surfaces.
% # <matlab:web(fullfile(docroot,'sm/ref/pointcloud.html')); Point Cloud> geometry is used to model the outer carcass surface.
%
% The point cloud for the belt-ground contact is parameterized, so the
% point locations and density can be varied. 
%
% <<sm_belt_contact_trackSeg_Ptcld_Line_Overview.png>>
%
%
% <matlab:sm_trackV_open_model('sm_trackV_belt1_IdlerArm_i2u0r3',{'Track%20L'},'BeltPts','Track%20L/BeltPts/Track/Seg%2001'); Open Subsystem>

set_param('sm_trackV_belt1_IdlerArm_i2u0r3/Track L/BeltPts/Track/Seg 01','LinkStatus','none')
open_system('sm_trackV_belt1_IdlerArm_i2u0r3/Track L/BeltPts/Track/Seg 01','force')


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

set_param('sm_trackV_belt1_IdlerArm_i2u0r3/Scene','LabelModeActiveChoice','Terrain');
sm_trackV_measure_loads([bdroot '/Track L'],'Constraint Force')

sim('sm_trackV_belt1_IdlerArm_i2u0r3');
sm_trackV_measure_loads([bdroot '/Track L'],'Actuator Torque')

sm_excv_track_plot1loc(simlog_sm_trackV_belt1_IdlerArm_i2u0r3,logsout_sm_trackV_belt1_IdlerArm_i2u0r3);
sm_excv_track_plot2trq(simlog_sm_trackV_belt1_IdlerArm_i2u0r3);
sm_excv_track_plot3fcroller(logsout_sm_trackV_belt1_IdlerArm_i2u0r3,'magnitude');

%%

close all
bdclose('sm_trackV_belt1_IdlerArm_i2u0r3');
