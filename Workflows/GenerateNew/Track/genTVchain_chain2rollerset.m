function [newChain2RollerSetFile, newChain2RollerSetSub] = genTVchain_chain2rollerset(nSegs,nRollers,rollerSetRefBlock)

%% Source files: Copy to new location and modify
refChain2RollerSetFile = 'sm_trackV_lib_chain_contact_s46r9';
% Reference subsystem to be modified
refChain2RollerSetSub = sprintf('CF Chain46\nRollers9');

% Save Contacts under new name
[d, f, e] = fileparts(which(refChain2RollerSetFile));
us_ind    = strfind(f,'_');
filesuff  = ['GEN_s' num2str(nSegs) 'r' num2str(nRollers)];
newChain2RollerSetFile = [f(1:us_ind(end)) filesuff];
copyfile(which(refChain2RollerSetFile),[d filesep newChain2RollerSetFile e])

% Open new frame file
load_system(newChain2RollerSetFile)
set_param(newChain2RollerSetFile,'Lock','off')

% Rename subsystem with new number of segments, rollers
dpat = extract(refChain2RollerSetSub,digitsPattern);
newChain2RollerSetSubC = strrep(refChain2RollerSetSub,dpat{1},num2str(nSegs));
newChain2RollerSetSub = strrep(newChain2RollerSetSubC,dpat{2},num2str(nRollers));
set_param([newChain2RollerSetFile '/' refChain2RollerSetSub],'Name',newChain2RollerSetSub)

% 1. Delete all lines connected to contact force elements
% 2. Delete all contact force elements except "CF Chain Roller R1"
f = Simulink.FindOptions('RegExp',true,'SearchDepth',1);
bh_CF = Simulink.findBlocks([newChain2RollerSetFile '/' newChain2RollerSetSub],'Name',['CF Chain Roller Full R#*'],f);

% Loop over all contact force elements
for i = 1:length(bh_CF)

    % Delete connection lines
    line_h = get_param(bh_CF(i),'LineHandles');
    delete_line(line_h.LConn)
    delete_line(line_h.RConn)

    % Do not delete first contact force element
    % Will do copy/paste to create the rest
    dpat = extract(get_param(bh_CF(i),'Name'),digitsPattern);
    if(~(str2double(dpat{end})==1))
        delete_block(bh_CF(i))
    end
end

%% Reset Simscape Bus Block
bh_ssbu = Simulink.findBlocks([newChain2RollerSetFile '/' newChain2RollerSetSub],'BlockType','SimscapeBus');

% Clear port strings, assign bus object
set_param(bh_ssbu,'HierarchyStrings','');
set_param(bh_ssbu,'ConnectionType',['Bus: CBO_Roller' num2str(nRollers)])
ph_ssbu = get_param(bh_ssbu,'PortHandles');

% Resize Simscape Bus block based on number of ports
pos_ssbu   = get_param(bh_ssbu,'Position');
ssbu_py(i) = pos_ssbu(2); %#ok<AGROW>
pos_ssbu_new    = pos_ssbu;
pos_ssbu_new(4) = pos_ssbu(2)+45*nRollers;
set_param(bh_ssbu,'Position',pos_ssbu_new+[0 5 0 5]);

%% Connect contact force elements to Port and Bus
% Get port handles to Connection Port Ch
bh_cpb = Simulink.findBlocks([newChain2RollerSetFile '/' newChain2RollerSetSub],'BlockType','PMIOPort','Name','Ch');
ph_cpb = get_param(bh_cpb,'PortHandles');

%% Swap in new Chain Roller Full element with correct number of chain segments
% Find remaining Contact Force element
bh_CF = Simulink.findBlocks([newChain2RollerSetFile '/' newChain2RollerSetSub],'Name',['CF Chain Roller Full R#*'],f);

% Swap in contact force for one roller, all chain segments
set_param(bh_CF,'ReferenceBlock',rollerSetRefBlock)
pos_CF = get_param(bh_CF,'Position');
nCharName = length(num2str(nRollers));

% Offset for each contact force element
cf_offset_y = 45;

% Loop over all segments
for i=1:nRollers
    if (i>1)
        % Add new contact force (ecept for element 1 which is still there)
        bh_CFi = add_block(getfullname(bh_CF),getfullname(bh_CF),'MakeNameUnique','on');
        bName = ['CF Chain Roller Full R' pad(num2str(i),nCharName,'left','0')];
        pos_CFi = pos_CF+[0 i-1 0 i-1]*cf_offset_y;
        set_param(bh_CFi,'Name',bName,'Position',pos_CFi)
    else
        % If first element, we have block handle already
        bh_CFi = bh_CF;
        bName = ['CF Chain Roller Full R' pad(num2str(i),nCharName,'left','0')];
        set_param(bh_CFi,'Name',bName)
    end

    % Get port handles for contact force element
    ph_cfi = get_param(bh_CFi,'PortHandles');

    % Connect contact force element to bus, connection port
    add_line([newChain2RollerSetFile '/' newChain2RollerSetSub],ph_ssbu.LConn(i),ph_cfi.LConn(1),'autorouting','on');
    add_line([newChain2RollerSetFile '/' newChain2RollerSetSub],ph_cpb.RConn(1),ph_cfi.RConn(1),'autorouting','on');
end

%% Save file
save_system(newChain2RollerSetFile)
bdclose(newChain2RollerSetFile)
end