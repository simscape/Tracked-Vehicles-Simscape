function sm_excv_track_plot4xy(simlogRes)
% Code to plot simulation results from sm_excv_track_double
%% Plot Description:
%
% <enter plot description here if desired>
%
% Copyright 2016-2024 The MathWorks, Inc.

if(~simlogRes.hasChild('Assembly_to_World'))
    error('Could not find Assembly_to_World in simlog results');
end

% Get simulation results
simlog_t = simlogRes.Assembly_to_World.Px.p.series.time;
simlog_px = simlogRes.Assembly_to_World.Px.p.series.values;
simlog_py = simlogRes.Assembly_to_World.Py.p.series.values;

%simlog_trqL = -simlogRes.Angular_Velocity_Source_L.t.series.values;

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

temp_colororder = get(gca,'defaultAxesColorOrder');

% Plot results
plot(simlog_px,simlog_py, 'LineWidth', 1, 'DisplayName','position')
text(0.01,1.01,['XFinal = ' sprintf('%2.2f',simlog_px(end)), ', YFinal = ' sprintf('%2.2f',simlog_py(end))],...
    'Units','Normalized','Color',[1 1 1]*0.5,'VerticalAlignment','baseline')
grid on
title('Position')
xlabel('m')
ylabel('m')
axis equal

% Remove temporary variables
clear simlog_t simlog_handles
clear simlog_R1i simlog_C1v temp_colororder

