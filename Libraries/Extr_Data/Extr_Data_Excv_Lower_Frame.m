function [xy_tread, ptlabels] = Extr_Data_Excv_Lower_Frame(Lower_Frame,varargin)
% Function to create extrusion for arm from pin locations

% Copyright 2022-2025 The MathWorks, Inc

% Check if plot should be produced
if (isempty(varargin))
    showplot = 'n';
else
    showplot = char(varargin);
end

% Extract points from structure
A = [Lower_Frame.Ground.x        Lower_Frame.Ground.z];
B = [Lower_Frame.Upper_Frame.x   Lower_Frame.Upper_Frame.z];
C = [Lower_Frame.Front_Roller.x  Lower_Frame.Front_Roller.z];
D = [Lower_Frame.Rear_Roller.x   Lower_Frame.Rear_Roller.z];
X = [Lower_Frame.CG.x            Lower_Frame.CG.z];

ptlabels.A = A;
ptlabels.B = B;
ptlabels.C = C;
ptlabels.D = D;
ptlabels.X = X;

% Create extrusion, cab low
lenLow  = C(1)-D(1);
lenUpp  = lenLow*0.7;
radLow  = lenLow/8;
radUpp  = radLow*0.8;
xOffset = -(C(1)+D(1))/2;
height  = B(2)-radLow-radUpp;

[xy_tread] = Extr_Data_TrapezoidRounded(lenLow, lenUpp, radLow, radUpp,0, 0, xOffset, height);

xy_tread = xy_tread + [-xOffset radLow];

% Plot diagram to show parameters and extrusion
if (nargin == 0 || strcmpi(showplot,'plot'))
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
    
    % Plot extrusion
    patch(xy_tread(:,1),xy_tread(:,2),[1 1 0]*0.95,'EdgeColor','none');
    hold on
    plot(xy_tread(:,1),xy_tread(:,2),'-','Marker','.','MarkerSize',4,'LineWidth',1);

    hold off
    box on
    axis('equal');
    title('[xy\_cabLow, xy\_cabUpp] = Extr\_Data\_Excv\_Upper_Frame(Upper_Frame)');

    % Show parameters
    text(A(1),A(2),'{\color{red}A}','HorizontalAlignment','center','VerticalAlignment','middle');
    text(B(1),B(2),'{\color{red}B}','HorizontalAlignment','center','VerticalAlignment','middle');
    text(C(1),C(2),'{\color{red}C}','HorizontalAlignment','center','VerticalAlignment','middle');
    text(D(1),D(2),'{\color{red}D}','HorizontalAlignment','center','VerticalAlignment','middle');
    text(X(1),X(2),'{\color{black}X}','HorizontalAlignment','center','VerticalAlignment','middle');
end
