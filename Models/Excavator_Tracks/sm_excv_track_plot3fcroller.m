function sm_excv_track_plot3fcroller(logsoutRes)
% Code to plot simulation results from excavator models
%% Plot Description:
%
% This function plots the in-plane loads on the lower track rollers. If
% results for both left and right tracks are available, two plots are made.
%
% Copyright 2016-2024 The MathWorks, Inc.

% Get simulation results

% Assume left track data is available
if(find(contains(logsoutRes.getElementNames,'Track L')))
    TrackLRes = logsoutRes.get('Track L').Values.Underc;
elseif(~isempty(find(contains(logsoutRes.getElementNames,'Track FL'), 1)))
    TrackLRes = logsoutRes.get('Track FL').Values.Underc;
end

% Check if right track data is available
elList = getElementNames(logsoutRes);
hasTrackR  = find(matches(elList,'Track R'), 1);
hasTrackFR = find(matches(elList,'Track FR'), 1);
TrackRRes= [];
if(~isempty(hasTrackR))
    TrackRRes = logsoutRes.get('Track R').Values.Underc;
end
if(~isempty(hasTrackFR))
    hasTrackR = hasTrackFR;
    TrackRRes = logsoutRes.get('Track FR').Values.Underc;
end

% Get field names from left track results
fnl = fieldnames(TrackLRes);

% Find data for lower rollers - name is RL##
pat = "RL"+digitsPattern(1,100);
RL_inds = find(startsWith(fnl,pat));

% Get time data
simlog_t = TrackLRes.(fnl{RL_inds(1)}).Time;

% Exclude first two seconds for setting vertical range of plot
if(simlog_t(end)<2)
    error('Simulation must run longer than 2 seconds')
else
    ind_2sec = find(simlog_t>2,1);
end
max_mag = 0;

% Loop over fields with roller data
for i = 1:length(RL_inds)
    % Extract data from logsoutRes
    RL_fc = squeeze(TrackLRes.(fnl{RL_inds(i)}).Data)';

    % Transpose scalar measurements for vecnorm calculation
    if(size(RL_fc,1)<size(RL_fc,2))
        RL_fc = RL_fc'; 
    end

    % Obtain magnitude of load (fx, fy, fz)
    fcR_L.(fnl{RL_inds(i)}) = vecnorm(RL_fc,2,2);

    % Save max value of all loads after 2 seconds for axes limits
    max_mag = max(max_mag,max(fcR_L.(fnl{RL_inds(i)})(ind_2sec:end)));
end

% Repeat process for right track if data exists
if(~isempty(hasTrackR))
    % Get field names from left track results
    fnr = fieldnames(TrackRRes);

    % Find data for lower rollers - name is RL##
    pat = "RL"+digitsPattern(1,100);
    RL_inds = find(startsWith(fnr,pat));

    % Loop over fields with roller data
    for i = 1:length(RL_inds)
        % Extract data from logsoutRes
        RL_fc = squeeze(TrackRRes.(fnr{RL_inds(i)}).Data)';

        % Transpose scalar measurements for vecnorm calculation
        if(size(RL_fc,1)<size(RL_fc,2))
            RL_fc = RL_fc';
        end

        % Obtain magnitude of load (fx, fy, fz)
        fcR_R.(fnr{RL_inds(i)}) = vecnorm(RL_fc,2,2);

        % Save max value of all loads after 2 seconds for axes limits
        max_mag = max(max_mag,max(fcR_R.(fnr{RL_inds(i)})(ind_2sec:end)));
    end
end
max_mag = max(max_mag,1);

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

%temp_colororder = get(gca,'defaultAxesColorOrder');

% Plot results
if(~isempty(hasTrackR))
    simlog_handles(1) = subplot(2, 1, 1);
end

fcR_L_fields = fieldnames(fcR_L);

for i = 1:length(fcR_L_fields)
    display_name = strrep(fcR_L_fields{i},'RL','Lower Roller ');
    plot(simlog_t,fcR_L.(fcR_L_fields{i}),'DisplayName',display_name);
    hold on
end
hold off
grid on
box on
title('Roller Mechanical Loads (In-Plane), Track L')
ylabel('Force (N)')
set(gca,'YLim',[0 max_mag*1.1]);
legend('Location','Best');


if(~isempty(hasTrackR))
    simlog_handles(2) = subplot(2, 1, 2);

    fcR_R_fields = fieldnames(fcR_R);

    for i = 1:length(fcR_R_fields)
        display_name = strrep(fcR_R_fields{i},'RL','Lower Roller ');
        plot(simlog_t,fcR_R.(fcR_R_fields{i}),'DisplayName',display_name);
        hold on
    end
    hold off
    grid on
    box on
    title('Roller Mechanical Loads (In-Plane), Track R')
    ylabel('Force (N)')
    set(gca,'YLim',[0 max_mag*1.1]);
    linkaxes(simlog_handles,'x');
    grid on
    xlabel('Time (s)')
else
    xlabel('Time (s)')
end



%linkaxes(simlog_handles, 'x')

% Remove temporary variables
clear simlog_t simlog_handles
clear simlog_R1i simlog_C1v temp_colororder

