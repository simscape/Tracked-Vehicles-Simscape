function [newChainElemFile, newChain2ElemSub_list] = genTVchain_chain2element(nSegs)

%% Source files: Copy to new location and modify
refChain2ElemFile = 'sm_trackV_lib_chain_contact_s46';

% Save Contacts under new name
[d, f, e] = fileparts(which(refChain2ElemFile));
us_ind    = strfind(f,'_');
filesuff  = ['GEN_s' num2str(nSegs)];
newChainElemFile = [f(1:us_ind(end)) filesuff];
copyfile(which(refChain2ElemFile),[d filesep newChainElemFile e])

% List of contact elements
element_list = {'Idler','Sprocket','Roller'};

% Open new frame file
load_system(newChainElemFile)
set_param(newChainElemFile,'Lock','off')

% Loop over list of contact elements
for ei = 1:length(element_list)

    % Reference subsystem to be modified
    refElemSub = sprintf('CF Chain46\n%s',element_list{ei});

    % Rename subsystem with new number of segments
    dpat = char(extract(refElemSub,digitsPattern));
    newChain2ElemSub = strrep(refElemSub,dpat,num2str(nSegs));
    set_param([newChainElemFile '/' refElemSub],'Name',newChain2ElemSub)

    % List of new subsystem names
    newChain2ElemSub_list{ei} = newChain2ElemSub; %#ok<AGROW>

    % 1. Delete all lines connected to contact force elements 
    % 2. Delete all contact force elements except "CF Chain *** 01"
    f = Simulink.FindOptions('RegExp',true,'SearchDepth',1);
    bh_CF = Simulink.findBlocks([newChainElemFile '/' newChain2ElemSub],'Name',['CF Chain ' element_list{ei} '#*'],f);

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
    bh_ssbu = Simulink.findBlocks([newChainElemFile '/' newChain2ElemSub],'BlockType','SimscapeBus');

    % Clear port strings, assign bus object
    set_param(bh_ssbu,'HierarchyStrings','');
    set_param(bh_ssbu,'ConnectionType',['Bus: CBO_Chain' num2str(nSegs)])
    ph_ssbu = get_param(bh_ssbu,'PortHandles');

    % Resize Simscape Bus block based on number of ports
    pos_ssbu   = get_param(bh_ssbu,'Position');
    ssbu_py(i) = pos_ssbu(2); %#ok<AGROW>
    pos_ssbu_new    = pos_ssbu;
    pos_ssbu_new(4) = pos_ssbu(2)+25*nSegs;
    set_param(bh_ssbu,'Position',pos_ssbu_new-[0 10 0 10]);

    %% Connect contact force elements to Port and Bus
    % Get port handles to Connection Port B
    bh_cpb = Simulink.findBlocks([newChainElemFile '/' newChain2ElemSub],'BlockType','PMIOPort','Name','B');
    ph_cpb = get_param(bh_cpb,'PortHandles');

    % Find remaining Contact Force element
    bh_CF = Simulink.findBlocks([newChainElemFile '/' newChain2ElemSub],'Name',['CF Chain ' element_list{ei} '#*'],f);
    pos_CF = get_param(bh_CF,'Position');
    nCharName = length(num2str(nSegs));

    % Offset for each contact force element
    cf_offset_y = 25;

    % Loop over all segments
    for i=1:nSegs
        if (i>1)
            % Add new contact force (ecept for element 1 which is still there)
            bh_CFi = add_block(getfullname(bh_CF),getfullname(bh_CF),'MakeNameUnique','on');
            bName = ['CF Chain ' element_list{ei} ' ' pad(num2str(i),nCharName,'left','0')];
            pos_CFi = pos_CF+[0 i-1 0 i-1]*cf_offset_y;
            set_param(bh_CFi,'Name',bName,'Position',pos_CFi)
        else
            % If first element, we have block handle already
            bh_CFi = bh_CF;
        end

        % Get port handles for contact force element
        ph_cfi = get_param(bh_CFi,'PortHandles');
        
        % Connect contact force element to bus, connection port
        add_line([newChainElemFile '/' newChain2ElemSub],ph_ssbu.LConn(i),ph_cfi.RConn(1),'autorouting','on');
        add_line([newChainElemFile '/' newChain2ElemSub],ph_cpb.RConn(1),ph_cfi.LConn(1),'autorouting','on');
    end
end

%% Save file
save_system(newChainElemFile)
bdclose(newChainElemFile)
end