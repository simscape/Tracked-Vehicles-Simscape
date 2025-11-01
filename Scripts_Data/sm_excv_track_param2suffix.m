function [suffixStr, suffixVals] = sm_excv_track_param2suffix(Excv,mdl)
%sm_excv_track_param2suffix  Create file name suffix based on track components.
%   [suffixStr, suffixVals] = sm_excv_track_param2suffix(Excv,mdl)
%   This function returns a string and a set of numbers that describe the
%   structure of a track.  Its purpose is to provide a unique suffix for filenames
%   that are associated with a specific track structure.
%
%      Excv     Data structure with track parameters
%      mdl      Name of model with the track as subsystem "Track"
%
%   The function returns
%
%      suffixStr    String with number of segments, idlers, upper and lower rollers
%      suffixVals   Structure listing number of each component

% Copyright 2024-2025 The MathWorks, Inc.

ExcvFields = fieldnames(Excv);
ExcvFields = setdiff(ExcvFields,'IdlerArm');
nIdler = length(find(startsWith(ExcvFields,'Idler')));
if(isfield(Excv.Frame,'Sprk2UpperX'))
    nRollU = length(Excv.Frame.Sprk2UpperX);
else
    nRollU = 0;
end
if(isfield(Excv.Frame,'Sprk2LowerX'))
    nRollL = length(Excv.Frame.Sprk2LowerX);
else
    nRollL = 0;
end

load_system(mdl);
f = Simulink.FindOptions('RegExp',true,'SearchDepth',1);
nSegs = length(Simulink.findBlocks([bdroot '/Track/Track'],'BlockType','SubSystem','Name','Seg.*',f));

suffixStr = ['seg' num2str(nSegs) 'i' num2str(nIdler) 'u' num2str(nRollU) 'l' num2str(nRollL)];

suffixVals.nIdler = nIdler;
suffixVals.nRollU = nRollU;
suffixVals.nRollL = nRollL;
suffixVals.nSegs  = nSegs;