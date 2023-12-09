% Load machine parameters
Excv = sm_excv_track_param_machine;

% Additional parameters for CAD-based shoe geometry
[temp_ptcld_grousers, temp_ptcld_plate, temp_ptcld_profile] = track_shoe_ptcloud_createFromSTL('CAD_Track_Shoe.STL');

Excv.Shoe.ptcld_sets.cad_grousers = temp_ptcld_grousers;
Excv.Shoe.ptcld_sets.cad_plate    = temp_ptcld_plate;
Excv.Shoe.ptcld_sets.cad_profile  = temp_ptcld_profile;
clear temp_ptcld_grousers temp_ptcld_plate temp_ptcld_profile

%% Bus for contact connections
load('Excv_Contact_ConnBusObj.mat');

%% Load scene parameters
sm_excv_track_param_scene