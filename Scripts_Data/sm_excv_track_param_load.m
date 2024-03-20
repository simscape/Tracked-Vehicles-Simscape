%% Load machine parameters
Excv = sm_excv_track_param_machine;
ExcvI2R4 = sm_excv_track_param_machine_2Idler4Roller;

%% Additional parameters for CAD-based shoe geometry
[temp_ptcld_grousers, temp_ptcld_plate, temp_ptcld_profile] = track_shoe_ptcloud_createFromSTL('CAD_Track_Shoe.STL');

Excv.Shoe.ptcld_sets.cad_grousers = temp_ptcld_grousers;
Excv.Shoe.ptcld_sets.cad_plate    = temp_ptcld_plate;
Excv.Shoe.ptcld_sets.cad_profile  = temp_ptcld_profile;
clear temp_ptcld_grousers temp_ptcld_plate temp_ptcld_profile

%% Bus for contact connections
%load('Excv_Contact_ConnBusObj.mat');

CBO_Chain46 = sm_excv_track_create_CBO('Chain',46);
CBO_Roller9 = sm_excv_track_create_CBO('Roller',9);
CBO_Road8   = sm_excv_track_create_CBO('Road',8);

CBO_Roller4 = sm_excv_track_create_CBO('Roller',4);
CBO_Roller5 = sm_excv_track_create_CBO('Roller',5);

%% Load scene parameters
sm_excv_track_param_scene