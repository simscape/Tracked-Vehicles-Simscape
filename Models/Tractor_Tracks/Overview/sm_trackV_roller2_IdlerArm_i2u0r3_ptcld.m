%% Belt Tracks (Double), Roller Contact Point Cloud
% 
% <<sm_trackV_roller2_IdlerArm_i2u0r3_ptcld_terrain_Overview.png>>
%
% (<matlab:web('Tracked_Vehicle_Simscape_Overview.html') return to Tracked Vehicle Model with Simscape Overview>)
%
% This example models a tracked vehicle with a rubber belts in an abstract
% manner. Contact between the track and the ground is modeled using a point
% cloud on the rollers and idlers. The point cloud radius
% includes the depth of the belt. This method permits significantly faster
% simulation for it is far simpler than modeling each segment of the track
% and all the contact forces with the undercarriage and ground.  Contact
% forces are modeled using the <https://www.mathworks.com/help/sm/ref/spatialcontactforce.html Spatial Contact Force block>.
% 
% The track can be tested on uneven terrain and a slope. The sprocket is
% driven with a flexible driveshaft.
%
% Copyright 2023-2024 The MathWorks, Inc.

%% Model
%
% In this example, both tracks are modeled along with the chassis. 
%
% <matlab:open_system('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld'); Open Model>

open_system('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld')

set_param(find_system('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld','FindAll', 'on','type','annotation','Tag','ModelFeatures'),'Interpreter','off')

%% Track Subsystem
%
% The track is composed of the undercarriage and a visual element to
% represent the track segments which includes parameters for the assumed
% mass, inertia, and CG of the belt segments.  The undercarriage contains
% the rollers, sprocket, and two idlers. Everything is rigidly attached to
% the frame except one idler is attached to an arm which can pivot
% slightly. Contact geometry (point clouds) in the undercarriage subsystem
% connect via a Simscape bus to
% <https://www.mathworks.com/help/sm/ref/spatialcontactforce.html Spatial
% Contact Force block> to model ground contact.
% 
% <matlab:open_system('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld');open_system('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld/Track%20L','force'); Open Subsystem>

set_param('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld/Track L','LinkStatus','none')
open_system('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld/Track L','force')

%% Rollers Subsystem
%
% This subsystem models the rollers, idler, and sprocket.  They each can
% rotate around shafts attached to the lower frame. One idler is
% attached to an arm which can pivot slightly.
%
% The sprocket joint interfaces to 1D mechanical rotational port.  This
% represents a mechanical shaft connection to the sprocket. It can be
% attached to Simscape models of gears, hydrostatic transmissions, and
% electric motors.
%
% The bus of connections at port R contains the connections to the geometry
% that is used to model contact with the ground.  The rollers and idlers
% have point clouds whose radius includes the depth of the track.
%
% <matlab:open_system('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld');open_system('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld/Track%20L/Undercarriage/Rollers','force'); Open Subsystem>

set_param('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld/Track L/Undercarriage','LinkStatus','none')
set_param('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld/Track L/Undercarriage/Rollers','LinkStatus','none')
open_system('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld/Track L/Undercarriage/Rollers','force')

%% Lower Roller Subsystem
%
% The lower rollers, sprocket, and idler contain a solid to represent the
% inertial properties. The rollers and idler include a point cloud to model
% contact with the ground, and a visual element to animate the part
% spinning in the model.
%
% <matlab:open_system('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld');open_system('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld/Track%20L/Undercarriage/Rollers/Roller%20Lower%201','force'); Open Subsystem>

set_param('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld/Track L/Undercarriage/Rollers/Roller Lower 1','LinkStatus','none')
open_system('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld/Track L/Undercarriage/Rollers/Roller Lower 1','force')


%% Track Subsystem
%
% The track is modeled as a solid. It provides a visual indication of where
% the track segements would be.  It also includes mass and inertia
% properties which can be parameterized to match the full set of track
% segments.
%
% <matlab:open_system('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld');open_system('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld/Track%20L/Track','force'); Open Subsystem>

set_param('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld/Track L/Track','LinkStatus','none')
open_system('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld/Track L/Track','force')

%% Simulation Results: Terrain Test
%%
%
% Below are the simulation results from a test where the track is driven
% over a hilly terrain.  The terrain is defined using the
% <https://www.mathworks.com/help/sm/ref/gridsurface.html
% Grid Surface block>. An STL file was imported and interpolation was used to create a
% regular grid composed of 100x100 points.
%
% In this test, the frame with the rollers and idler is fixed and cannot
% rotate respect to the chassis.

stl_to_gridsurface('hills_terrain.stl',100,100,'plot');

Trac = sm_trackV_belt_param_machine_seg45i2u0r3_IdlerArm;
set_param('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld/Scene','LabelModeActiveChoice','Terrain');

set_param([bdroot '/Track L'],'popup_sense_roller','Constraint Force')
set_param([bdroot '/Track R'],'popup_sense_roller','Constraint Force')

set_param([bdroot '/Track L'],'popup_trackFrame','Fixed')
set_param([bdroot '/Track R'],'popup_trackFrame','Fixed')


sim('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld');

sm_excv_track_plot1loc(simlog_sm_trackV_roller2_IdlerArm_i2u0r3_ptcld,logsout_sm_trackV_roller2_IdlerArm_i2u0r3_ptcld);
sm_excv_track_plot2trq(simlog_sm_trackV_roller2_IdlerArm_i2u0r3_ptcld);
sm_excv_track_plot3fcroller(logsout_sm_trackV_roller2_IdlerArm_i2u0r3_ptcld,'magnitude');

%% Simulation Results: Slope Test
%%
%
% Below are the simulation results from a test where the track is driven up
% a slope. The slope was defined using a MATLAB function.  This would let
% us easily sweep the grade of the slope to determine when the design would
% no longer meet requirements.  The terrain is defined using the
% <https://www.mathworks.com/help/sm/ref/gridsurface.html
% Grid Surface block>. 
%

Grid_Surface_Data_Slope(25, 9, 7.5, 1.5, 5, 0.5, 'plot');

Trac = sm_trackV_belt_param_machine_seg45i2u0r3_IdlerArm;
set_param('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld/Scene','LabelModeActiveChoice','Slope');
set_param([bdroot '/Track L'],'popup_sense_roller','Constraint Force')
set_param([bdroot '/Track R'],'popup_sense_roller','Constraint Force')

sim('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld');

sm_excv_track_plot1loc(simlog_sm_trackV_roller2_IdlerArm_i2u0r3_ptcld,logsout_sm_trackV_roller2_IdlerArm_i2u0r3_ptcld);
sm_excv_track_plot2trq(simlog_sm_trackV_roller2_IdlerArm_i2u0r3_ptcld);
sm_excv_track_plot3fcroller(logsout_sm_trackV_roller2_IdlerArm_i2u0r3_ptcld,'magnitude');

%% Simulation Results: Static Load Test
%%
%
% In this test, we let vehicle settle on flat ground and check final value
% of roller loads along vehicle vertical axis.  This static test helps us
% see if the abstract representation of the masses is correct (amount,
% location).  Note that measuring the roller loads does not take into
% account any mass below the roller.

set_param('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld/Track Speeds','LabelModeActiveChoice','None')
set_param('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld/Scene',       'LabelModeActiveChoice','Slope');
set_param('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld/Track L','popup_sense_roller','Constraint Force')
set_param('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld/Track R','popup_sense_roller','Constraint Force')
sim('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld');
set_param('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld/Track L','popup_sense_roller','Actuator Torque')
set_param('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld/Track R','popup_sense_roller','Actuator Torque')

fcR = sm_excv_track_plot3fcroller(logsout_sm_trackV_roller2_IdlerArm_i2u0r3_ptcld,'vertical');
close(gcf)
sm_excv_track_plot5fcrollerFinal('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld', fcR);

%%

close all
bdclose('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld');
