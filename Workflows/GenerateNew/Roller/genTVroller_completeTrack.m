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
nRollL =  3;  % Number of Lower Rollers
nRollU =  2;  % Number of Upper Rollers

% Cannot be changed yet, needed for file names
nIdler = 1; % No effect on track yet

% Create busses - number of lower rollers + sprocket + idler
assignin('base',['CBO_Roller' num2str(nRollL+2)],...
    sm_excv_track_create_CBO('Roller',nRollL+2));

%assignin('base',['CBO_Chain' num2str(nSegs)],...
%    sm_excv_track_create_CBO('Chain',nSegs));

% Create Components: Frame, Rollers, Chain, Chain Contact
[newFrameFile,  newFrameSub]   = genTVroller_frame(nRollL,nRollU,nIdler);
[newUndercFile, newUndercSubs] = genTVroller_rollers(nRollL,nRollU,nIdler,newFrameFile,newFrameSub);

% Compose names of new components [file/subsystem]
newUnderc        = [newUndercFile          '/' newUndercSubs];

% Swap new components into new track library
[newTrackFile, newTrackSub]    = genTVroller_track(nRollL,newUnderc);

%% Minimum adjustments to default Excv parameter set to enable simulation
% May enable model to run, not tuned to a new design

% Lower roller longitudinal positions (ensure dimension is correct)
newLRPos = linspace(Excv.Frame.Sprk2LowerX(1),Excv.Frame.Sprk2LowerX(end),nRollL);
Excv.Frame.Sprk2LowerX = newLRPos;
% Upper roller longitudinal positions (ensure dimension is correct)
newURPos = linspace(Excv.Frame.Sprk2UpperX(1),Excv.Frame.Sprk2UpperX(end),nRollU);
Excv.Frame.Sprk2UpperX = newURPos;

%% Update terrain due to new number of segments
[newContactTerrainFile, newContactTerrainSub] = genTVroller_terrain(nRollL+2);

%% Test new track by swapping it in single track model
mdlname = 'sm_excv_track1_roller_ptcld';
open_system(mdlname)
filesuff  = ['GEN_r' num2str(nRollL+2)];
newTestModel = [mdlname '_' filesuff];
save_system(bdroot,newTestModel);

% Swap in track
set_param([bdroot '/Track L'],'ReferenceBlock',[newTrackFile '/' newTrackSub])

% Swap in Terrain
set_param([bdroot '/Scene/Grid Surface Terrain 1 Rollers'],...
    'ReferenceBlock',[newContactTerrainFile '/Grid Surface Terrain 1 Rollers']);
set_param([bdroot '/Scene/Road 1 Rollers'],...
    'ReferenceBlock',[newContactTerrainFile '/Road 1 Rollers']);
set_param([bdroot '/Scene/Grid Surface Slope 1 Rollers'],...
    'ReferenceBlock',[newContactTerrainFile '/Grid Surface Slope 1 Rollers']);

% Test model
%sim(bdroot)
%}