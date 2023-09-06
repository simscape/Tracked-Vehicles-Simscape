%% Excavator Track (Single), Roller Contact Spheres
% 
% <<sm_excv_track1_roller_sphere_Overview.png>>
%
% (<matlab:web('Tracked_Vehicle_Simscape_Overview.html') return to Tracked Vehicle Model with Simscape Overview>)
%
% This example models a single track from an excavator in an abstract
% manner. Contact between the track and the ground is modeled using two
% spheres on each rollers, sprocket, and idler. The sphere radius includes
% the depth of the track. This method permits significantly faster
% simulation for it is far simpler than modeling each segment of the track
% and all the contact forces with the undercarriage and ground.  Contact
% forces are modeled using the
% <https://www.mathworks.com/help/sm/ref/spatialcontactforce.html Spatial
% Contact Force block>.
% 
% The track can be tested on flat and uneven surfaces. The sprocket is driven with a
% flexible driveshaft.
%
% Copyright 2023 The MathWorks, Inc.

%% Model
%
% In this example, one track is modeled and half of the excavator mass is
% centered on the track.  This enables faster adjustments of the track
% model which can then be mirrored to the second track.
%
% <matlab:open_system('sm_excv_track1_roller_sphere'); Open Model>

open_system('sm_excv_track1_roller_sphere')

set_param(find_system('sm_excv_track1_roller_sphere','FindAll', 'on','type','annotation','Tag','ModelFeatures'),'Interpreter','off')

%% Track Subsystem
%
% The track is composed of the undercarriage and a visual element to
% represent the track segments which includes parameters for the assumed
% mass, inertia, and CG of the track segments.  The undercarriage contains the
% rollers, sprocket, and idler which are rigidly attached to the frame.
% Contact geometry (spheres) in the undercarriage subsystem connect
% via a Simscape bus to <https://www.mathworks.com/help/sm/ref/spatialcontactforce.html Spatial Contact Force block> to model ground
% contact.
% 
% <matlab:open_system('sm_excv_track1_roller_sphere');open_system('sm_excv_track1_roller_sphere/Track%20L','force'); Open Subsystem>

set_param('sm_excv_track1_roller_sphere/Track L','LinkStatus','none')
open_system('sm_excv_track1_roller_sphere/Track L','force')

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
% <matlab:open_system('sm_excv_track1_roller_sphere');open_system('sm_excv_track1_roller_sphere/Track%20L/Undercarriage/Rollers','force'); Open Subsystem>

set_param('sm_excv_track1_roller_sphere/Track L/Undercarriage','LinkStatus','none')
set_param('sm_excv_track1_roller_sphere/Track L/Undercarriage/Rollers','LinkStatus','none')
open_system('sm_excv_track1_roller_sphere/Track L/Undercarriage/Rollers','force')

%% Lower Roller Subsystem
%
% The lower rollers, sprocket, and idler contain a solid to represent the
% inertial properties, and two spheres to model contact with the ground.
% The spheres are positioned so that they touch the ground at the edges of
% the track.
%
% <matlab:open_system('sm_excv_track1_roller_sphere');open_system('sm_excv_track1_roller_sphere/Track%20L/Undercarriage/Rollers/Roller%20Lower%201','force'); Open Subsystem>

set_param('sm_excv_track1_roller_sphere/Track L/Undercarriage/Rollers/Roller Lower 1','LinkStatus','none')
open_system('sm_excv_track1_roller_sphere/Track L/Undercarriage/Rollers/Roller Lower 1','force')


%% Track Subsystem
%
% The track is modeled as a solid. It provides a visual indication of where
% the track segements would be.  It also includes mass and inertia
% properties which can be parameterized to match the full set of track
% segments.
%
% <matlab:open_system('sm_excv_track1_roller_sphere');open_system('sm_excv_track1_roller_sphere/Track%20L/Track','force'); Open Subsystem>

set_param('sm_excv_track1_roller_sphere/Track L/Track','LinkStatus','none')
open_system('sm_excv_track1_roller_sphere/Track L/Track','force')

%% Simulation Results: Flat Surface
%%
%
% Below are the simulation results from a test where the track is driven
% on a flat surface.  The terrain is defined using the 
% <https://www.mathworks.com/help/sm/ref/infiniteplane.html. The tracks are
% driven at different speeds so that the tracked vehicle can turn.
% Infinite Plane block>. 

Excv = sm_excv_track_param_machine;

set_param([bdroot '/Scene'],'LabelModeActiveChoice','Plane')
set_param(bdroot,'StopTime','16');

sim('sm_excv_track1_roller_sphere');

sm_excv_track_plot1loc(simlog_sm_excv_track1_roller_sphere,logsout_sm_excv_track1_roller_sphere);
sm_excv_track_plot2trq(simlog_sm_excv_track1_roller_sphere);

%% Simulation Results: Plateau
%%
%
% Below are the simulation results from a test where the track is driven
% on a plateau.  The terrain is defined using an extrusion, and the contact
% patches are moved into place below each roller and oriented based on the position of
% the location of the roller center.

Excv = sm_excv_track_param_machine;

set_param([bdroot '/Scene'],'LabelModeActiveChoice','Plateau')
set_param(bdroot,'StopTime','220');

sim('sm_excv_track1_roller_sphere');

sm_excv_track_plot1loc(simlog_sm_excv_track1_roller_sphere,logsout_sm_excv_track1_roller_sphere);
sm_excv_track_plot2trq(simlog_sm_excv_track1_roller_sphere);

%% Simulation Results: Rough Road
%%
%
% Below are the simulation results from a test where the track is driven
% on a rough road.  The terrain is defined using an extrusion, and the contact
% patches are moved into place below each roller and oriented based on the position of
% the location of the roller center.

Excv = sm_excv_track_param_machine;

set_param([bdroot '/Scene'],'LabelModeActiveChoice','Rough_Road')
set_param(bdroot,'StopTime','160');

sim('sm_excv_track1_roller_sphere');

sm_excv_track_plot1loc(simlog_sm_excv_track1_roller_sphere,logsout_sm_excv_track1_roller_sphere);
sm_excv_track_plot2trq(simlog_sm_excv_track1_roller_sphere);


%%

close all
bdclose('sm_excv_track1_roller_sphere');
