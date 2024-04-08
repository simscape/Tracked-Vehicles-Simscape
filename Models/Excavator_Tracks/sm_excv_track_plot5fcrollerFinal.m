function sm_excv_track_plot5fcrollerFinal(mdl, fcR)
% Code to plot simulation results from excavator models
%% Plot Description:
%
% Plots final value of roller constraint forces

fc_SS = [];
trkNames = fieldnames(fcR);
for t_i = 1:length(trkNames)
    rlNames = fieldnames(fcR.(trkNames{t_i}));
    for r_i = 1:length(rlNames)
        fc_trace = fcR.(trkNames{t_i}).(rlNames{r_i});
        fc_SS(r_i,t_i) = fc_trace(end);
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

bar(fc_SS);
ylimRoll = get(gca,'YLim');

title(['Roller Loads ' strrep(mdl,'_','\_')]);
legend(strrep(trkNames,'_','\_'),'Location','Best')
xticklabels(rlNames)

