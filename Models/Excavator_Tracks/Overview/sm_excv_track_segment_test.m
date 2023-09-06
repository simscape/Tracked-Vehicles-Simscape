%% Excavator Track Segment Test
% 
% <<sm_excv_track_segment_test_Overview.png>>
%
% (<matlab:web('Tracked_Vehicle_Simscape_Overview.html') return to Tracked Vehicle Model with Simscape Overview>)
%
% This example shows track segments with different ground contact geometry.
% Point cloud and brick solid are integrated into the track segment and
% enable different methods of modeling the ground
%
% Copyright 2023 The MathWorks, Inc.

%% Model
%
% In this example, three pairs of track segments are shown.  The mask
% parameters are set different from the default values to highlight the
% contact geometry.
%
% <matlab:open_system('sm_excv_track_segment_test'); Open Model>

open_system('sm_excv_track_segment_test')

set_param(find_system('sm_excv_track_segment_test','FindAll', 'on','type','annotation','Tag','ModelFeatures'),'Interpreter','off')

%% Track Segment Point Cloud
%
% Each track segment is composed of a chain link and a shoe. To streamline
% the contact force calculation, simpler geometry is connected to the
% Spatial Contact Force block.  
%
% # A sphere is used to model the pin contacting the sprocket.
% # A brick is used to model the chain contacting the rollers and idler 
% # A point cloud is used to model the shoe plate contacting the ground.
% This enables the ground to be modeled using the grid surfaceblock.
%
% <<sm_excv_contact_trackSeg_PtcldAll_Overview.png>>
%
% <matlab:open_system('sm_excv_track_segment_test');open_system('sm_excv_track_segment_test/Track%20Segment%20Point%20Cloud%20All1','force'); Open Subsystem>

set_param('sm_excv_track_segment_test/Track Segment Point Cloud All1','LinkStatus','none')
open_system('sm_excv_track_segment_test/Track Segment Point Cloud All1','force')

%% Track Segment Plate Solid
%
% Each track segment is composed of a chain link and a shoe. To streamline
% the contact force calculation, simpler geometry is connected to the
% Spatial Contact Force block.  
%
% # A sphere is used to model the pin contacting the sprocket.
% # A brick is used to model the chain contacting the rollers and idler 
% # A brick solid is used to model contact with the ground.  This permits
% the ground to be modeled using a Point Cloud with a set of arbitrary
% points.
%
% <<sm_excv_contact_trackSeg_PlSld_Overview.png>>
%
% <matlab:open_system('sm_excv_track_segment_test');open_system('sm_excv_track_segment_test/Track%20Segment%20Plate%20Solid1','force'); Open Subsystem>

set_param('sm_excv_track_segment_test/Track Segment Plate Solid1','LinkStatus','none')
open_system('sm_excv_track_segment_test/Track Segment Plate Solid1','force')

%%

close all
bdclose('sm_excv_track_segment_test');
