% Load machine parameters
Excv = sm_excv_track_param_machine;

% Additional parameters for CAD-based shoe geometry
[temp_ptcld_grousers, temp_ptcld_plate] = track_shoe_ptcloud_createFromSTL('CAD_Track_Shoe.STL');

Excv.Shoe.ptcld_sets.cad_grousers = temp_ptcld_grousers;
Excv.Shoe.ptcld_sets.cad_plate = temp_ptcld_plate;
clear temp_ptcld_grousers temp_ptcld_plate

%% Bus for contact connections
load('Excv_Contact_ConnBusObj.mat');

%% Load scene parameters
sm_excv_track_param_scene