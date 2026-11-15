%% Excavator Tracks, Roller Contact Point Cloud
% 
% <<sm_excv_track2_roller_ptcld_Overview.png>>
%
% (<matlab:web('Tracked_Vehicle_Simscape_Overview.html') return to Tracked Vehicle Model with Simscape Overview>)
%
% This example models the track drive on an excavator in an abstract
% manner. Contact between the track and the ground is modeled using a point
% cloud on the rollers, sprocket, and idler. The point cloud radius
% includes the depth of the track. This method permits significantly faster
% simulation for it is far simpler than modeling each segment of the track
% and all the contact forces with the undercarriage and ground.  Contact
% forces are modeled using the <https://www.mathworks.com/help/sm/ref/spatialcontactforce.html Spatial Contact Force block>.
% 
% The track can be tested on uneven terrain, a slope, or a flat road with
% bumps. The sprocket is driven with a flexible driveshaft.
%
% Copyright 2023-2026 The MathWorks, Inc.

%% Model
%
% In this example, both tracks are modeled along with the chassis of excavator. 
%
% <matlab:sm_trackV_open_model('sm_excv_track2',{'Track%20L','Track%20R'},'RollerPts',''); Open Model>

open_system('sm_excv_track2')

set_param(find_system('sm_excv_track2','FindAll', 'on','MatchFilter',@Simulink.match.allVariants,'type','annotation','Tag','ModelFeatures'),'Interpreter','off')
set_param('sm_excv_track2/Track L','popup_trackModel','Rollers, Points');
set_param('sm_excv_track2/Track R','popup_trackModel','Rollers, Points');
sm_trackV_measure_loads('sm_excv_track2/Track L','Actuator Torque')
sm_trackV_measure_loads('sm_excv_track2/Track R','Actuator Torque')

%% Track Subsystem
%
% The track is composed of the undercarriage and a visual element to
% represent the track segments which includes parameters for the assumed
% mass, inertia, and CG of the track segments.  The undercarriage contains the
% rollers, sprocket, and idler which are rigidly attached to the frame.
% Contact geometry (point clouds) in the undercarriage subsystem connect
% via a Simscape bus to <https://www.mathworks.com/help/sm/ref/spatialcontactforce.html Spatial Contact Force block> to model ground
% contact.
% 
% <matlab:sm_trackV_open_model('sm_excv_track2',{'Track%20L','Track%20R'},'RollerPts','Track%20L/RollerPts'); Open Subsystem>

set_param('sm_excv_track2/Track L/RollerPts','LinkStatus','none')
open_system('sm_excv_track2/Track L/RollerPts','force')

%% Rollers Subsystem
%
% This subsystem models the rollers, idler, and sprocket.  They each can
% rotate around shafts attached to the lower frame. In this abstract model,
% the tensioner holds the idler at a fixed position, the position it would
% reach if the track were holding it in place.
%
% The sprocket joint interfaces to 1D mechanical rotational port.  This
% represents a mechanical shaft connection to the sprocket. It can be
% attached to Simscape models of gears, hydrostatic transmissions, and
% electric motors.
%
% The bus of connections at port R contains the connections to the geometry
% that is used to model contact with the ground.  The rollers, sprocket,
% and idler have point clouds whose radius includes the depth of the track.
%
% <matlab:sm_trackV_open_model('sm_excv_track2',{'Track%20L','Track%20R'},'RollerPts','Track%20L/RollerPts/Undercarriage/Rollers'); Open Subsystem>

set_param('sm_excv_track2/Track L/RollerPts/Undercarriage','LinkStatus','none')
set_param('sm_excv_track2/Track L/RollerPts/Undercarriage/Rollers','LinkStatus','none')
open_system('sm_excv_track2/Track L/RollerPts/Undercarriage/Rollers','force')

%% Lower Roller Subsystem
%
% The lower rollers, sprocket, and idler contain a solid to represent the
% inertial properties, a point cloud to model contact with the ground, and
% a visual element to animate the part spinning in the model.
%
% <matlab:sm_trackV_open_model('sm_excv_track2',{'Track%20L','Track%20R'},'RollerPts','Track%20L/RollerPts/Undercarriage/Rollers/Roller%20Lower%201'); Open Subsystem>

set_param('sm_excv_track2/Track L/RollerPts/Undercarriage/Rollers/Roller Lower 1','LinkStatus','none')
open_system('sm_excv_track2/Track L/RollerPts/Undercarriage/Rollers/Roller Lower 1','force')


%% Track Subsystem
%
% The track is modeled as a solid. It provides a visual indication of where
% the track segments would be.  It also includes mass and inertia
% properties which can be parameterized to match the full set of track
% segments.
%
% <matlab:sm_trackV_open_model('sm_excv_track2',{'Track%20L','Track%20R'},'RollerPts','Track%20L/RollerPts/Track'); Open Subsystem>

set_param('sm_excv_track2/Track L/RollerPts/Track','LinkStatus','none')
open_system('sm_excv_track2/Track L/RollerPts/Track','force')

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

Excv = sm_excv_track_param_machine;
set_param('sm_excv_track2/Scene','LabelModeActiveChoice','Terrain');
sm_trackV_measure_loads('sm_excv_track2/Track L','Constraint Force')
sm_trackV_measure_loads('sm_excv_track2/Track R','Constraint Force')

sim('sm_excv_track2');

sm_excv_track_plot1loc(simlog_sm_excv_track2,logsout_sm_excv_track2);
sm_excv_track_plot2trq(simlog_sm_excv_track2);
sm_excv_track_plot3fcroller(logsout_sm_excv_track2,'magnitude');

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

Excv = sm_excv_track_param_machine;
set_param('sm_excv_track2/Scene','LabelModeActiveChoice','Slope');
sm_trackV_measure_loads('sm_excv_track2/Track L','Constraint Force')
sm_trackV_measure_loads('sm_excv_track2/Track R','Constraint Force')

sim('sm_excv_track2');

sm_excv_track_plot1loc(simlog_sm_excv_track2,logsout_sm_excv_track2);
sm_excv_track_plot2trq(simlog_sm_excv_track2);
sm_excv_track_plot3fcroller(logsout_sm_excv_track2,'magnitude');

%% Simulation Results: Static Load Test
%%
%
% In this test, we let vehicle settle on flat ground and check final value
% of roller loads along vehicle vertical axis.  This static test helps us
% see if the abstract representation of the masses is correct (amount,
% location).  Note that measuring the roller loads does not take into
% account any mass below the roller.

set_param('sm_excv_track2/Track Speeds','LabelModeActiveChoice','None')
set_param('sm_excv_track2/Scene',       'LabelModeActiveChoice','Road');
sm_trackV_measure_loads('sm_excv_track2/Track L','Constraint Force')
sm_trackV_measure_loads('sm_excv_track2/Track R','Constraint Force')
sim('sm_excv_track2');
sm_trackV_measure_loads('sm_excv_track2/Track L','Actuator Torque')
sm_trackV_measure_loads('sm_excv_track2/Track R','Actuator Torque')

fcR = sm_excv_track_plot3fcroller(logsout_sm_excv_track2,'vertical');
close(gcf)
sm_excv_track_plot5fcrollerFinal('sm_excv_track2', fcR);

%%

close all
bdclose('sm_excv_track2');
