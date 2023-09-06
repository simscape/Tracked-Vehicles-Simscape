function [xy_data] = Extr_Data_TrapezoidRounded(lenL, lenU, rL, rU, riL, riU, xU, H, varargin)
%Extr_Data_TrapezoidRounded  Produce extrusion data for a trapezoid
%with rounded corners and a hole at each corner. 
%   [xy_data] = Extr_Data_TrapezoidRounded(Ll, Lu, rl, ru, ril, riu, xu, H)
%   This function returns x-y data for the trapezoid.
%   You can specify:
%       Distance between lower holes     Ll
%       Distance between upper holes     Lu
%       Outer radius lower holes         rl
%       Outer radius upper holes         ru
%       Inner radius lower holes         ril
%       Inner radius upper holes         riu
%       Offset from center upper holes   xu
%       Vertical offset between
%         lines connecting holes         H
%
%   To see a plot showing parameter values, enter the name
%   of the function with no arguments
%   >> Extr_Data_TrapezoidRounded
%
%   To see a plot created with your parameter values,
%   add 'plot' as the final argument
%   >> Extr_Data_TrapezoidRounded(2, 1, 0.3, 0.2,0.05, 0.1, 0.2, 0.5, 'plot')
%
% Copyright 2014-2023 The MathWorks, Inc.

% Default data to show diagram
if (nargin == 0)
    lenL  =  2;
    lenU  =  1;
    rL  =  0.3;
    rU  =  0.2;
    riL =  0.2;
    riU =  0.1;
    xU  =  0.2;
    H   =  0.5;
end

% Check if plot should be produced
if (isempty(varargin))
    showplot = 'n';
else
    showplot = char(varargin);
end

% Determine distance between circles on left
dxL = (lenL-lenU)/2+xU;
dcirclesL = sqrt(dxL^2+H^2);
angleL = -atand(H/dxL);
[xy_dataL] = Extr_Data_Cam_Circles(rL, rU, dcirclesL, riL, riU);

% Rotate left side
RL = [cosd(angleL) -sind(angleL);       % Rotation matrix
      sind(angleL) cosd(angleL)];             
xy_dataL = xy_dataL*RL;                 % Perform rotation

% Shift to left edge
xy_dataL = xy_dataL - [lenL/2 0];              

% Find set of points inside trapezoid to eliminate
indLmin = find(xy_dataL(:,2)==min(xy_dataL(:,2)));
indLmax = find(xy_dataL(:,2)==max(xy_dataL(:,2)));

% Determine distance between circles on right
dxR = (lenL-lenU)/2-xU;
dcirclesR = sqrt(dxR^2+H^2);
angleR = -180+atand(H/dxR);

[xy_dataR] = Extr_Data_Cam_Circles(rL, rU, dcirclesR, riL, riU);

% Flip data so we can eliminate points inside trapezoid
xy_dataR = flipud(xy_dataR.*[1,-1]);

% Rotate right circles
RR = [cosd(angleR) -sind(angleR);       % Rotation matrix
      sind(angleR) cosd(angleR)];             
xy_dataR = xy_dataR*RR + [lenL/2 0];    % Perform rotation

% Find set of points inside trapezoid to eliminate
indRmin = find(xy_dataR(:,2)==min(xy_dataR(:,2)));
indRmax = find(xy_dataR(:,2)==max(xy_dataR(:,2)));

% Create trapezoid by assembling outer points from both sets
xy_data = [...
    xy_dataL(1:indLmin,:);
    xy_dataR(indRmin:end,:);
    xy_dataR(1:indRmax,:);
    xy_dataL(indLmax:end,:)];

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
    % Intermediate extrusion data - save for debugging
    %{
    patch(xy_dataL(:,1),xy_dataL(:,2),[1 1 1]*0.95,'EdgeColor','none');
    hold on
    plot(xy_dataL(:,1),xy_dataL(:,2),'-','Marker','o','MarkerSize',4,'LineWidth',2);
    patch(xy_dataR(:,1),xy_dataR(:,2),[1 1 1]*0.95,'EdgeColor','none');
    hold on
    plot(xy_dataR(:,1),xy_dataR(:,2),'-','Marker','o','MarkerSize',4,'LineWidth',2);
    %}

    patch(xy_data(:,1),xy_data(:,2),[1 1 1]*0.95,'EdgeColor','none');
    hold on
    plot(xy_data(:,1),xy_data(:,2),'-','Marker','x','MarkerSize',4,'LineWidth',2);
    axis('equal');
    
    % Show parameters
    plot([-1/2 1/2]*lenL,[0 0],'r-d','MarkerFaceColor','r');
    text(0,H/15,'{\color{red}lenL}','VerticalAlignment','top');
    plot([-1/2 1/2]*lenU+xU,[H H],'r-d','MarkerFaceColor','r');
    text(xU,H*(1+1/15),'{\color{red}lenU}');
    plot([-lenL/2 -lenL/2-rL*sin(30*pi/180)],[0 -rL*cos(30*pi/180)],'k-d','MarkerFaceColor','k');
    text(-lenL/2-rL*sin(30*pi/180)*0.75,-0.75*rL*cos(30*pi/180),'rL');
    plot([lenU/2+xU +lenU/2+rU*sin(30*pi/180)+xU],[H H+rU*cos(30*pi/180)],'k-d','MarkerFaceColor','k');
    text(lenU/2+rU*sin(30*pi/180)*1.2+xU,H+rU*cos(30*pi/180)*1.2,'rU');
    plot([lenL/2 lenL/2+riL*sin(10*pi/180)],[0 riL*cos(10*pi/180)],'b-d','MarkerSize',8);
    text(lenL/2+riL*sin(10*pi/180)*1.25,1.25*riL*cos(10*pi/180),'{\color{blue}riL}');
    plot([-lenU/2+xU -lenU/2+riU*sin(10*pi/180)+xU],[H H+riU*cos(10*pi/180)],'b-d','MarkerSize',8);
    text(-lenU/2+riU*sin(10*pi/180)*1.5+xU,H+riU*cos(10*pi/180)*1.5,'{\color{blue}riU}');
    plot([-lenU/2+xU -lenU/2+xU],[0 H],'m-d','MarkerSize',8);
    text(-lenU/2+xU,H/2,'{\color{magenta}H}');
    plot([0 0 xU xU],[0 H/2 H/2 H],'c-d','MarkerFaceColor','c');
    text(xU/2, H/2,'{\color{cyan}xU}','VerticalAlignment','baseline');

    title('[xy\_data] = Extr\_Data\_TrapezoidRounded(lenL, lenU, rL, rU, riL, riU, xU, H);');
    hold off
    box on
 
end


