%% Belt Tracks (Four), Track Contact Point Cloud
% 
% <<sm_trackV_belt4_IdlerArm_i2u0r3_ptcld_terrain_Overview.png>>
%
% (<matlab:web('Tracked_Vehicle_Simscape_Overview.html') return to Tracked Vehicle Model with Simscape Overview>)
%
% This example models a tracked vehicle with a rubber belts for tracks.
% Contact between the track and the ground is modeled using a point cloud
% on each segment of the belt. The track can be tested on uneven terrain or
% a slope.  Contact forces are modeled using the
% <https://www.mathworks.com/help/sm/ref/spatialcontactforce.html Spatial
% Contact Force block>. 
% 
% The track can be tested on uneven terrain, slope, and a flat plane. The
% sprocket is driven with a flexible driveshaft.  The chassis is
% articulated so that it can turn corners
%
% Copyright 2023-2024 The MathWorks, Inc.

%% Model
%
% In this example, four tracks are modeled along with the chassis. 
%
% <matlab:open_system('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld'); Open Model>

open_system('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld')

set_param(find_system('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld','FindAll', 'on','type','annotation','Tag','ModelFeatures'),'Interpreter','off')

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
% <matlab:open_system('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld');open_system('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld/Track%20FL','force'); Open Subsystem>

set_param('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld/Track FL','LinkStatus','none')
open_system('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld/Track FL','force')

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
% <matlab:open_system('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld');open_system('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld/Track%20FL/Undercarriage/Rollers','force'); Open Subsystem>

set_param('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld/Track FL/Undercarriage','LinkStatus','none')
set_param('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld/Track FL/Undercarriage/Rollers','LinkStatus','none')
open_system('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld/Track FL/Undercarriage/Rollers','force')


%% Track Subsystem
%
% A set of track segments are joined using Revolute Joints to model the
% track. The joints are contained in each segment. Joint targets are
% assigned in the mask to ensure the track meshes with the sprocket and
% wraps loosely around the rollers and idler.
%
% <matlab:open_system('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld');open_system('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld/Track%20FL/Track','force'); Open Subsystem>

set_param('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld/Track FL/Track','LinkStatus','none')
open_system('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld/Track FL/Track','force')

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
% <matlab:open_system('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld');open_system('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld/Track%20L/Track/Seg%2001','force'); Open Subsystem>

set_param('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld/Track FL/Track/Seg 01','LinkStatus','none')
open_system('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld/Track FL/Track/Seg 01','force')

%% Steering Subsystem
%
% Ackermann steering angles are calculated based on the steering input,
% wheelbase, and distance between the tracks.  The difference in speed
% based on no-slip travel is also calculated to help the tractor drive in a
% circle at the target turning radius.
%
% <matlab:open_system('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld');open_system('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld/Steering','force'); Open Subsystem>

set_param('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld/Steering','LinkStatus','none')
open_system('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld/Steering','force')


%% Simulation Results: Terrain Test
%%
%
% Below are the simulation results from a test where the track is driven
% over a hilly terrain.  The terrain is defined using the
% <https://www.mathworks.com/help/sm/ref/gridsurface.html
% Grid Surface block>. An STL file was imported and interpolation was used to create a
% regular grid composed of 100x100 points.
%

stl_to_gridsurface('hills_terrain.stl',100,100,'plot');

set_param('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld/Scene','LabelModeActiveChoice','Terrain');
set_param([bdroot '/Steer On'],'Gain','1')
set_param([bdroot '/Track FL'],'popup_sense_roller','Actuator Torque')
set_param([bdroot '/Track FR'],'popup_sense_roller','Actuator Torque')
set_param([bdroot '/Track RL'],'popup_sense_roller','Actuator Torque')
set_param([bdroot '/Track RR'],'popup_sense_roller','Actuator Torque')

set_param(bdroot,'StopTime','14')
sim('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld');

sm_excv_track_plot1loc(simlog_sm_trackV_belt4_IdlerArm_i2u0r3_ptcld,logsout_sm_trackV_belt4_IdlerArm_i2u0r3_ptcld);
sm_excv_track_plot2trq(simlog_sm_trackV_belt4_IdlerArm_i2u0r3_ptcld);
sm_excv_track_plot4xy(simlog_sm_trackV_belt4_IdlerArm_i2u0r3_ptcld);

%%

close all
%bdclose('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld');
