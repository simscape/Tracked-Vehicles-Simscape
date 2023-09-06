function sm_excv_track_plot2trq(simlogRes)
% Code to plot simulation results from sm_excv_track_double
%% Plot Description:
%
% <enter plot description here if desired>
%
% Copyright 2016 The MathWorks, Inc.

% Get simulation results
simlog_t = simlogRes.Angular_Velocity_Source_L.t.series.time;

simlog_trqL = -simlogRes.Angular_Velocity_Source_L.t.series.values;
simlog_wSprk = simlogRes.Track_L.Undercarriage.Rollers.Revolute_Sprocket.Rz.w.series.values('deg/s');

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
simlog_handles(1) = subplot(2, 1, 1);
%plot(simlog_t, simlog_px, 'LineWidth', 1, 'DisplayName','x')
plot(simlog_t, simlog_wSprk, 'LineWidth', 1, 'DisplayName','y')
grid on
title('Sprocket Rotational Speed')
ylabel('Speed (deg/s)')

simlog_handles(2) = subplot(2, 1, 2);
plot(simlog_t, simlog_trqL, 'LineWidth', 1,'DisplayName','Left');
if(simlogRes.hasChild('Angular_Velocity_Source_R'))
    hold on
    simlog_trqR = -simlogRes.Angular_Velocity_Source_R.t.series.values;
    plot(simlog_t, simlog_trqR, 'LineWidth', 1,'DisplayName','Right');
    hold off
end
grid on
title('Drive Torque')
ylabel('Torque (N*m)')
xlabel('Time (s)')
legend('Location','Best');


linkaxes(simlog_handles, 'x')

% Remove temporary variables
clear simlog_t simlog_handles
clear simlog_R1i simlog_C1v temp_colororder

