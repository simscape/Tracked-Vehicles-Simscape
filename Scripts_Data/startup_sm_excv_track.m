% Load parameters
sm_excv_track_param_load

% Adjust Undercarriage Library
warning('off','Simulink:Data:EditTimeResolveInUninitializedMaskWS')
load_system('sm_excv_underc_lib.slx')
set_param(bdroot, 'Lock', 'off')
f = Simulink.FindOptions('SearchDepth',1);
bh = Simulink.findBlocks(bdroot,f);
for i = 1:length(bh)
    set_param(getfullname(bh(i)),'popup_sense_roller','Constraint Force');
    set_param(getfullname(bh(i)),'popup_sense_roller','Actuator Torque');
end
warning('on','Simulink:Data:EditTimeResolveInUninitializedMaskWS')

% Open Overview
web('Tracked_Vehicle_Simscape_Overview.html')

% Open model
open_system('sm_excv_track1_ptcld');

