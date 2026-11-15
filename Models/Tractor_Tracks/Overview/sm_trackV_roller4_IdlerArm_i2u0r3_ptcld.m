%% Belt Tracks (Four), Roller Contact Point Cloud
% 
% <<sm_trackV_roller4_IdlerArm_i2u0r3_ptcld_terrain_Overview.png>>
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
% The track can be tested on uneven terrain, slope, and a flat plane. The
% sprocket is driven with a flexible driveshaft.
%
% Copyright 2023-2026 The MathWorks, Inc.

%% Model
%
% In this example, four tracks are modeled along with the chassis. 
%
% <matlab:sm_trackV_open_model('sm_trackV_belt4_IdlerArm_i2u0r3',{'Track%20FL','Track%20FR','Track%20RL','Track%20RR'},'RollerPts',''); Open Model>

open_system('sm_trackV_belt4_IdlerArm_i2u0r3')

set_param(find_system('sm_trackV_belt4_IdlerArm_i2u0r3','FindAll', 'on','MatchFilter',@Simulink.match.allVariants,'type','annotation','Tag','ModelFeatures'),'Interpreter','off')
set_param('sm_trackV_belt4_IdlerArm_i2u0r3/Track FL','popup_trackModel','Rollers, Points');
set_param('sm_trackV_belt4_IdlerArm_i2u0r3/Track FR','popup_trackModel','Rollers, Points');
set_param('sm_trackV_belt4_IdlerArm_i2u0r3/Track RL','popup_trackModel','Rollers, Points');
set_param('sm_trackV_belt4_IdlerArm_i2u0r3/Track RR','popup_trackModel','Rollers, Points');
sm_trackV_measure_loads('sm_trackV_belt4_IdlerArm_i2u0r3/Track FL','Actuator Torque')
sm_trackV_measure_loads('sm_trackV_belt4_IdlerArm_i2u0r3/Track FR','Actuator Torque')
sm_trackV_measure_loads('sm_trackV_belt4_IdlerArm_i2u0r3/Track RL','Actuator Torque')
sm_trackV_measure_loads('sm_trackV_belt4_IdlerArm_i2u0r3/Track RR','Actuator Torque')

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
% <matlab:sm_trackV_open_model('sm_trackV_belt4_IdlerArm_i2u0r3',{'Track%20FL','Track%20FR','Track%20RL','Track%20RR'},'RollerPts','Track%20FL/RollerPts'); Open Subsystem>

set_param('sm_trackV_belt4_IdlerArm_i2u0r3/Track FL/RollerPts','LinkStatus','none')
open_system('sm_trackV_belt4_IdlerArm_i2u0r3/Track FL/RollerPts','force')

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
% <matlab:sm_trackV_open_model('sm_trackV_belt4_IdlerArm_i2u0r3',{'Track%20FL','Track%20FR','Track%20RL','Track%20RR'},'RollerPts','Track%20FL/RollerPts/Undercarriage/Rollers'); Open Subsystem>

set_param('sm_trackV_belt4_IdlerArm_i2u0r3/Track FL/RollerPts/Undercarriage','LinkStatus','none')
set_param('sm_trackV_belt4_IdlerArm_i2u0r3/Track FL/RollerPts/Undercarriage/Rollers','LinkStatus','none')
open_system('sm_trackV_belt4_IdlerArm_i2u0r3/Track FL/RollerPts/Undercarriage/Rollers','force')

%% Lower Roller Subsystem
%
% The lower rollers, sprocket, and idler contain a solid to represent the
% inertial properties. The rollers and idler include a point cloud to model
% contact with the ground, and a visual element to animate the part
% spinning in the model.
%
% <matlab:sm_trackV_open_model('sm_trackV_belt4_IdlerArm_i2u0r3',{'Track%20FL','Track%20FR','Track%20RL','Track%20RR'},'RollerPts','Track%20FL/RollerPts/Undercarriage/Rollers/Roller%20Lower%201s'); Open Subsystem>

set_param('sm_trackV_belt4_IdlerArm_i2u0r3/Track FL/RollerPts/Undercarriage/Rollers/Roller Lower 1','LinkStatus','none')
open_system('sm_trackV_belt4_IdlerArm_i2u0r3/Track FL/RollerPts/Undercarriage/Rollers/Roller Lower 1','force')


%% Track Subsystem
%
% The track is modeled as a solid. It provides a visual indication of where
% the track segments would be.  It also includes mass and inertia
% properties which can be parameterized to match the full set of track
% segments.
%
% <matlab:sm_trackV_open_model('sm_trackV_belt4_IdlerArm_i2u0r3',{'Track%20FL','Track%20FR','Track%20RL','Track%20RR'},'RollerPts','Track%20FL/RollerPts/Track'); Open Subsystem>

set_param('sm_trackV_belt4_IdlerArm_i2u0r3/Track FL/RollerPts/Track','LinkStatus','none')
open_system('sm_trackV_belt4_IdlerArm_i2u0r3/Track FL/RollerPts/Track','force')

%% Chassis Subsystem
%
% The chassis can articulate. A Revolute Joint connecting the front and
% rear can bend. 
%
% <matlab:sm_trackV_open_model('sm_trackV_belt4_IdlerArm_i2u0r3',{'Track%20FL','Track%20FR','Track%20RL','Track%20RR'},'RollerPts','Chassis'); Open Subsystem>

set_param('sm_trackV_belt4_IdlerArm_i2u0r3/Chassis','LinkStatus','none')
open_system('sm_trackV_belt4_IdlerArm_i2u0r3/Chassis','force')

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

set_param('sm_trackV_belt4_IdlerArm_i2u0r3/Scene','LabelModeActiveChoice','Terrain');
set_param([bdroot '/Steer On'],'Gain','1')
sm_trackV_measure_loads([bdroot '/Track FL'],'Actuator Torque')
sm_trackV_measure_loads([bdroot '/Track FR'],'Actuator Torque')
sm_trackV_measure_loads([bdroot '/Track RL'],'Actuator Torque')
sm_trackV_measure_loads([bdroot '/Track RR'],'Actuator Torque')

set_param(bdroot,'StopTime','14')
sim('sm_trackV_belt4_IdlerArm_i2u0r3');

sm_excv_track_plot1loc(simlog_sm_trackV_belt4_IdlerArm_i2u0r3,logsout_sm_trackV_belt4_IdlerArm_i2u0r3);
sm_excv_track_plot2trq(simlog_sm_trackV_belt4_IdlerArm_i2u0r3);
sm_excv_track_plot4xy(simlog_sm_trackV_belt4_IdlerArm_i2u0r3);

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

set_param('sm_trackV_belt4_IdlerArm_i2u0r3/Scene','LabelModeActiveChoice','Slope');
set_param([bdroot '/Steer On'],'Gain','0')
sm_trackV_measure_loads([bdroot '/Track FL'],'Actuator Torque')
sm_trackV_measure_loads([bdroot '/Track FR'],'Actuator Torque')
sm_trackV_measure_loads([bdroot '/Track RL'],'Actuator Torque')
sm_trackV_measure_loads([bdroot '/Track RR'],'Actuator Torque')

set_param(bdroot,'StopTime','14')
sim('sm_trackV_belt4_IdlerArm_i2u0r3');

sm_excv_track_plot1loc(simlog_sm_trackV_belt4_IdlerArm_i2u0r3,logsout_sm_trackV_belt4_IdlerArm_i2u0r3);
sm_excv_track_plot2trq(simlog_sm_trackV_belt4_IdlerArm_i2u0r3);


%% Simulation Results: Plane Test, Articulated Steering
%%
%
% Below are the simulation results from a test where the track is driven on
% a flat plane. Steering is accomplished by articulating the chassis , and
% the drive speed of all four tracks are modified based on the steering
% angle so that the tractor drives in a circular curve.
%

set_param([bdroot '/Steer On'],'Gain','1')
set_param([bdroot '/Steering'],'popup_steering','Articulation');
set_param('sm_trackV_belt4_IdlerArm_i2u0r3/Scene','LabelModeActiveChoice','Plane');
sm_trackV_measure_loads([bdroot '/Track FL'],'Actuator Torque')
sm_trackV_measure_loads([bdroot '/Track FR'],'Actuator Torque')
sm_trackV_measure_loads([bdroot '/Track RL'],'Actuator Torque')
sm_trackV_measure_loads([bdroot '/Track RR'],'Actuator Torque')

set_param(bdroot,'StopTime','32')
sim('sm_trackV_belt4_IdlerArm_i2u0r3');

sm_excv_track_plot1loc(simlog_sm_trackV_belt4_IdlerArm_i2u0r3,logsout_sm_trackV_belt4_IdlerArm_i2u0r3);
sm_excv_track_plot2trq(simlog_sm_trackV_belt4_IdlerArm_i2u0r3);
sm_excv_track_plot4xy(simlog_sm_trackV_belt4_IdlerArm_i2u0r3);

simlog_px_art = simlog_sm_trackV_belt4_IdlerArm_i2u0r3.Assembly_to_World.Px.p.series.values;
simlog_py_art = simlog_sm_trackV_belt4_IdlerArm_i2u0r3.Assembly_to_World.Py.p.series.values;

%% Simulation Results: Plane Test, Ackermann Steering
%%
%
% Below are the simulation results from a test where the track is driven on
% a flat plane. The front tracks are steered using Ackermann steering
% angles, and the drive speed of all four tracks are modified based on the
% steering angle so that the tractor drives in a circular curve.
%

set_param([bdroot '/Steer On'],'Gain','1')
set_param([bdroot '/Steering'],'popup_steering','Ackermann');
set_param('sm_trackV_belt4_IdlerArm_i2u0r3/Scene','LabelModeActiveChoice','Plane');
sm_trackV_measure_loads([bdroot '/Track FL'],'Actuator Torque')
sm_trackV_measure_loads([bdroot '/Track FR'],'Actuator Torque')
sm_trackV_measure_loads([bdroot '/Track RL'],'Actuator Torque')
sm_trackV_measure_loads([bdroot '/Track RR'],'Actuator Torque')

set_param(bdroot,'StopTime','32')
sim('sm_trackV_belt4_IdlerArm_i2u0r3');

sm_excv_track_plot1loc(simlog_sm_trackV_belt4_IdlerArm_i2u0r3,logsout_sm_trackV_belt4_IdlerArm_i2u0r3);
sm_excv_track_plot2trq(simlog_sm_trackV_belt4_IdlerArm_i2u0r3);
sm_excv_track_plot4xy(simlog_sm_trackV_belt4_IdlerArm_i2u0r3);

simlog_px_ack = simlog_sm_trackV_belt4_IdlerArm_i2u0r3.Assembly_to_World.Px.p.series.values;
simlog_py_ack = simlog_sm_trackV_belt4_IdlerArm_i2u0r3.Assembly_to_World.Py.p.series.values;

figure(999)
plot(simlog_px_art,simlog_py_art,'LineWidth',1,'DisplayName','Articulated')
hold on
plot(simlog_px_ack,simlog_py_ack,'LineWidth',1,'DisplayName','Ackermann')
hold off
title('Tractor Path')
xlabel('Position (m)');
ylabel('Position (m)');
axis equal

%% Simulation Results: Static Load Test
%%
%
% In this test, we let vehicle settle on flat ground and check final value
% of roller loads along vehicle vertical axis.  This static test helps us
% see if the abstract representation of the masses is correct (amount,
% location).  Note that measuring the roller loads does not take into
% account any mass below the roller.

set_param('sm_trackV_belt4_IdlerArm_i2u0r3/Vehicle Speed','LabelModeActiveChoice','None')
set_param('sm_trackV_belt4_IdlerArm_i2u0r3/Scene',       'LabelModeActiveChoice','Slope');

sm_trackV_measure_loads([bdroot '/Track FL'],'Constraint Force')
sm_trackV_measure_loads([bdroot '/Track FR'],'Constraint Force')
sm_trackV_measure_loads([bdroot '/Track RL'],'Constraint Force')
sm_trackV_measure_loads([bdroot '/Track RR'],'Constraint Force')


set_param('sm_trackV_belt4_IdlerArm_i2u0r3/Steer On','Gain','0');
sim('sm_trackV_belt4_IdlerArm_i2u0r3');
sm_trackV_measure_loads([bdroot '/Track FL'],'Actuator Torque')
sm_trackV_measure_loads([bdroot '/Track FR'],'Actuator Torque')
sm_trackV_measure_loads([bdroot '/Track RL'],'Actuator Torque')
sm_trackV_measure_loads([bdroot '/Track RR'],'Actuator Torque')

fcR = sm_excv_track_plot3fcroller(logsout_sm_trackV_belt4_IdlerArm_i2u0r3,'vertical');
close(gcf)
sm_excv_track_plot5fcrollerFinal('sm_trackV_belt2_IdlerArm_i2u0r3_ptcld', fcR);


%%

close all
bdclose('sm_trackV_belt4_IdlerArm_i2u0r3');
