function [newChainFile, newChainSubs] = genTVchain_chain(nSegs)
%% Source files: Copy to new location and modify
refChainFile = 'sm_trackV_lib_chain_track_s46';
refChainSubs = 'Track Contact Point Cloud';

% Save chain under new name
[d, f, e] = fileparts(which(refChainFile));
us_ind    = strfind(f,'_');
filesuff  = ['GEN_s' num2str(nSegs)];
newChainFile = [f(1:us_ind(end)) filesuff];
copyfile(which(refChainFile),[d filesep newChainFile e])

% Open new chain file
load_system(newChainFile)
set_param(newChainFile,'Lock','off')

% New subsystem name (no change) 
newChainSubs = refChainSubs; % not renamed

% 1. Delete all lines connected to segments except "Seg 01"
% 2. Delete all Segments except  "Seg01"
f = Simulink.FindOptions('RegExp',true,'SearchDepth',1);
bh_seg = Simulink.findBlocks([newChainFile '/' newChainSubs],'Name','Seg #*',f);

% Loop over segments
for i = 1:length(bh_seg)

    % Delete connection to next block
    line_h = get_param(bh_seg(i),'LineHandles');
    delete_line(line_h.LConn(2))

    % For blocks except reference segment
    if(~matches(get_param(bh_seg(i),'Name'),'Seg 01'))

        % Delete connections to Connection Labels
        delete_line(line_h.RConn)
        delete_block(bh_seg(i))
    end
end

%% 3. Delete all Connection Label blocks except those with label "1"
% Find all Connection Label blocks
bh_cn = Simulink.findBlocks([newChainFile '/' newChainSubs],'BlockType','ConnectionLabel');

% Loop over all Connection Labels blocks
for i=1:length(bh_cn)

    % Get label index
    dpat = extract(get_param(bh_cn(i),'Label'),digitsPattern);

    % Only delete block if its label index is not 1
    if(~matches(dpat,'1'))
        delete_block(bh_cn(i))
    end
end

%% 4. Delete all lines connected to Simscape busses except "1"
% Find all Simscape Bus blocks
bh_sb = Simulink.findBlocks([newChainFile '/' newChainSubs],'BlockType','SimscapeBus');

% Loop over Simscape bus blocks
for i=1:length(bh_sb)

    % Delete all lines to Connection Label Blocks
    % except ones at first port
    line_h = get_param(bh_sb(i),'LineHandles');
    delete_line(line_h.LConn(2:end));
end

%% 5. Add all segments 
%     a. Copy Seg 01, connect to previous
%     b. Add Connection Labels
%     c. Connect connection labels to segment

% Find remaining Segment blocks (only one remaining is reference)
bh_seg = Simulink.findBlocks([newChainFile '/' newChainSubs],'Name','Seg #*',f);

% Get position
pos_seg = get_param(bh_seg,'Position');
nCharName = length(num2str(nSegs));

% Offsets for positioning blocks
sg_offset_x = 100;
cn_offset_y = 75;
cn_w = 20; cn_h = 10; 

% Source of Connection Label block
cnb  = 'nesl_utility/Connection Label';

% Reference block is "previous" block
bh_segj = bh_seg;

% Loop to add missing segment blocks
for i=2:nSegs

    % Copy/Paste reference segment block
    bh_segi = add_block(getfullname(bh_seg),getfullname(bh_seg),'MakeNameUnique','on');

    % Create correct name
    bName = ['Seg ' pad(num2str(i),nCharName,'left','0')];
    pos_segi = pos_seg+[i-1 0 i-1 0]*sg_offset_x;
    set_param(bh_segi,'Name',bName,'Position',pos_segi)

    % Get port handles for current and previous segment
    ph_sgi = get_param(bh_segi,'PortHandles');
    ph_sgj = get_param(bh_segj,'PortHandles');

    % Connect segments
    add_line([newChainFile '/' newChainSubs],ph_sgj.LConn(2),ph_sgi.LConn(1));

    % Determine position for next Connection Label block R
    pos_cnr = [pos_seg(1) pos_seg(2) pos_seg(1)+cn_w pos_seg(2)+cn_h]...
        +[i-1 1 i-1 1].*[sg_offset_x cn_offset_y sg_offset_x cn_offset_y];

    % Add Connection Label block R for current segment
    cn_r  = add_block(cnb,[newChainFile '/' newChainSubs '/Connection Label R' num2str(i)],...
        'Position',pos_cnr,'Label',['R' num2str(i)],...
        'Orientation','down','ShowName','off');

    % Add Connection Label block G for current segment
    % Offset from Connection Label block R
    cn_g  = add_block(cnb,[newChainFile '/' newChainSubs '/Connection Label G' num2str(i)],...
        'Position',pos_cnr+[1 0 1 0]*25,'Label',['G' num2str(i)],...
        'Orientation','down','ShowName','off');

    % Add Connection Label block T for current segment
    % Offset from Connection Label block G
    cn_t  = add_block(cnb,[newChainFile '/' newChainSubs '/Connection Label T' num2str(i)],...
        'Position',pos_cnr+[2 0 2 0]*25,'Label',['T' num2str(i)],...
        'Orientation','down','ShowName','off');

    % Get port handles
    ph_cnr = get_param(cn_r,'PortHandles');
    ph_cng = get_param(cn_g,'PortHandles');
    ph_cnt = get_param(cn_t,'PortHandles');

    % Connect Connection label blocks to chain segment
    add_line([newChainFile '/' newChainSubs],ph_cnr.LConn(1),ph_sgi.RConn(1));
    add_line([newChainFile '/' newChainSubs],ph_cng.LConn(1),ph_sgi.RConn(2));
    add_line([newChainFile '/' newChainSubs],ph_cnt.LConn(1),ph_sgi.RConn(3));

    % Current segment is now previous segment
    bh_segj = bh_segi;
end

% Connect final segment to first segment
ph_sg0 = get_param(bh_seg,'PortHandles');
add_line([newChainFile '/' newChainSubs],ph_sgi.LConn(2),ph_sg0.LConn(1),'autorouting','on');

%% 6. Reset Simscape Bus blocks

% Find Simscape Bus blocks
f = Simulink.FindOptions('RegExp',true,'SearchDepth',1);
bh_ssbu = Simulink.findBlocks([newChainFile '/' newChainSubs],'BlockType','SimscapeBus','ConnectionType','.*Chain.*',f);

for i = 1:length(bh_ssbu)
    % Delete remaining lines
    line_h = get_param(bh_ssbu(i),'LineHandles');
    delete_line(line_h.LConn(1))

    % Clear port strings, assign bus object
    set_param(bh_ssbu(i),'HierarchyStrings','');
    set_param(bh_ssbu(i),'ConnectionType',['Bus: CBO_Chain' num2str(nSegs)])

    % Resize Simscape Bus block based on number of ports
    pos_ssbu   = get_param(bh_ssbu(i),'Position');

    % Save Bus y position for connecting Connection Label blocks
    ssbu_py(i) = pos_ssbu(2); %#ok<AGROW>
    pos_ssbu_new    = pos_ssbu;
    pos_ssbu_new(3) = pos_ssbu(1)+20*nSegs;
    set_param(bh_ssbu(i),'Position',pos_ssbu_new);
end

% Use relative y position of Simscape Bus blocks to determine 
% which Connection Label blocks to connect to which bus.

% Get order of Simscape Bus blocks y by y position
[~, yPosSorti] = sort(ssbu_py);

% Sort list of block handles and positions by y position
bh_ssbu = bh_ssbu(yPosSorti);
ssbu_py = ssbu_py(yPosSorti);

%% 7. Add Connection Label blocks

% List of connection label sets (Roller, Terrain, Gear)
label_set = {'R1' 'T1' 'G1'};

% Loop over label
for li = 1:length(label_set)

    % Find disconnected Connection Label blocks with label for set
    label_str = label_set{li};
    bh_cnR = Simulink.findBlocks([newChainFile '/' newChainSubs],'BlockType','ConnectionLabel','Label',label_str);

    % Check port connections for each connection label block
    for j = 1:length(bh_cnR)
        line_h = get_param(bh_cnR(j),'LineHandles');

        % Connection label we need to connect will have no lines
        if(line_h.LConn == -1)
            % Get handle
            ph_cnR0 = get_param(bh_cnR(j),'PortHandles');
            % Record position as reference location for new blocks
            po_cnR0 = get_param(bh_cnR(j),'Position');
        end
    end
    
    % Use y position of Simscape Bus blocks 
    % to find block handle for block to which label should connect
    ssbu_ind = find(ssbu_py>(po_cnR0(2)),1);
    ph_ssbu = get_param(bh_ssbu(ssbu_ind),'PortHandles');

    % Connect Connection Label block to Simscape Bus block
    add_line([newChainFile '/' newChainSubs],ph_ssbu.LConn(1),ph_cnR0.LConn(1))

    % Loop over segment numbers, 2 to end
    for i=2:nSegs

        % Add Connection Label block
        cn_r  = add_block(cnb,[newChainFile '/' newChainSubs '/Connection Label ' label_str(1) 'b' num2str(i)],...
            'Position',po_cnR0+[i-1 0 i-1 0]*20,'Label',[label_str(1) num2str(i)],...
            'Orientation','up','ShowName','off');

        % Connect to Simscape Bus block
        ph_cnr = get_param(cn_r,'PortHandles');
        add_line([newChainFile '/' newChainSubs],ph_ssbu.LConn(i),ph_cnr.LConn(1),'autorouting','on');
    end
end

%% Save file
save_system(newChainFile)
bdclose(newChainFile)
end