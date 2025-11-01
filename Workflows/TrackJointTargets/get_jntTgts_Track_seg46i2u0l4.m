%% Generate Joint Targets for Chain Track (46 segments, 2 idler, 4 lower)
%
% This code generates a MATLAB script to specify the joint targets for a
% segmented chain track.  Joint targets are necessary to help guide the
% assembly of the model so that the chain meshes with the sprocket and goes
% around all of the rollers and idlers. 
% 
% A preliminary set of joint targets enables the chain to assemble in a
% test harness model where the sprocket is held in a fixed position.  A
% short simulation is run and the final joint angles are saved to create
% the final set of joint targets.
%
% The code used to generate the track joint targets is here:
% <matlab:edit('get_jntTgts_Track_seg46i2u0l4.m'); get_jntTgts_Track_seg46i2u0l4.m>. 
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
ExcvI2R4 = sm_excv_track_param_machine_2Idler4Roller;
trackLibraryMdl   = 'sm_trackV_lib_chain_lower_frame_s46i2u0l4';
trackLibraryBlock = [trackLibraryMdl '/Track Contact Point Cloud'];
load_system(trackLibraryMdl)

% Open test harness model, swap in new track
mdlgenTargets = 'get_jntTgts_Track';
open_system(mdlgenTargets)
replace_block(bdroot,'Name','Track',trackLibraryBlock,'noprompt')
[suffixStr,suffixVals] = sm_excv_track_param2suffix(ExcvI2R4,bdroot);

newMdlGenTargets = [mdlgenTargets '_TEST_' suffixStr];
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
% <<get_jntTgts_Track_seg46i2u0l4_mechExp_prelim.png>>
% 

% Retract tensioner cylinder just to ensure chain surrounds it
default_Tensionerx0 = ExcvI2R4.IdlerF.Tensioner.x0; % Save default value
ExcvI2R4.Idler.Tensioner.x0 = -2; % Initial extension of cylinder

% Create rough set of targets that hopefully surrounds rollers, idler
track_joint_targetsC46I2 = sm_excv_track_segTargets_46seg2Idler(ExcvI2R4.Chain.pin_sep, ExcvI2R4.Sprocket.sprocket_rPitch);

%% Simulate with Preliminary Targets
%
% A simulation is run to let the chain settle. MATLAB is used to extract
% the final positions of the joints in the segmented track. 

%%
% 
% <<get_jntTgts_Track_seg46i2u0l4_mechExp_final.png>>
% 

% Model holds sprocket still until chain settles
sim(newMdlGenTargets)

% Extract track segment joint targets, tensioner initial position
% from simulation results
[track_joint_targetsC46I2,tensioner_x0] = genTVchain_targets(simlog_getChainJointTargets);
Excv.Idler.Tensioner.x0 = tensioner_x0;

trackSegTgtFilename = ['track_joint_targets_' suffixStr '.m'];
    
matlab.io.saveVariablesToScript(trackSegTgtFilename,{'track_joint_targetsC46I2','tensioner_x0'});

track_joint_targetsC46I2