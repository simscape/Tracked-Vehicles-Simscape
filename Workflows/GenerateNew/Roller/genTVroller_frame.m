function [newFrameFile, newSubName]  = genTVroller_frame(nRollL,nRollU,nIdler)

% Source files: Copy to new location and modify
refFrameFile = 'sm_trackV_lib_frame_i1u2l7';
refFrameSubs = 'Frame Up2 Down7';

% Save Frame under new name
[d, f, e] = fileparts(which(refFrameFile));
us_ind    = strfind(f,'_');
filesuff  = ['GEN_i' num2str(nIdler) 'u' num2str(nRollU) 'l' num2str(nRollL)];
newFrameFile = [f(1:us_ind(end)) filesuff];
copyfile(which(refFrameFile),[d filesep newFrameFile e])

% Open new frame file
load_system(newFrameFile)
set_param(newFrameFile,'Lock','off')

% Rename Subsystem
newSubName = sprintf('Frame\nUp%i Down%i',nRollU,nRollL);
set_param([newFrameFile '/' refFrameSubs],'Name',newSubName)

%% Delete frame connections except for #1
% Find Rigid Transforms for lower frames
f = Simulink.FindOptions('RegExp',true,'SearchDepth',1);
bh_trLR = Simulink.findBlocks([newFrameFile '/' newSubName],'Name','Transform Lower #*',f);

% Loop over Rigid Transforms
for i = 1:length(bh_trLR)
    dpat = extract(getfullname(bh_trLR(i)),digitsPattern);
    if (str2double(dpat{end})>1)
        % Frame number higher, needs to be deleted
        % Delete lines connected to Rigid Transform
        line_h = get_param(bh_trLR(i),'LineHandles');
        delete_line(line_h.LConn)
        delete_line(line_h.RConn)

        % Delete Connection Port (found by name)
        delete_block([newFrameFile '/' newSubName '/Low' dpat{end}])

        % Delete Rigid Transform
        delete_block(bh_trLR(i));
    end
end

%% Delete frame connections for upper rollers except #1

% Find Rigid Transforms for upper roller frames
f = Simulink.FindOptions('RegExp',true,'SearchDepth',1);
bh_trUR = Simulink.findBlocks([newFrameFile '/' newSubName],'Name','Transform Upper #*',f);

% Loop over upper roller Rigid Transforms
for i = 1:length(bh_trUR)

    dpat = extract(getfullname(bh_trUR(i)),digitsPattern);
    if (str2double(dpat{end})>1)
        % Frame number higher, needs to be deleted
        % Delete lines connected to Rigid Transform
        line_h = get_param(bh_trUR(i),'LineHandles');
        delete_line(line_h.LConn)
        delete_line(line_h.RConn)

        % Delete Connection Port
        delete_block([newFrameFile '/' newSubName '/Up' dpat{end}])

        % Delete Rigid Transform
        delete_block(bh_trUR(i));
    end
end

% Get block handles to remaining transforms (reference)
f = Simulink.FindOptions('RegExp',true,'SearchDepth',1);
bh_trLR = Simulink.findBlocks([newFrameFile '/' newSubName],'Name','Transform Lower #*',f);
bh_trUR = Simulink.findBlocks([newFrameFile '/' newSubName],'Name','Transform Upper #*',f);

% Get position of remaining Rigid Transforms
pos_trLR = get_param(bh_trLR,'Position');
pos_trUR = get_param(bh_trUR,'Position');
nCharNameLR = length(num2str(nRollL));
nCharNameUR = length(num2str(nRollU));

% Rigid Transform offsets
rt_offset_x  =  60;

% Connection Port settings and offsets
cpl_offset_y =  35;
cpu_offset_y = -60;
cp_w = 14; 
cp_h = 30;
cpb  = 'nesl_utility/Connection Port';

% Find Rigid Transform with vertical offset for lower and upper rollers
bh_trL = Simulink.findBlocks([newFrameFile '/' newSubName],'Name','Transform Lower');
bh_trU = Simulink.findBlocks([newFrameFile '/' newSubName],'Name','Transform Upper');
ph_trL = get_param(bh_trL,'PortHandles');
ph_trU = get_param(bh_trU,'PortHandles');

% Loop from 2 to desired number of lower rollers
for i = 2:nRollL    

    % Copy Rigid Transform block
    bh_trLRi = add_block(getfullname(bh_trLR),getfullname(bh_trLR),'MakeNameUnique','on');

    % Set name and position
    bNameLR = sprintf('Transform\nLower %s',pad(num2str(i),nCharNameLR,'left','0'));
    pos_trLRi = pos_trLR+[i-1 0 i-1 0]*rt_offset_x;
    set_param(bh_trLRi,'Name',bNameLR,'Position',pos_trLRi,...
        'TranslationStandardOffset',['roller_lower_x(' num2str(i) ')']);

    % Add Connection Port block
    % Position relative to Rigid Transform
    cp_px1 = ((pos_trLRi(1)+pos_trLRi(3))-cp_w)/2;
    cp_px2 = cp_px1+cp_w;
    cp_py1 = pos_trLRi(4)+cpl_offset_y;
    cp_py2 = cp_py1+cp_h;
    posNewCP = [cp_px1 cp_py1 cp_px2 cp_py2];
    cp_name = sprintf('Low%i',i);
    bh_cpLRi = add_block(cpb,[newFrameFile '/' newSubName '/' cp_name],...
        'Position',posNewCP,...
        'Orientation','up',...
        'NameLocation','left');
    set_param(bh_cpLRi,'Side','Right')

    % Connect Rigid Transform with vertical offset
    % to Rigid Transform with longitudinal offset
    ph_trLRi = get_param(bh_trLRi,'PortHandles');
    add_line([newFrameFile '/' newSubName],ph_trLRi.LConn(1),ph_trL.RConn(1),'autorouting','on')

    % Connect Rigid Transform with with longitudinal offset to Port
    ph_cpLRi = get_param(bh_cpLRi,'PortHandles');
    add_line([newFrameFile '/' newSubName],ph_trLRi.RConn(1),ph_cpLRi.RConn(1),'autorouting','on')

end

% Loop from 2 to desired number of upper rollers
for i = 2:nRollU    

    % Copy Rigid Transform block
    bh_trURi = add_block(getfullname(bh_trUR),getfullname(bh_trUR),'MakeNameUnique','on');

    % Set name and position
    bNameUR = sprintf('Transform\nUpper %s',pad(num2str(i),nCharNameUR,'left','0'));
    pos_trURi = pos_trUR+[i-1 0 i-1 0]*rt_offset_x;
    set_param(bh_trURi,'Name',bNameUR,'Position',pos_trURi,...
        'TranslationStandardOffset',['roller_upper_x(' num2str(i) ')']);

    % Add Connection Port block
    % Position relative to Rigid Transform
    cp_px1 = ((pos_trURi(1)+pos_trURi(3))-cp_w)/2;
    cp_px2 = cp_px1+cp_w;
    cp_py1 = pos_trURi(2)+cpu_offset_y;
    cp_py2 = cp_py1+cp_h;
    posNewCP = [cp_px1 cp_py1 cp_px2 cp_py2];
    cp_name = sprintf('Up%i',i);
    bh_cpURi = add_block(cpb,[newFrameFile '/' newSubName '/' cp_name],...
        'Position',posNewCP,...
        'Orientation','down',...
        'NameLocation','right');
    set_param(bh_cpURi,'Side','Right')

    % Connect Rigid Transform with vertical offset
    % to Rigid Transform with longitudinal offset
    ph_trURi = get_param(bh_trURi,'PortHandles');
    add_line([newFrameFile '/' newSubName],ph_trURi.LConn(1),ph_trU.RConn(1),'autorouting','on')

    % Connect Rigid Transform with with longitudinal offset to Port
    ph_cpURi = get_param(bh_cpURi,'PortHandles');
    add_line([newFrameFile '/' newSubName],ph_trURi.RConn(1),ph_cpURi.RConn(1),'autorouting','on')

end


%% Reorder Connection Ports
% From left to right, port order should be S Up1 Up2 ... Low1 Low2... C

% Set port C as port 1
bh_cp = Simulink.findBlocks([newFrameFile '/' newSubName],'BlockType','PMIOPort','Side','Right','Name','C');
set_param(bh_cp,'Port','1');

% Find Low ports
f = Simulink.FindOptions('RegExp',true,'SearchDepth',1);
bh_cpAll = Simulink.findBlocks([newFrameFile '/' newSubName],'BlockType','PMIOPort','Side','Right','Name','Low.*',f);

% Order Low ports, highest roller number as lowest port number
portNum = 1;
for i = length(bh_cpAll):-1:1
    bh_cp = Simulink.findBlocks([newFrameFile '/' newSubName],'BlockType','PMIOPort','Side','Right','Name',['Low' num2str(i)]);
    portNum = portNum +1;
    set_param(bh_cp,'Port',num2str(portNum),'Side','Right');
end

% Find Up ports
f = Simulink.FindOptions('RegExp',true,'SearchDepth',1);
bh_cpAll = Simulink.findBlocks([newFrameFile '/' newSubName],'BlockType','PMIOPort','Side','Right','Name','Up.*',f);

% Order Up ports, highest roller number as lowest port number
for i = length(bh_cpAll):-1:1
    bh_cp = Simulink.findBlocks([newFrameFile '/' newSubName],'BlockType','PMIOPort','Side','Right','Name',['Up' num2str(i)]);
    portNum = portNum + 1;
    set_param(bh_cp,'Port',num2str(portNum),'Side','Right');
end

%% Save file
save_system(newFrameFile)
bdclose(newFrameFile)

end