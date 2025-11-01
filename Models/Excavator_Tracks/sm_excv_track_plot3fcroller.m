function fcR = sm_excv_track_plot3fcroller(logsoutRes,forceType)
% Code to plot simulation results from excavator models
%% Plot Description:
%
% This function plots the in-plane loads on the lower track rollers. If
% results for both left and right tracks are available, two plots are made.
%
% Copyright 2016-2025 The MathWorks, Inc.

% Get simulation results

% Find all track data
logList  = getElementNames(logsoutRes);
trackInds = find(startsWith(logList,'Track'));

for i = 1:length(trackInds)
    trackLogN{i}   = logList{trackInds(i)};
    trackFieldN{i} = strrep(trackLogN{i},' ','_');
end
trackFieldN = sort(trackFieldN);
trackLogN = sort(trackLogN);
for i = 1:length(trackInds)
    TrackData.(trackFieldN{i}) = logsoutRes.get(trackLogN{i}).Values.Underc;
end
max_mag = 0;
min_mag = 1e10;

for t_i=1:length(trackInds)
    fntr = fieldnames(TrackData.(trackFieldN{t_i}));

    % Find data for lower rollers - name is RL##
    pat = "RL"+digitsPattern(1,100);
    RL_inds = find(startsWith(fntr,pat));

    % Get time data
    simlog_t = TrackData.(trackFieldN{t_i}).(fntr{RL_inds(1)}).Time;

    % Exclude first two seconds for setting vertical range of plot
    if(simlog_t(end)<2)
        error('Simulation must run longer than 2 seconds')
    else
        ind_2sec = find(simlog_t>2,1);
    end

    % Check for Sprocket, Idler data first (order rear to front)
    hasIdler  = find(matches(fntr,'XIdlerR'), 1);
    if(~isempty(hasIdler))
        % If rear idler, sprocket reaction forces not needed
        xIDr_fc = squeeze(TrackData.(trackFieldN{t_i}).XIdlerR.Data)';
        if(strcmpi(forceType,'magnitude'))
            fcR.(trackFieldN{t_i}).xIDr = vecnorm(xIDr_fc,2,2);
        elseif(strcmpi(forceType,'vertical'))
            fcR.(trackFieldN{t_i}).xIDr = -xIDr_fc(:,2);
        end
    else
        % If no rear idler, measure sprocket
        xSP_fc = squeeze(TrackData.(trackFieldN{t_i}).XSprk.Data)';
        if(strcmpi(forceType,'magnitude'))
            fcR.(trackFieldN{t_i}).xSP = vecnorm(xSP_fc,2,2);
        elseif(strcmpi(forceType,'vertical'))
            fcR.(trackFieldN{t_i}).xSP = -xSP_fc(:,2);
        end
    end

    % Loop over fields with roller data
    for i = 1:length(RL_inds)
        % Extract data from logsoutRes
        RL_fc = squeeze(TrackData.(trackFieldN{t_i}).(fntr{RL_inds(i)}).Data)';

        % Transpose scalar measurements for vecnorm calculation
        if(size(RL_fc,1)<size(RL_fc,2))
            RL_fc = RL_fc';
        end

        if(size(RL_fc,2)<3)
            error(['It appears constraint forces were not logged:' fntr{RL_inds(i)} ' has less than 3 elements'])
        end

        % Obtain magnitude of load (fx, fy, fz)
        if(strcmpi(forceType,'magnitude'))
            % Measure total magnitude
            fcR.(trackFieldN{t_i}).(fntr{RL_inds(i)}) = vecnorm(RL_fc,2,2);
        elseif(strcmpi(forceType,'vertical'))
            % Measure along vehicle vertical axis
            fcR.(trackFieldN{t_i}).(fntr{RL_inds(i)}) = -RL_fc(:,2);
        end
    end

    % Check for Sprocket, IdlerF data last (order rear to front)
    hasIdlerF  = find(matches(fntr,'XIdlerF'), 1);
    if(hasIdlerF)
        % If rear idler, sprocket reaction forces not needed
        xIDf_fc = squeeze(TrackData.(trackFieldN{t_i}).XIdlerF.Data)';
        if(strcmpi(forceType,'magnitude'))
            fcR.(trackFieldN{t_i}).xIDf = vecnorm(xIDf_fc,2,2);
        elseif(strcmpi(forceType,'vertical'))
            fcR.(trackFieldN{t_i}).xIDf = -xIDf_fc(:,2);
        end
    end
end

% Reuse figure if it exists, else create new figure
% Figure name
figString = ['h1_' mfilename];
% Only create a figure if no figure exists
figExist = 0;
fig_hExist = evalin('base',['exist(''' figString ''')']);
if (fig_hExist)
    figExist = evalin('base',['ishandle(' figString ') && strcmp(get(' figString ', ''type''), ''figure'')']);
end
if ~figExist
    fig_h = figure('Name',figString);
    assignin('base',figString,fig_h);
else
    fig_h = evalin('base',figString);
end
figure(fig_h)
clf(fig_h)

fcR_tracks = fieldnames(fcR);
num_tracks = length(fcR_tracks);
if(num_tracks==1)
    p_h=tiledlayout(1,1);
elseif(num_tracks==2)
    p_h=tiledlayout(2,1);
else
    p_h=tiledlayout(2,2);
end

for t_i = 1:num_tracks
    nexttile
    fcR_L_fields = fieldnames(fcR.(fcR_tracks{t_i}));

    for r_i = 1:length(fcR_L_fields)
        display_name = strrep(fcR_L_fields{r_i},'RL','Lower Roller ');
        display_name = strrep(display_name,'xSP','Sprocket');
        display_name = strrep(display_name,'xIDf','IdlerF');
        display_name = strrep(display_name,'xIDr','IdlerR');
        plot(simlog_t,fcR.(fcR_tracks{t_i}).(fcR_L_fields{r_i}),'DisplayName',display_name);
        hold on
        max_mag = max(max_mag,max(fcR.(fcR_tracks{t_i}).(fcR_L_fields{r_i})(ind_2sec:end)));
        min_mag = min(min_mag,min(fcR.(fcR_tracks{t_i}).(fcR_L_fields{r_i})(ind_2sec:end)));
    end
    max_mag = max(max_mag,1);
    min_mag = min(min_mag,1);

    hold off
    grid on
    box on

    title(['Roller Mechanical Loads (' forceType '), ' trackLogN{t_i}])
    ylabel('Force (N)')
    legend('Location','Best');
end

axisPadding = (max_mag-min_mag)*0.05;
yLims = [min_mag-axisPadding max_mag+axisPadding];
for c_i = 1:length(p_h.Children)
    if(strcmp(p_h.Children(c_i).Type,'axes'))
        set(p_h.Children(c_i),'yLim',yLims);
    end
end

% Remove temporary variables
clear simlog_t simlog_handles
clear simlog_R1i simlog_C1v temp_colororder

