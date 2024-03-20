%% Belt Segment Test
% 
% <<sm_tVtest_belt_trackSeg_Overview.png>>
%
% (<matlab:web('Tracked_Vehicle_Simscape_Overview.html') return to Tracked Vehicle Model with Simscape Overview>)
%
% This example shows belt segments with different contact geometry.
%
% Copyright 2023-2024 The MathWorks, Inc.

%% Model
%
% In this example a sprocket, idler, roller, and three belt segments are
% shown.  Contact is modeled between the belt and the sprocket.
%
% <matlab:open_system('sm_tVtest_belt_trackSeg'); Open Model>

open_system('sm_tVtest_belt_trackSeg')

set_param(find_system('sm_tVtest_belt_trackSeg','FindAll', 'on','type','annotation','Tag','ModelFeatures'),'Interpreter','off')

%% Belt Segment Point Cloud
%
% Each track segment is composed of the carcass and the lug. To streamline
% the contact force calculation, simpler geometry is connected to the
% Planar Contact Force block and Spatial Contact Force block.
%
% # Line geometry is used to model the lug contacting the sprocket.
% # Line geometry is used to model carcass contacting the rollers, idler, and sprocket.
% # Point Cloud geometry is used to model the belt contacting the ground.
% This enables the ground to be modeled using the grid surface block.
%
% <<sm_belt_contact_trackSeg_Ptcld_Line_Overview.png>>
%
% <matlab:open_system('sm_tVtest_belt_trackSeg');open_system('sm_tVtest_belt_trackSeg/CF%20Roller%20Carcass%2001','force'); Open Subsystem>

set_param('sm_tVtest_belt_trackSeg/CF Roller Carcass 01','LinkStatus','none')
open_system('sm_tVtest_belt_trackSeg/CF Roller Carcass 01','force')

%% Sprocket
%
% The sprocket has spokes which press against the belt lugs. The edges of
% the sprocket press against the belt carcass. To streamline the contact
% force calculation, simpler geometry is connected to the Planar Contact
% Force block.
%
% 1. Disk geometry is used to model the sprocket contacting the carcass.
%
% <<sm_belt_contact_sprocketToCarcass_Overview.png>>
%
% 2. Disk geometry is used to model contact between each spoke and the lugs 
%
% <<sm_belt_contact_sprocketToLugs_Overview.png>>
%
% <matlab:open_system('sm_tVtest_belt_trackSeg');open_system('sm_tVtest_belt_trackSeg/Sprocket','force'); Open Subsystem>

set_param('sm_tVtest_belt_trackSeg/Sprocket','LinkStatus','none')
open_system('sm_tVtest_belt_trackSeg/Sprocket','force')

%% Idler
%
% The edges of the idler press against the belt carcass. To streamline the
% contact force calculation, simpler geometry is connected to the Planar
% Contact Force block.
%
% # Disk geometry is used to model the idler contacting the carcass.
%
% <<sm_belt_contact_rollerToCarcass_Overview.png>>
%
% <matlab:open_system('sm_tVtest_belt_trackSeg');open_system('sm_tVtest_belt_trackSeg/Idler%20Rear','force'); Open Subsystem>

set_param('sm_tVtest_belt_trackSeg/Idler Rear','LinkStatus','none')
open_system('sm_tVtest_belt_trackSeg/Idler Rear','force')


%%

close all
bdclose('sm_tVtest_belt_trackSeg');
