function [newTrackFile, newTrackSub] = genTVroller_track(nRollL,newUnderc)
%% Source files: Copy to new location and modify
refTrackFile = 'sm_rollerV_lib_lower_frame_r9';
% Reference subsystem to be modified
refTrackSub = sprintf('Roller Contact Point Cloud');

% Save Contacts under new name
[d, f, e] = fileparts(which(refTrackFile));
us_ind    = strfind(f,'_');
filesuff  = ['GEN_r' num2str(nRollL+2)];
newTrackFile = [f(1:us_ind(end)) filesuff];
copyfile(which(refTrackFile),[d filesep newTrackFile e])

% Open new frame file
load_system(newTrackFile)
set_param(newTrackFile,'Lock','off')

% Rename subsystem with new number of segments, rollers
dpat = extract(refTrackSub,digitsPattern);
newTrackSub = [refTrackSub '_' filesuff];
set_param([newTrackFile '/' refTrackSub],'Name',newTrackSub);

% Get handle of new subsystem
bh_tr = Simulink.findBlocks(newTrackFile,'Name',newTrackSub);

% Delete other subsystems
f = Simulink.FindOptions('RegExp',true,'SearchDepth',1);
bh_all = Simulink.findBlocks(newTrackFile,f);
bh_del = setdiff(bh_all,bh_tr);
delete_block(bh_del)

%% Replace subsystems
%set_param([newTrackFile '/' newTrackSub '/CF Chain Sprocket'],...
%    'ReferenceBlock',newChainSprocket)
%set_param([newTrackFile '/' newTrackSub '/CF Chain Rollers'],...
%    'ReferenceBlock',newChainRoller)
%set_param([newTrackFile '/' newTrackSub '/CF Chain Idler'],...
%    'ReferenceBlock',newChainIdler)
set_param([newTrackFile '/' newTrackSub '/Undercarriage'],...
    'ReferenceBlock',newUnderc)
%set_param([newTrackFile '/' newTrackSub '/Track'],...
%    'ReferenceBlock',newChain)

%% Save file
save_system(newTrackFile)
bdclose(newTrackFile)
end