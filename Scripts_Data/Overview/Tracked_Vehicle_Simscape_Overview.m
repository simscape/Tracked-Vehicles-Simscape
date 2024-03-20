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
% *Chain Track Models*
%
% These models model a track as a segmented chain.  They can drive on
% uneven surfaces and capture the details of modeling each segment of the
% track as it contacts with the ground. A teeth on a sprocket push against
% pins in the chain to move the vehicle forward.
%
% <html>
% <table border=1><tr><td><img src="Tracked_Vehicle_Simscape_Overview_segTracks.png"></td><td><ul><b>-- Single Idler --</b><br><li>Single track, ground contact via point cloud on shoes. <a href="matlab:open_system('sm_excv_track1_ptcld');">Model</a>, <a href="matlab:web('sm_excv_track1_ptcld.html');">Doc</a></li><li>Two tracks, ground contact via point cloud on shoes. <a href="matlab:open_system('sm_excv_track2_ptcld');">Model</a>, <a href="matlab:web('sm_excv_track2_ptcld.html');">Doc</a></li><li>Single track, ground contact via brick solid. <a href="matlab:open_system('sm_excv_track1_solid');">Model</a>, <a href="matlab:web('sm_excv_track1_solid.html');">Doc</a></li><li>Single track, ground contact via point cloud, CAD shoe. <a href="matlab:open_system('sm_excv_track1_ptcld_shoecad');">Model</a>, <a href="matlab:web('sm_excv_track1_ptcld_shoecad.html');">Doc</a></li><br><b>-- Double Idler --</b><br><li>Single track, suspended above ground. <a href="matlab:open_system('sm_excv_trackI2R4_1_float');">Model</a>, <a href="matlab:web('sm_excv_trackI2R4_1_float.html');">Doc</a></li><li>Single track, ground contact via point cloud. <a href="matlab:open_system('sm_excv_trackI2R4_1_ptcld');">Model</a>, <a href="matlab:web('sm_excv_trackI2R4_1_ptcld.html');">Doc</a></li></ul></td></tr></table>
% </html>
%
% *Chain Track Test Examples*
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
% <<Tracked_Vehicle_Belts_Simscape_Overview.png>>
%
% *Segmented Belt Models*
%
% These models model a belt as a set of segments.  They can drive on
% uneven surfaces and capture the details of modeling each segment of the
% track as it contacts with the ground.  Spokes in a sprocket push against
% lugs in the belt to move the vehicle forward.
%
% <html>
% <table border=1><tr><td><img src="Tracked_Vehicle_Simscape_Overview_beltSeg.png"></td><td><ul><li>Single track, ground contact via point cloud on carcass.  <a href="matlab:open_system('sm_trackV_belt1_IdlerArm_i2u0r3_ptcld');">Model</a>, <a href="matlab:web('sm_trackV_belt1_IdlerArm_i2u0r3_ptcld.html');">Doc</a></li><li>Two tracks, ground contact via point cloud on carcass. <a href="matlab:open_system('sm_trackV_belt2_IdlerArm_i2u0r3_ptcld');">Model</a>, <a href="matlab:web('sm_trackV_belt2_IdlerArm_i2u0r3_ptcld.html');">Doc</a></li><li>Four tracks with Ackermann steering, ground contact via point cloud on carcass. <a href="matlab:open_system('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld');">Model</a>, <a href="matlab:web('sm_trackV_belt4_IdlerArm_i2u0r3_ptcld.html');">Doc</a></li></ul></td></tr></table>
% </html>
%
% *Roller Belt Models - Track Rolling on Point Clouds*
% 
% These models can drive on uneven surfaces and run very fast due to the
% abstract method of modeling the track drive. They are useful for refining
% requirements for the mechanical and powertrain system.
%
% <html>
% <table border=1><tr><td><img src="Tracked_Vehicle_Simscape_Overview_beltRoll.png"></td><td><ul><li>Single track, ground contact via point cloud cylinders. <a href="matlab:open_system('sm_trackV_roller1_IdlerArm_i2u0r3_ptcld');">Model</a>, <a href="matlab:web('sm_trackV_roller1_IdlerArm_i2u0r3_ptcld.html');">Doc</a></li><li>Two tracks, ground contact via point cloud cylinders. <a href="matlab:open_system('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld');">Model</a>, <a href="matlab:web('sm_trackV_roller2_IdlerArm_i2u0r3_ptcld.html');">Doc</a></li><li>Four tracks with Ackermann steering, ground contact via point cloud cylinders. <a href="matlab:open_system('sm_trackV_roller4_IdlerArm_i2u0r3_ptcld');">Model</a>, <a href="matlab:web('sm_trackV_roller4_IdlerArm_i2u0r3_ptcld.html');">Doc</a></li><li>Four tracks with articulated steering, ground contact via point cloud on carcass. <a href="matlab:open_system('sm_trackV_roller4_artic_IdlerArm_i2u0r3_ptcld');">Model</a>, <a href="matlab:web('sm_trackV_roller4_artic_IdlerArm_i2u0r3_ptcld.html');">Doc</a></li></ul></td></tr></table>
% </html>
%
% *Belt Track Test Examples*
% 
% <html>
% <table border=1><tr><td><img src="Tracked_Vehicle_Simscape_Overview_beltTest.png"></td><td><ul><li>Explore track segment models. <a href="matlab:open_system('sm_tVtest_belt_trackSeg');">Model</a>, <a href="matlab:web('sm_tVtest_belt_trackSeg.html');">Doc</a></li><li>Explore idler arm. <a href="matlab:open_system('sm_tVtest_belt_idlerArm');">Model</a>, <a href="matlab:web('sm_tVtest_belt_idlerArm.html');">Doc</a></li><li>Explore undercarriage. <a href="matlab:open_system('sm_tVtest_belt_IdlerArm_i2u0r3_underc');">Model</a>, <a href="matlab:web('sm_tVtest_belt_IdlerArm_i2u0r3_underc.html');">Doc</a></li><li>Explore contact between belt,sprocket, roller, and idler. <a href="matlab:open_system('sm_tVtest_belt_IdlerArm_i2u0r3_lowerframe');">Model</a>, <a href="matlab:web('sm_tVtest_belt_IdlerArm_i2u0r3_lowerframe.html');">Doc</a></li></ul></td></tr></table>
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
% *Chain Track* 
%
% # <matlab:web('sm_tracked_vehicle_doc_trackSegment.html')
% Chain Track, Track Segment>
% # <matlab:web('sm_tracked_vehicle_doc_trackFrame.html')
% Chain Track, Track Frame>
% # <matlab:web('sm_tracked_vehicle_doc_chassisSuspCyl.html')
% Chain Track, Chassis Suspension Cylinder>
%
% *Belt Track* 
%
% # <matlab:web('sm_tracked_vehicle_doc_beltSegment.html')
% Belt Segment>
% # <matlab:web('sm_tracked_vehicle_doc_beltRoller.html')
% Belt Track, Roller>
% # <matlab:web('sm_tracked_vehicle_doc_beltIdler.html')
% Belt Track, Idler>
% # <matlab:web('sm_tracked_vehicle_doc_beltIdlerArm.html')
% Belt Track, Idler Arm>
% # <matlab:web('sm_tracked_vehicle_doc_beltTensioner.html')
% Belt Track, Tensioner>
% # <matlab:web('sm_tracked_vehicle_doc_beltSprocket.html')
% Belt Track, Sprocket>
% # <matlab:web('sm_tracked_vehicle_doc_beltFrame_idlerArm_i2u0l3.html')
% Frame with 2 idlers, 3 rollers, and idler arm>
%
%
% *Chassis Models*
%
% # <matlab:web('sm_tracked_vehicle_doc_chassis.html')
% Excavator Chassis>
% # <matlab:web('sm_tracked_vehicle_doc_chassisArticulated.html')
% Articulated Chassis>


