%% Tracked Vehicle Model with Simscape(TM)
%
% <<Tracked_Vehicle_Simscape_Overview.png>>
% 
% This repository contains models and code to help engineers model and
% simulate tracked vehicles.
%
% * *Fully parameterized models* of tracked and multi-axle vehicles
% * *Detailed and abstract variants* for efficient testing of different systems
% * *Modular library elements* enable assembly of parameterized tracked vehicles. 
% * *Customizable contact force definition* enable models tailored to simulation task.
% * *MATLAB code* enables automation of modeling, simulation, and post-procesing tasks.
%
% *Segmented Track Models*
%
% These models can drive on uneven surfaces and capture the details of
% modeling each segment of the track as it contacts with the ground.
%
% <html>
% <table border=1><tr><td><img src="Tracked_Vehicle_Simscape_Overview_segTracks.png"></td><td><ul><li>Single track, ground contact via point cloud on shoes. <a href="matlab:open_system('sm_excv_track1_ptcld');">Model</a>, <a href="matlab:web('sm_excv_track1_ptcld.html');">Doc</a></li><li>Two tracks, ground contact via point cloud on shoes. <a href="matlab:open_system('sm_excv_track2_ptcld');">Model</a>, <a href="matlab:web('sm_excv_track2_ptcld.html');">Doc</a></li><li>Single track, ground contact via brick solid. <a href="matlab:open_system('sm_excv_track1_solid');">Model</a>, <a href="matlab:web('sm_excv_track1_solid.html');">Doc</a></li><li>Single track, ground contact via point cloud, CAD shoe. <a href="matlab:open_system('sm_excv_track1_ptcld_shoecad');">Model</a>, <a href="matlab:web('sm_excv_track1_ptcld_shoecad.html');">Doc</a></li></ul></td></tr></table>
% </html>
%
% *Segmented Track Test Examples*
% 
% <html>
% <table border=1><tr><td><img src="Tracked_Vehicle_Simscape_Overview_trackTest.png"></td><td><ul><li>Explore track segment models. <a href="matlab:open_system('sm_excv_track_segment_test');">Model</a>, <a href="matlab:web('sm_excv_track_segment_test.html');">Doc</a></li><li>Explore chain and sprocket contacts. <a href="matlab:open_system('sm_excv_track1_sprocket');">Model</a>, <a href="matlab:web('sm_excv_track1_sprocket.html');">Doc</a></li><li>Explore contact between chain, roller, and idler. <a href="matlab:open_system('sm_excv_track1_float');">Model</a>, <a href="matlab:web('sm_excv_track1_float.html');">Doc</a></li></ul></td></tr></table>
% </html>
%
% *Rollers - Track Rolling on Point Clouds*
% 
% These models can drive on uneven surfaces and run very fast due to the
% abstract method of modeling the track drive. They are useful for refining
% requirements for the mechanical and powertrain system.
%
% <html>
% <table border=1><tr><td><img src="Tracked_Vehicle_Simscape_Overview_rollers.png"></td><td><ul><li>Single track, ground contact via point cloud cylinders. <a href="matlab:open_system('sm_excv_track1_roller_ptcld');">Model</a>, <a href="matlab:web('sm_excv_track1_roller_ptcld.html');">Doc</a></li><li>Two tracks, ground contact via point cloud cylinders. <a href="matlab:open_system('sm_excv_track2_roller_ptcld');">Model</a>, <a href="matlab:web('sm_excv_track2_roller_ptcld.html');">Doc</a></li></ul></td></tr></table>
% </html>
%
% *Spheres - Track Rolling on Spheres*
%
% These models can drive on flat and uneven surfaces.
% This model simulates extremely fast due to the simple nature of the track
% drive.  They are useful for testing driver commands and gathering
% powertrain requirements.
%
% <html>
% <table border=1><tr><td><img src="Tracked_Vehicle_Simscape_Overview_spheres.png"></td><td><ul><li>Single track, track contact geometry is spheres. <a href="matlab:open_system('sm_excv_track1_roller_sphere');">Model</a>, <a href="matlab:web('sm_excv_track1_roller_sphere.html');">Doc</a></li><li>Two tracks, track contact geometry is spheres. <a href="matlab:open_system('sm_excv_track2_roller_sphere');">Model</a>, <a href="matlab:web('sm_excv_track2_roller_sphere.html');">Doc</a></li></ul></td></tr></table>
% </html>
%
% *Workflows*
%
% # <matlab:web('ptcloud_workflow_trackShoe_createFromSTL.html')
% Extracting Point Cloud from STL Geometry: Track Shoe>
% # <matlab:web('ptcloud_workflow_trackShoe_createFromSTEP.html')
% Extracting Point Cloud from STEP Geometry: Track Shoe>
%
% *Documentation*
%
% # <matlab:web('sm_tracked_vehicle_doc_trackSegment.html')
% Tracked Vehicle Documentation, Track Segment>

