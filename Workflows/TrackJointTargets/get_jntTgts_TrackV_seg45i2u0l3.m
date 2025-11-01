%% Generate Joint Targets for Belt Track (45 segments, 0 upper, 3 lower)
%
% This code generates a MATLAB script to specify the joint targets for a
% segmented belt track.  Joint targets are necessary to help guide the
% assembly of the model so that the belt meshes with the sprocket and goes
% around all of the rollers and idlers. 
% 
% A preliminary set of joint targets enables the belt to assemble in a
% test harness model where the sprocket is held in a fixed position.  A
% short simulation is run and the final joint angles are saved to create
% the final set of joint targets.
%
% The code used to generate the track joint targets is here:
% <matlab:edit('get_jntTgts_TrackV_seg45i2u0l3.m'); get_jntTgts_TrackV_seg45i2u0l3.m>. 
% It can be adapted for models that have a different track configuration
%
% (<matlab:web('Tracked_Vehicle_Simscape_Overview.html') return to Tracked Vehicle Model with Simscape Overview>) 
%
% Copyright 2023-2025 The MathWorks, Inc. 

%% Open and Configure Test Harness Model 
%
% A test harness model is provided that holds the sprocket in a fixed
% position.  We swap in the track model for which we want to obtain a set
% of joint targets.

% Load parameter structure and corresponding library block for track
Trac = sm_trackV_belt_param_machine_seg45i2u0r3_IdlerArm;
sprk_pitch_rad = Trac.Sprocket.Spoke.pitch_rad + Trac.Sprocket.Spoke.rad+Trac.Belt.pad_h+0.01;
trackLibraryMdl   = 'sm_trackV_lib_belt_lower_frame_s45i2u0l3';
trackLibraryBlock = [trackLibraryMdl '/Track Contact Point Cloud'];
load_system(trackLibraryMdl)

% Retract tensioner cylinder just to ensure belt surrounds it
default_Tensionerx0 = Trac.IdlerF.Tensioner.x0; % Save default value
Trac.IdlerF.Tensioner.x0 = 0; % Initial extension of cylinder

%% Obtain new set of joint targets for new track
% Open test harness model, swap in new track
mdlgenTargets = 'get_jntTgts_Track';
open_system(mdlgenTargets)
replace_block(bdroot,'Name','Track',trackLibraryBlock,'noprompt')
[suffixStr,suffixVals] = sm_excv_trackV_param2suffix(Trac,bdroot);

newMdlGenTargets = [mdlgenTargets '_TESTTrackV_' suffixStr];
save_system(bdroot,newMdlGenTargets);


%% Define Preliminary Set of Joint Targets
%
% For the initial assembly, we need a set of joint targets that will enable
% the track to surround the sprocket, rollers, and idlers.  The idler is
% fully retracted and a MATLAB script is used to create a preliminary set
% of targets that surrounds the components.  This is good enough to get the
% model to assemble, but it would be a poor set of joint targets for
% simulation tests as the initial transient would be very harsh.

%%
% 
% <<get_jntTgts_TrackV_seg45i2u0l3_mechExp_prelim.png>>
% 

% Retract tensioner cylinder just to ensure belt surrounds it
default_Tensionerx0 = Excv.Idler.Tensioner.x0; % Save default value
Excv.Idler.Tensioner.x0 = -2; % Initial extension of cylinder

% Create rough set of targets that hopefully surrounds rollers, idler
[track_seg_tgts_seg45i2u0r3, qSegSpr_seg45i2u0r3]= sm_trackV_belt_segTargets_seg45i2u0r3_IdlerArm(Trac.Belt.l, sprk_pitch_rad);

%% Simulate with Preliminary Targets
%
% A simulation is run to let the belt settle. MATLAB is used to extract
% the final positions of the joints in the segmented track. 

%%
% 
% <<get_jntTgts_TrackV_seg45i2u0l3_mechExp_final.png>>
% 

% Model holds sprocket still until belt settles
sim(newMdlGenTargets)

% Extract track segment joint targets, tensioner initial position
% from simulation results
[track_seg_tgts_seg45i2u0r3,tensioner_x0] = genTVchain_targets(simlog_getChainJointTargets);
Trac.IdlerF.Tensioner.x0 = tensioner_x0;

trackSegTgtFilename = ['trackV_joint_targets_' suffixStr '.m'];
    
matlab.io.saveVariablesToScript(trackSegTgtFilename,{'track_seg_tgts_seg45i2u0r3','qSegSpr_seg45i2u0r3','tensioner_x0'});

track_seg_tgts_seg45i2u0r3