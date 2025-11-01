function [newContactTerrainFile, newContactTerrainSub] = genTVroller_terrain(nRollers)

%% Source files: Copy to new location and modify
refContactTerrainFile = 'sm_rollerV_lib_terrain_contact_r9';

% Reference subsystem to be modified
refContactTerrainSub_list  = {'CF Roller Terrain Full','CF Roller BrickBump Full'};
% Reference subsystem connection port names
refContactTerrainPort_list = {'Terrain','Bump'};

%% Save terrain contacts under new name
% Cannot simply copyfile
% Need to open and re-save to fix links within library file
[d, f, e] = fileparts(which(refContactTerrainFile));
us_ind    = strfind(f,'_');
filesuff  = ['GEN_s' num2str(nRollers)];
newContactTerrainFile = [f(1:us_ind(end)) filesuff];
open_system(refContactTerrainFile);
save_system(refContactTerrainFile,[d filesep newContactTerrainFile e])

% Unlock file
set_param(newContactTerrainFile,'Lock','off')

% Loop over subsystems to be modified
for si = 1:length(refContactTerrainSub_list)

    % Rename subsystem with new number of segments
    refContactTerrainSub = refContactTerrainSub_list{si};
    %dpat = extract(refContactTerrainSub,digitsPattern);
    newContactTerrainSub = [refContactTerrainSub '_r' num2str(nRollers)];
    set_param([newContactTerrainFile '/' refContactTerrainSub],'Name',newContactTerrainSub)

    % 1. Delete all lines connected to contact force elements
    % 2. Delete all contact force elements except first element
    f = Simulink.FindOptions('RegExp',true,'SearchDepth',1);
    bh_CF = Simulink.findBlocks([newContactTerrainFile '/' newContactTerrainSub],'Name',['CF Track .* #*'],f);

    % Loop over all contact force elements
    for i = 1:length(bh_CF)

        % Delete connection lines
        line_h = get_param(bh_CF(i),'LineHandles');
        delete_line(line_h.LConn)
        delete_line(line_h.RConn)

        % Do not delete first contact force element
        % Will use copy/paste to create the rest
        dpat = extract(get_param(bh_CF(i),'Name'),digitsPattern);
        if(~(str2double(dpat{end})==1))
            delete_block(bh_CF(i))
        end
    end

    %% Reset Simscape Bus Block
    bh_ssbu = Simulink.findBlocks([newContactTerrainFile '/' newContactTerrainSub],'BlockType','SimscapeBus');

    % Clear port strings, assign bus object
    set_param(bh_ssbu,'HierarchyStrings','');
    set_param(bh_ssbu,'ConnectionType',['Bus: CBO_Roller' num2str(nRollers)])
    ph_ssbu = get_param(bh_ssbu,'PortHandles');

    % Resize Simscape Bus block based on number of ports
    pos_ssbu   = get_param(bh_ssbu,'Position');
    pos_ssbu_new    = pos_ssbu;
    pos_ssbu_new(4) = pos_ssbu(2)+25*nRollers;
    set_param(bh_ssbu,'Position',pos_ssbu_new+[0 -10 0 -10]);

    %% Connect contact force elements to Port and Bus
    % Get port handles to Connection Port Ch
    bh_cpb = Simulink.findBlocks([newContactTerrainFile '/' newContactTerrainSub],...
        'BlockType','PMIOPort','Name',refContactTerrainPort_list{si});
    ph_cpb = get_param(bh_cpb,'PortHandles');

    %% Swap in new contact force element with correct number of chain segments
    % Find remaining Contact Force element
    bh_CF = Simulink.findBlocks([newContactTerrainFile '/' newContactTerrainSub],'Name','CF Track .* #*',f);

    % Get properties of reference force element
    pos_CF = get_param(bh_CF,'Position');
    name_CF = get_param(bh_CF,'Name');
    spaceInds = strfind(name_CF,' ');
    rootName_CF = name_CF(1:spaceInds(end));
    nCharName = length(num2str(nRollers));

    % Offset for each contact force element
    cf_offset_y = 25;

    % Loop over all segments
    for i=1:nRollers
        if (i>1)
            % Add new contact force (except for element 1 which is still there)
            bh_CFi = add_block(getfullname(bh_CF),getfullname(bh_CF),'MakeNameUnique','on');
            bName = [rootName_CF pad(num2str(i),nCharName,'left','0')];
            pos_CFi = pos_CF+[0 i-1 0 i-1]*cf_offset_y;
            set_param(bh_CFi,'Name',bName,'Position',pos_CFi)
        else
            % If first element, we have block handle already
            bh_CFi = bh_CF;
            bName = [rootName_CF pad(num2str(i),nCharName,'left','0')];
            set_param(bh_CFi,'Name',bName)
        end

        % Get port handles for contact force element
        ph_cfi = get_param(bh_CFi,'PortHandles');

        % Connect contact force element to bus, connection port
        add_line([newContactTerrainFile '/' newContactTerrainSub],ph_ssbu.LConn(i),ph_cfi.RConn(1),'autorouting','on');
        add_line([newContactTerrainFile '/' newContactTerrainSub],ph_cpb.RConn(1),ph_cfi.LConn(1),'autorouting','on');
    end

    % Fix Unresolved Links due to subsystem rename
    % findBlocks cannot find blocks with unresolved links - must check them all
    f = Simulink.FindOptions('LookUnderMasks','All','SearchDepth',-1);
    blkList = Simulink.findBlocks(newContactTerrainFile,f);
    for bi = 1:length(blkList)

        % Check link status
        linkStatus = get_param(blkList(bi),'LinkStatus');
        if(matches(linkStatus,'unresolved'))

            srcBlk = get_param(blkList(bi),'SourceBlock');
            %disp([srcBlk ' ' num2str(contains(srcBlk,refContactTerrainSub))])
            % If source block contains renamed subsystem, fix it
            if(contains(srcBlk,refContactTerrainSub))
                set_param(blkList(bi),'ReferenceBlock',[newContactTerrainFile '/' newContactTerrainSub]);
                % disp(['FIXED ' get_param(blkList(bi),'Name')])
            end
        end
    end
end

%% Save file
save_system(newContactTerrainFile)
bdclose(newContactTerrainFile)

end