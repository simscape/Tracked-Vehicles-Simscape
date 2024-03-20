function sm_excv_track_plot2trq(simlogRes)
% Code to plot simulation results from sm_excv_track_double
%% Plot Description:
%
% <enter plot description here if desired>
%
% Copyright 2016-2024 The MathWorks, Inc.

% Get simulation results
if(simlogRes.hasChild('Angular_Velocity_Source_L'))
    numTrks = 1;
    simlog_t     = simlogRes.Angular_Velocity_Source_L.t.series.time;
    simlog_trqL  = -simlogRes.Angular_Velocity_Source_L.t.series.values;
    if(simlogRes.hasChild('Track_L'))
        simlog_wSprk = simlogRes.Track_L.Undercarriage.Rollers.Revolute_Sprocket.Rz.w.series.values('deg/s');
    elseif(simlogRes.hasChild('Undercarriage'))
        simlog_wSprk = simlogRes.Undercarriage.Rollers.Revolute_Sprocket.Rz.w.series.values('deg/s');
    end
    if(simlogRes.hasChild('Angular_Velocity_Source_R'))
        numTrks = 2;
        simlog_trqR = -simlogRes.Angular_Velocity_Source_R.t.series.values;
    end
elseif(simlogRes.hasChild('Angular_Velocity_Source_FL'))
    numTrks = 4;
    simlog_t     = simlogRes.Angular_Velocity_Source_FL.t.series.time;
    simlog_trqFL  = -simlogRes.Angular_Velocity_Source_FL.t.series.values;
    simlog_wSprkFL = simlogRes.Track_FL.Undercarriage.Rollers.Revolute_Sprocket.Rz.w.series.values('deg/s');
    simlog_trqFR  = -simlogRes.Angular_Velocity_Source_FR.t.series.values;
    simlog_wSprkFR = simlogRes.Track_FR.Undercarriage.Rollers.Revolute_Sprocket.Rz.w.series.values('deg/s');
    simlog_trqRL  = -simlogRes.Angular_Velocity_Source_RL.t.series.values;
    simlog_wSprkRL = simlogRes.Track_RL.Undercarriage.Rollers.Revolute_Sprocket.Rz.w.series.values('deg/s');
    simlog_trqRR  = -simlogRes.Angular_Velocity_Source_RR.t.series.values;
    simlog_wSprkRR = simlogRes.Track_RR.Undercarriage.Rollers.Revolute_Sprocket.Rz.w.series.values('deg/s');
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

%temp_colororder = get(gca,'defaultAxesColorOrder');

% Plot results
simlog_handles(1) = subplot(2, 1, 1);
if(numTrks < 4)
    plot(simlog_t, simlog_wSprk, 'LineWidth', 1, 'DisplayName','y')
else    
    plot(simlog_t, simlog_wSprkFL, 'LineWidth', 1, 'DisplayName','FL')
    hold on
    plot(simlog_t, simlog_wSprkFR, 'LineWidth', 1, 'DisplayName','FR')
    plot(simlog_t, simlog_wSprkRL, 'LineWidth', 1, 'DisplayName','RL')
    plot(simlog_t, simlog_wSprkRR, 'LineWidth', 1, 'DisplayName','RR')
    hold off
end
grid on
title('Sprocket Rotational Speed')
ylabel('Speed (deg/s)')

simlog_handles(2) = subplot(2, 1, 2);
if(numTrks < 4)
    plot(simlog_t, simlog_trqL, 'LineWidth', 1,'DisplayName','Left');
    if(numTrks > 1)
        hold on
        plot(simlog_t, simlog_trqR, 'LineWidth', 1,'DisplayName','Right');
    end
elseif(numTrks == 4)
    plot(simlog_t, simlog_trqFL, 'LineWidth', 1,'DisplayName','FL');
    hold on
    plot(simlog_t, simlog_trqFR, 'LineWidth', 1,'DisplayName','FR');
    plot(simlog_t, simlog_trqRL, 'LineWidth', 1,'DisplayName','RL');
    plot(simlog_t, simlog_trqRR, 'LineWidth', 1,'DisplayName','RR');
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

