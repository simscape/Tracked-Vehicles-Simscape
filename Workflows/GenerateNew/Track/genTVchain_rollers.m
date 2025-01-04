function [newUndercFile, newUndercSubs] = genTVchain_rollers(nRollL,nRollU,nIdler,newFrameFile,newFrameSub)

% Source files: Copy to new location and modify
refUndercFile = 'sm_trackV_lib_chain_underc_i1u2l7';
refUndercSubs = 'Undercarriage Track Contact';

% Save Undercarriage under new name
[d, f, e] = fileparts(which(refUndercFile));
us_ind    = strfind(f,'_');
filesuff  = ['GEN_i' num2str(nIdler) 'u' num2str(nRollU) 'l' num2str(nRollL)];
newUndercFile = [f(1:us_ind(end)) filesuff];
copyfile(which(refUndercFile),[d filesep newUndercFile e])

% Open new frame file
%load_system(newUndercFile)
open_system(newUndercFile)
set_param(newUndercFile,'Lock','off')

% New subsystem 
newRollerSubs  = sprintf('Undercarriage\nTrack Contact/Rollers'); % not renamed
newRollerParent = get_param([newUndercFile '/' newRollerSubs],'Parent');
newUndercSubs = get_param(newRollerParent,'Name');

% Delete line connections between Rollers and Frame
% Will redraw connections after ports are created
line_h = get_param([newUndercFile '/' newRollerSubs],'LineHandles');
delete_line(line_h.LConn)

% Find Revolute Joints for upper and lower rollers
f = Simulink.FindOptions('RegExp',true,'SearchDepth',1);
bh_rvLR = Simulink.findBlocks([newUndercFile '/' newRollerSubs],'Name','Revolute Lower #*',f);
bh_rvUR = Simulink.findBlocks([newUndercFile '/' newRollerSubs],'Name','Revolute Upper #*',f);

% Find other blocks to delete OR use as reference
bh_soLR = Simulink.findBlocks([newUndercFile '/' newRollerSubs],'Name','Roller Lower #*',f);
bh_soUR = Simulink.findBlocks([newUndercFile '/' newRollerSubs],'Name','Roller Upper #*',f);
bh_cnLR = Simulink.findBlocks([newUndercFile '/' newRollerSubs],'BlockType','ConnectionLabel','Label','L#*',f);
bh_cnUR = Simulink.findBlocks([newUndercFile '/' newRollerSubs],'BlockType','ConnectionLabel','Label','U#*',f);
bh_psLR = Simulink.findBlocks([newUndercFile '/' newRollerSubs],'ReferenceBlock','nesl_utility/PS-Simulink Converter');
%bh_ssbu = Simulink.findBlocks([newUndercFile '/' newRollerSubs],'BlockType','SimscapeBus','ConnectionType','.*Roller.*',f);
bh_ssbu = Simulink.findBlocks([newUndercFile '/' newRollerSubs],'BlockType','SimscapeBus'); % Due to Simscape Bus Issue R24b
% Loop over Lower Roller Revolute joints
for i = 1:length(bh_rvLR)

    % Check Revolute Joint index
    dpat = extract(getfullname(bh_rvLR(i)),digitsPattern);
    if (str2double(dpat{end})>1)
        % Index higher than 1, needs to be deleted
        % Delete lines connected to Revolute Joint
        line_h = get_param(bh_rvLR(i),'LineHandles');
        delete_line(line_h.LConn)
        delete_line(line_h.RConn)

        % Delete Revolute Joint
        delete_block(bh_rvLR(i));
    end

    % Check Roller index
    dpat = extract(getfullname(bh_soLR(i)),digitsPattern);
    if (str2double(dpat{end})>1)
        % Index higher than 1, needs to be deleted
        % Delete line connected to Roller
        line_h = get_param(bh_soLR(i),'LineHandles');
        delete_line(line_h.RConn)

        % Delete line Roller
        delete_block(bh_soLR(i));
    end

    % Check Connection Port blocks by name
    if(i>1)

        % Connection Ports index higher than 1, delete it
        delete_block([newUndercFile '/' newRollerSubs '/Low' dpat{end}])
    
        % Delete line between Out Bus Element with index > 1
        % and PS-SL Converter 
        bh_beLR = Simulink.findBlocks([newUndercFile '/' newRollerSubs],...
            'BlockType','Outport','Element',['RL' num2str(i)]);
        line_h = get_param(bh_beLR,'LineHandles');
        delete_line(line_h.Inport);

        % Delete Out Bus Element port
        delete_block(bh_beLR)
    end
end

% Delete Connection Nodes for Lower Rollers with Label > 1
for i = 1:length(bh_cnLR)
    cnLR_label =  get_param(bh_cnLR(i),'Label');
    dpat = extract(cnLR_label,digitsPattern);

    % Connection Label index > 1, delete it
    if(str2double(dpat{end})>1)        
        delete_block(bh_cnLR(i));
    end
end

% Delete PS-SL converters that are not connected
for i = 1:length(bh_psLR)
    line_h = get_param(bh_psLR(i),'LineHandles');
    if((line_h.Outport == -1) && (line_h.LConn == -1))
        delete_block(bh_psLR(i));
    end
end

% Loop over Upper Roller Revolute joints
for i = 1:length(bh_rvUR)

    % Check Revolute Joint index
    dpat = extract(getfullname(bh_rvUR(i)),digitsPattern);
    if (str2double(dpat{end})>1)
        % Index higher than 1, needs to be deleted
        % Delete lines connected to Revolute Joint
        line_h = get_param(bh_rvUR(i),'LineHandles');
        delete_line(line_h.LConn)
        delete_line(line_h.RConn)

        % Delete Revolute Joint
        delete_block(bh_rvUR(i));
    end

    % Check Roller index
    dpat = extract(getfullname(bh_soUR(i)),digitsPattern);
    if (str2double(dpat{end})>1)
        % Delete remaining lines connected to Roller
        line_h = get_param(bh_soUR(i),'LineHandles');
        delete_line(line_h.RConn)
        delete_block(bh_soUR(i));
    end

    % Check Connection Port blocks by name
    if(i>1)
        % Connection Ports index higher than 1, delete it
        delete_block([newUndercFile '/' newRollerSubs '/Up' dpat{end}])   
    end
end

% Delete Connection Nodes for Upper Rollers with Label > 1
for i = 1:length(bh_cnUR)

    % Check Roller index
    cnUR_label =  get_param(bh_cnUR(i),'Label');
    dpat = extract(cnUR_label,digitsPattern);

    if(str2double(dpat{end})>1)
        % Label > 1, delete Connection Label block
        delete_block(bh_cnUR(i));
    end
end

% Reset Simscape Bus
% Delete all physical connection lines to Connection Labels
line_h = get_param(bh_ssbu,'LineHandles');
delete_line(line_h.LConn)

% Reset Simscape Bus ports
% Clear port strings, assign bus object
set_param(bh_ssbu,'HierarchyStrings','');
set_param(bh_ssbu,'ConnectionType',['Bus: CBO_Roller' num2str(nRollL+nRollU)]) 
ph_ssbu = get_param(bh_ssbu,'PortHandles');

% Resize Simscape Bus block based on number of ports
pos_ssbu        = get_param(bh_ssbu,'Position');
pos_ssbu_new    = pos_ssbu;
pos_ssbu_new(4) = pos_ssbu(2)+25*(nRollL+nRollL);
set_param(bh_ssbu,'Position',pos_ssbu_new+[0 5 0 5]*0);

%% Add blocks

% Find remaining Lower and Upper Roller Joints for copy/paste
bh_rvLR = Simulink.findBlocks([newUndercFile '/' newRollerSubs],'Name','Revolute Lower #*',f);
bh_rvUR = Simulink.findBlocks([newUndercFile '/' newRollerSubs],'Name','Revolute Upper #*',f);

% Find Roller blocks for copy/paste
bh_soLR = Simulink.findBlocks([newUndercFile '/' newRollerSubs],'Name','Roller Lower #*',f);
bh_soUR = Simulink.findBlocks([newUndercFile '/' newRollerSubs],'Name','Roller Upper #*',f);
bhcnLRs = Simulink.findBlocks([newUndercFile '/' newRollerSubs],'BlockType','ConnectionLabel','Label','L#*',f);

% Find Connection Labels for Lower Rollers with lines
% Loop over all Connection Labels for Lower Rollers
for j = 1:length(bhcnLRs)

    % Check port connections for each Connection Label block
    line_h = get_param(bhcnLRs(j),'LineHandles');
    % Connection label we need to connect will have a line
    if(line_h.LConn ~= -1)
        bh_cnLR  = bhcnLRs(j);
    else
        % Label with no line is for Bus connection
        % Get position for when we add missing Connection Labels for bus
        bh_cnLRb = bhcnLRs(j);
        pos_cnLRb = get_param(bh_cnLRb,'Position');
    end
end

% Find Connection Labels for Upper Rollers with lines
bhcnURs = Simulink.findBlocks([newUndercFile '/' newRollerSubs],'BlockType','ConnectionLabel','Label','U#*',f);

% Loop over all Connection Labels for Upper Rollers
for j = 1:length(bhcnURs)

    % Check port connections for each Connection Label block
    line_h = get_param(bhcnURs(j),'LineHandles');
    % Connection label we need to connect will have a line
    if(line_h.LConn ~= -1)
        bh_cnUR = bhcnURs(j);
    else
        % Delete the other one - we will add it back later.
        delete_block(bhcnURs(j));
    end
end

% Get positions of blocks as reference
pos_rvLR = get_param(bh_rvLR,'Position');
pos_rvUR = get_param(bh_rvUR,'Position');
pos_soLR = get_param(bh_soLR,'Position');
pos_soUR = get_param(bh_soUR,'Position');
pos_cnLR = get_param(bh_cnLR,'Position');
pos_cnUR = get_param(bh_cnUR,'Position');

% Get length of index for block names
nCharNameLR = length(num2str(nRollL));
nCharNameUR = length(num2str(nRollU));

% Offsets on block canvas
rvl_offset_x = 110;
rvu_offset_x = 100;

% Settings for SL-PS
sl_offset_y = 115;
sl_w = 16; sl_h = 15;
slb  = 'nesl_utility/PS-Simulink Converter';

% Settings for Connection Label
cnb  = 'nesl_utility/Connection Label';

% Settings for Bus Element
be_offset_y = 16;
be_w = 10; be_h = 10;

% Settings for Connection Port
cpl_offset_y    = -75; % Lower
cpu_offset_y    =  50; % Upper
cp_w = 14; % Block width
cp_h = 30; % Block height
cpb  = 'nesl_utility/Connection Port';

%% Add Components for Lower Rollers
for i = 2:nRollL    
    % Copy/Paste Lower Revolute Joint, set position and name
    bh_rvLRi = add_block(getfullname(bh_rvLR),getfullname(bh_rvLR),'MakeNameUnique','on');
    bNameLR = sprintf('Revolute\nLower %s',pad(num2str(i),nCharNameLR,'left','0'));
    pos_rvLRi = pos_rvLR+[i-1 0 i-1 0]*rvl_offset_x;
    set_param(bh_rvLRi,'Name',bNameLR,'Position',pos_rvLRi)

    % Copy/Paste Lower Roller, set position and name
    bh_soLRi = add_block(getfullname(bh_soLR),getfullname(bh_soLR),'MakeNameUnique','on');
    bNameLR = sprintf('Roller\nLower %s',pad(num2str(i),nCharNameLR,'left','0'));
    pos_soLRi = pos_soLR+[i-1 0 i-1 0]*rvl_offset_x;
    set_param(bh_soLRi,'Name',bNameLR,'Position',pos_soLRi)

    % Copy/Paste Connection Label for lower roller, set position and label
    bh_cnLRi = add_block(getfullname(bh_cnLR),getfullname(bh_cnLR),'MakeNameUnique','on');
    pos_cnLRi = pos_cnLR+[i-1 0 i-1 0]*rvl_offset_x;
    set_param(bh_cnLRi,'Position',pos_cnLRi,'Label',['L' num2str(i)])

    % Add PS-SL Converter, positioned relative to Revolute Joint
    % Cannot easily use copy/paste, blocks not easily uniquely identifiable
    sl_px1 = ((pos_rvLRi(1)+pos_rvLRi(3))-sl_w)/2+18;
    sl_px2 = sl_px1+sl_w;
    sl_py1 = pos_rvLRi(2)+sl_offset_y;
    sl_py2 = sl_py1+sl_h;
    posNewSL = [sl_px1 sl_py1 sl_px2 sl_py2];
    sl_name = sprintf('PS-SL Lower %i',j);
    bh_slLRi = add_block(slb,[newUndercFile '/' newRollerSubs '/' sl_name],...
        'Position',posNewSL,...
        'Orientation','down',...
        'MakeNameUnique','on',...
        'ShowName','off');

    % Add Out Bus Element
    be_px1 = (sl_px1+sl_px2)/2-4;
    be_px2 = be_px1+be_w;
    be_py1 = sl_py1+be_offset_y;
    be_py2 = be_py1+be_h;
    posNewBE = [be_px1 be_py1 be_px2 be_py2];
    bh_beLRi = add_block([newUndercFile '/' newRollerSubs '/Out Bus Element1'],[newUndercFile '/' newRollerSubs '/Out Bus Element1'],...
        'Position',posNewBE,...
        'Orientation','down',...
        'MakeNameUnique','on',...
        'ShowName','off',...
        'Element',['RL' num2str(i)]);

    % Add Connection port
    cp_px1 = ((pos_rvLRi(1)+pos_rvLRi(3))-cp_w)/2;
    cp_px2 = cp_px1+cp_w;
    cp_py1 = pos_rvLRi(4)+cpl_offset_y;
    cp_py2 = cp_py1+cp_h;
    posNewCP = [cp_px1 cp_py1 cp_px2 cp_py2];
    cp_name = sprintf('Low%i',i);
    bh_cpLRi = add_block(cpb,[newUndercFile '/' newRollerSubs '/' cp_name],...
        'Position',posNewCP,...
        'Orientation','down',...
        'NameLocation','left');
    set_param(bh_cpLRi,'Side','Left')

    % Connect Joint and Port
    ph_rvLRi = get_param(bh_rvLRi,'PortHandles');
    ph_cpLRi = get_param(bh_cpLRi,'PortHandles');
    add_line([newUndercFile '/' newRollerSubs],ph_rvLRi.LConn(1), ph_cpLRi.RConn(1))

    % Connect Joint and Roller
    ph_soLRi = get_param(bh_soLRi,'PortHandles');
    add_line([newUndercFile '/' newRollerSubs],ph_rvLRi.RConn(1), ph_soLRi.LConn(1))
    
    % Connect Roller and Connection Label
    ph_cnLRi = get_param(bh_cnLRi,'PortHandles');
    add_line([newUndercFile '/' newRollerSubs],ph_soLRi.RConn(1), ph_cnLRi.LConn(1))

    % Connect Joint and PS-SL Converter
    ph_slLRi = get_param(bh_slLRi,'PortHandles');
    add_line([newUndercFile '/' newRollerSubs],ph_rvLRi.RConn(2), ph_slLRi.LConn(1),'autorouting','on')

    % Connect PS-SL Converter and Bus Out Port
    ph_beLRi = get_param(bh_beLRi,'PortHandles');
    add_line([newUndercFile '/' newRollerSubs],ph_slLRi.Outport(1), ph_beLRi.Inport(1),'autorouting','on')

end

%% Add Components for Lower Rollers
for i = 2:nRollU
    % Copy/Paste Upper Revolute Joint, set position and name
    bh_rvURi = add_block(getfullname(bh_rvUR),getfullname(bh_rvUR),'MakeNameUnique','on');
    bNameUR = sprintf('Revolute\nUpper %s',pad(num2str(i),nCharNameUR,'left','0'));
    pos_rvURi = pos_rvUR+[i-1 0 i-1 0]*rvu_offset_x;
    set_param(bh_rvURi,'Name',bNameUR,'Position',pos_rvURi)

    % Copy/Paste Upper Roller, set position and name
    bh_soURi = add_block(getfullname(bh_soUR),getfullname(bh_soUR),'MakeNameUnique','on');
    bNameUR = sprintf('Roller\nUpper %s',pad(num2str(i),nCharNameUR,'left','0'));
    pos_soURi = pos_soUR+[i-1 0 i-1 0]*rvu_offset_x;
    set_param(bh_soURi,'Name',bNameUR,'Position',pos_soURi)

    % Copy/Paste Connection Label for upper roller, set position and label
    bh_cnURi = add_block(getfullname(bh_cnUR),getfullname(bh_cnUR),'MakeNameUnique','on');
    pos_cnURi = pos_cnUR+[i-1 0 i-1 0]*rvu_offset_x;
    set_param(bh_cnURi,'Position',pos_cnURi,'Label',['U' num2str(i)])

    % Add Connection port
    cp_px1 = ((pos_rvURi(1)+pos_rvURi(3))-cp_w)/2;
    cp_px2 = cp_px1+cp_w;
    cp_py1 = pos_rvURi(2)+cpu_offset_y;
    cp_py2 = cp_py1+cp_h;
    posNewCP = [cp_px1 cp_py1 cp_px2 cp_py2];
    cp_name = sprintf('Up%i',i);
    bh_cpURi = add_block(cpb,[newUndercFile '/' newRollerSubs '/' cp_name],...
        'Position',posNewCP,...
        'Orientation','up',...
        'NameLocation','right');
    set_param(bh_cpURi,'Side','Left')

    % Connect Joint and Port
    ph_rvURi = get_param(bh_rvURi,'PortHandles');
    ph_cpURi = get_param(bh_cpURi,'PortHandles');
    add_line([newUndercFile '/' newRollerSubs],ph_rvURi.LConn(1), ph_cpURi.RConn(1))

    % Connect Joint and Roller
    ph_soURi = get_param(bh_soURi,'PortHandles');
    add_line([newUndercFile '/' newRollerSubs],ph_rvURi.RConn(1), ph_soURi.LConn(1))
    
    % Connect Roller and Connection Label
    ph_cnURi = get_param(bh_cnURi,'PortHandles');
    add_line([newUndercFile '/' newRollerSubs],ph_soURi.RConn(1), ph_cnURi.LConn(1))
end

% Reconnect Connection Label L1 to Simscape Bus
ph_cnLRb = get_param(bh_cnLRb,'PortHandles');
add_line([newUndercFile '/' newRollerSubs],ph_cnLRb.LConn(1),ph_ssbu.LConn(1));


% Loop over Lower Roller index 2 to requested number of lower rollers
for j = 2:nRollL

    % Add Connection Label, position relative to L1
    posNewCN = pos_cnLRb+[0 j-1 0 j-1]*25;
    cn_name = sprintf('Connection Label L%i',j);
    bh_cnLRi = add_block(cnb,[newUndercFile '/' newRollerSubs '/' cn_name],...
        'Position',posNewCN,...
        'MakeNameUnique','on',...
        'Orientation','left',...
        'ShowName','off',...
        'Label',['L' num2str(j)]);

    % Connect to Simscape Bus
    ph_cnLRi = get_param(bh_cnLRi,'PortHandles');
    add_line([newUndercFile '/' newRollerSubs],ph_cnLRi.LConn(1),ph_ssbu.LConn(j))
end

% Loop over Upper Roller index 2 to requested number of upper rollers
for j = 1:nRollU

    % Add Connection Label, position relative to 
    % highest index Connection Label for lower rollers
    posNewCNU = posNewCN+[0 j 0 j]*25;
    cn_name = sprintf('Connection Label L%i',j);
    bh_cnLRi = add_block(cnb,[newUndercFile '/' newRollerSubs '/' cn_name],...
        'Position',posNewCNU,...
        'MakeNameUnique','on',...
        'Orientation','left',...
        'ShowName','off',...
        'Label',['U' num2str(j)]);

    % Connect to Simscape Bus
    ph_cnLRi = get_param(bh_cnLRi,'PortHandles');
    add_line([newUndercFile '/' newRollerSubs],ph_cnLRi.LConn(1),ph_ssbu.LConn(j+nRollL))
end

%% Reorder Connection Ports
% From left to right, port order should be S Up1 Up2 ... Low1 Low2... C

% Set port C as port 1
bh_cp = Simulink.findBlocks([newUndercFile '/' newRollerSubs],'BlockType','PMIOPort','Side','Left','Name','C');
set_param(bh_cp,'Port','1');

% Find Low ports
f = Simulink.FindOptions('RegExp',true,'SearchDepth',1);
bh_cpAll = Simulink.findBlocks([newUndercFile '/' newRollerSubs],'BlockType','PMIOPort','Side','Left','Name','Low.*',f);

% Order Low ports, highest roller number as lowest port number
portNum = 1;
for i = length(bh_cpAll):-1:1
    bh_cp = Simulink.findBlocks([newUndercFile '/' newRollerSubs],'BlockType','PMIOPort','Side','Left','Name',['Low' num2str(i)]);
    portNum = portNum +1;
    set_param(bh_cp,'Port',num2str(portNum),'Side','Left');
end

% Find Up ports
f = Simulink.FindOptions('RegExp',true,'SearchDepth',1);
bh_cpAll = Simulink.findBlocks([newUndercFile '/' newRollerSubs],'BlockType','PMIOPort','Side','Left','Name','Up.*',f);

% Order Up ports, highest roller number as lowest port number
for i = length(bh_cpAll):-1:1
    bh_cp = Simulink.findBlocks([newUndercFile '/' newRollerSubs],'BlockType','PMIOPort','Side','Left','Name',['Up' num2str(i)]);
    portNum = portNum + 1;
    set_param(bh_cp,'Port',num2str(portNum),'Side','Left');
end

%% Bring in Frame subsystem with the correct number of connections
set_param([newUndercFile '/' refUndercSubs '/Frame'],'ReferenceBlock',[newFrameFile '/' newFrameSub]);

% Get port handles
fr_pha = get_param([newUndercFile '/' refUndercSubs '/Frame'],'PortHandles');
ro_pha = get_param([newUndercFile '/' refUndercSubs '/Rollers'],'PortHandles');

% Loop over port handles and frame and roller subsystems
for i = 1:length(fr_pha.RConn)
    add_line([newUndercFile '/' refUndercSubs],fr_pha.RConn(i),ro_pha.LConn(i),'autorouting','on');
end

%% Fix promoted parameters
% Get Mask Object
maskObj = get_param([newUndercFile '/' refUndercSubs '/Rollers'],'MaskObject');

% List of promoted parameters affected by changes
rl_param_list = {'roller_lower_len','roller_lower_rad','roller_lower_rho','roller_lower_clr','roller_lower_opc','roller_lower_contgeo_clr','roller_lower_contgeo_opc'};
ul_param_list = {'roller_upper_len','roller_upper_rad','roller_upper_rho','roller_upper_clr','roller_upper_opc','roller_upper_contgeo_clr','roller_upper_contgeo_opc'};

% Loop over list of parameters
for i = 1:length(rl_param_list)

    % Find parameter index within Mask Object
    mp_i = find(matches({maskObj.Parameters.Name},rl_param_list{i}));

    % Get current list of block parameters promoting to this mask parameter
    typeOptList = maskObj.Parameters(mp_i).TypeOptions;

    % Get the first block parameter reference as an example
    paramStr = typeOptList{1};

    % Find the number in the block parameter reference
    dpat = extract(paramStr,digitsPattern);

    % Loop over number of rollers
    newTypeOptList = {};
    for r_i = 1:nRollL

        % Add reference for each block parameter to a cell array
        newTypeOptList(r_i,1) = {strrep(paramStr,[char(dpat) '/'],[num2str(r_i) '/'])};
    end

    % Overwrite mask object Type Options with new list of promoted block parameters
    maskObj.Parameters(mp_i).TypeOptions = newTypeOptList;
end

for i = 1:length(ul_param_list)

    % Find parameter index within Mask Object
    mp_i = find(matches({maskObj.Parameters.Name},ul_param_list{i}));

    % Get current list of block parameters promoting to this mask parameter
    typeOptList = maskObj.Parameters(mp_i).TypeOptions;

    % Get the first block parameter reference as an example
    paramStr = typeOptList{1};

    % Find the number in the block parameter reference
    dpat = extract(paramStr,digitsPattern);

    % Loop over number of rollers
    newTypeOptList = {};
    for r_i = 1:nRollU

        % Add reference for each block parameter to a cell array
        newTypeOptList(r_i,1) = {strrep(paramStr,[char(dpat) '/'],[num2str(r_i) '/'])};
    end

    % Overwrite mask object Type Options with new list of promoted block parameters
    maskObj.Parameters(mp_i).TypeOptions = newTypeOptList;
end


% Set Mask Object in subsystem mask
set_param([newUndercFile '/' refUndercSubs '/Rollers'],'MaskObject',maskObj)

set_param(bh_ssbu,'ConnectionType','Inherit: auto') % Due to Simscape Bus Issue R24b

%% Save file
save_system(newUndercFile)
bdclose(newUndercFile)
end