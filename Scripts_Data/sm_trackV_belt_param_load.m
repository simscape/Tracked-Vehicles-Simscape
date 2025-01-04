%% Load machine parameters
Trac = sm_trackV_belt_param_machine_seg45i2u0r3_IdlerArm;
sprk_pitch_rad = Trac.Sprocket.Spoke.pitch_rad + Trac.Sprocket.Spoke.rad+Trac.Belt.pad_h+0.01;
trackV_joint_targets_seg45i2u0l3;
Trac.IdlerF.Tensioner.x0 = tensioner_x0;
clear tensioner_x0
%[track_seg_tgts_seg45i2u0r3, qSegSpr_seg45i2u0r3]= sm_trackV_belt_segTargets_seg45i2u0r3_IdlerArm(Trac.Belt.l, sprk_pitch_rad);

%% Colors
trac9x.clr.blk = [0.20 0.20 0.20];
trac9x.clr.ylw = [0.99 0.87 0.00];
trac9x.clr.grn = [0.21 0.48 0.17];
trac9x.clr.red = [1.00 0.00 0.00];
trac9x.clr.wht = [1.00 1.00 1.00];
trac9x.clr.org = [1.00 0.60 0.00];
trac9x.opc.win = 0.5;
trac9x.opc.lens = 0.5;

%% Bus for contact connections

[CBO_TrSpr, CBO_TrRoll] = sm_trackV_rubber_create_CBO(45);
CBO_Seg45 = sm_excv_track_create_CBO('Chain',45);

%% Load scene parameters
