%% Script to generate a new chain track from template libraries

% This script takes provided library files for chain tracks and modifies
% them to have a requested number of upper rollers, lower rollers and chain
% segments.  The minimum number of changes to the default parameters are
% made so that the produced test model can run.  The new model will likely
% need further adjustments to its parameters.

% Load default parameters just in case
sm_excv_track_param_load
sm_trackV_belt_param_load

% Inputs - can be changed
nRollL =  6;  % Number of Lower Rollers
nRollU =  4;  % Number of Upper Rollers
nSegs  = 47; % Number of Segments

% Cannot be changed yet, needed for file names
nIdler = 1; % No effect on track yet

% Create busses
assignin('base',['CBO_Roller' num2str(nRollL+nRollU)],...
    sm_excv_track_create_CBO('Roller',nRollL+nRollU));
assignin('base',['CBO_Chain' num2str(nSegs)],...
    sm_excv_track_create_CBO('Chain',nSegs));

% Create Components: Frame, Rollers, Chain, Chain Contact
[newFrameFile,  newFrameSub]   = genTVchain_frame(nRollL,nRollU,nIdler);
[newUndercFile, newUndercSubs] = genTVchain_rollers(nRollL,nRollU,nIdler,newFrameFile,newFrameSub);
[newChainFile,  newChainSubs]  = genTVchain_chain(nSegs);
[newChainElemFile, newChain2ElemSub_list] = genTVchain_chain2element(nSegs);

% Name of subsystem for chain to one roller contact
newRollerSetRefBlock = [newChainElemFile '/' newChain2ElemSub_list{3}];

% Create Components: Contact between chain and all rollers
[newChain2RollerSetFile, newChain2RollerSetSub] = genTVchain_chain2rollerset(nSegs,(nRollL+nRollU),newRollerSetRefBlock);

% Compose names of new components [file/subsystem]
newUnderc        = [newUndercFile          '/' newUndercSubs];
newChain         = [newChainFile           '/' newChainSubs];
newChainIdler    = [newChainElemFile       '/' newChain2ElemSub_list{1}];
newChainSprocket = [newChainElemFile       '/' newChain2ElemSub_list{2}];
newChainRoller   = [newChain2RollerSetFile '/' newChain2RollerSetSub];

% Swap new components into new track library
[newTrackFile, newTrackSub]    = genTVchain_track(nSegs,nIdler,nRollL,nRollU,...
    newUnderc,newChain,newChainIdler,newChainSprocket,newChainRoller);

%% Minimum adjustments to default Excv parameter set to enable simulation
% May enable model to run, not tuned to a new design

% Lower roller longitudinal positions (ensure dimension is correct)
newLRPos = linspace(Excv.Frame.Sprk2LowerX(1),Excv.Frame.Sprk2LowerX(end),nRollL);
Excv.Frame.Sprk2LowerX = newLRPos;
% Upper roller longitudinal positions (ensure dimension is correct)
newURPos = linspace(Excv.Frame.Sprk2UpperX(1),Excv.Frame.Sprk2UpperX(end),nRollU);
Excv.Frame.Sprk2UpperX = newURPos;

% Retract tensioner cylinder just to ensure chain surrounds it
default_Tensionerx0 = Excv.Idler.Tensioner.x0; % Save default value
Excv.Idler.Tensioner.x0 = -2; % Initial extension of cylinder

%% Obtain new set of joint targets for new track
% Open test harness model, swap in new track
mdlgenTargets = 'test_newTrack_jntTgts';
open_system(mdlgenTargets)
set_param([bdroot '/Track'],'ReferenceBlock',[newTrackFile '/' newTrackSub]);
filesuff  = ['GEN_i' num2str(nIdler) 'u' num2str(nRollU) 'l' num2str(nRollL)];
newMdlGenTargets = ['test_newTrack_jntTgts_' filesuff];
save_system(bdroot,newMdlGenTargets);

% Create rough set of targets that hopefully surrounds rollers, idler
track_joint_targets = sm_excv_track_segTargets_forAsy(Excv.Chain.pin_sep, Excv.Sprocket.sprocket_rPitch,nSegs);

% Simulate with rough targets
% Model holds sprocket still until chain settles
sim(newMdlGenTargets)

% Extract track segment joint targets, tensioner initial position
% from simulation results
[track_joint_targets,tensioner_x0] = genTVchain_targets(simlog_getChainJointTargets);
Excv.Idler.Tensioner.x0 = tensioner_x0;

% Test new set of joint targets
sim(newMdlGenTargets)
bdclose(newMdlGenTargets)

%% Update terrain due to new number of segments
[newContactTerrainFile, newContactTerrainSub] = genTVtrack_terrain(nSegs);

%% Test new track by swapping it in single track model
mdlname = 'sm_excv_track1_ptcld';
open_system(mdlname)
filesuff  = ['GEN_i' num2str(nIdler) 'u' num2str(nRollU) 'l' num2str(nRollL)];
newTestModel = [mdlname '_' filesuff];
save_system(bdroot,newTestModel);

% Swap in track
set_param([bdroot '/Track L'],'ReferenceBlock',[newTrackFile '/' newTrackSub])

% Swap in Terrain
set_param([bdroot '/Scene/Grid Surface Terrain 1 Track'],...
    'ReferenceBlock',[newContactTerrainFile '/Grid Surface Terrain 1 Track']);
set_param([bdroot '/Scene/Road 1 Track'],...
    'ReferenceBlock',[newContactTerrainFile '/Road 1 Track']);
set_param([bdroot '/Scene/Grid Surface Slope 1 Track'],...
    'ReferenceBlock',[newContactTerrainFile '/Grid Surface Slope 1 Track']);

% Test model
%sim(bdroot)