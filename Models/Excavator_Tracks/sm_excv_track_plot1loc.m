function sm_excv_track_plot1loc(simlogRes,logsoutRes)
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
simlog_pz = simlogRes.Assembly_to_World.Pz.p.series.values;

%simlog_trqL = -simlogRes.Angular_Velocity_Source_L.t.series.values;

simlog_aRoll = squeeze(logsoutRes.get('Body').Values.aRoll.Data);
simlog_aPitch = squeeze(logsoutRes.get('Body').Values.aPitch.Data);

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
simlog_handles(1) = subplot(2, 1, 1);
%plot(simlog_t, simlog_px, 'LineWidth', 1, 'DisplayName','x')
plot(simlog_t, simlog_py, 'LineWidth', 1, 'DisplayName','y')
hold on
plot(simlog_t, simlog_pz, 'LineWidth', 1, 'DisplayName','z')
hold off
text(0.01,1.07,['XFinal = ' sprintf('%2.2f',simlog_px(end))],...
    'Units','Normalized','Color',[1 1 1]*0.5)
grid on
title('Distance')
ylabel('Distance (m)')
legend('Location','Best');

simlog_handles(2) = subplot(2, 1, 2);
plot(simlog_t, simlog_aPitch*180/pi, 'LineWidth', 1,...
    'Color',temp_colororder(3,:),'DisplayName','Pitch Angle');
hold on
plot(simlog_t, simlog_aRoll*180/pi, 'LineWidth', 1,...
    'Color',temp_colororder(4,:),'DisplayName','Roll Angle');
hold off

grid on
title('Body Pitch and Roll Angles')
ylabel('Angle (deg)')
xlabel('Time (s)')
legend('Location','Best');


linkaxes(simlog_handles, 'x')

% Remove temporary variables
clear simlog_t simlog_handles
clear simlog_R1i simlog_C1v temp_colororder

