function [xy_data] = Extr_Data_Sprocket_Spoke(n_spk, rad_o, rad_i, rad_r, rad_h,varargin)
%Extr_Data_Sprocket_Spoke Produce extrusion data for a cam formed from two circles.
%   [xy_data] = Extr_Data_Sprocket_Spoke(n_spk, rad_o, rad_i, rad_r, rad_h)
%   This function returns x-y data for a cam formed from two circles
%   that are connected by lines tangent to the circles.
%
%   You can specify:
%       Number of spokes (for sweep angle)     n_spk
%       Outer radius                           rad_o
%       Inner radius                           rad_i
%       Radius to hole center                  rad_r
%       Radius of hole                         rad_h
%
%   To see a plot showing parameter values, enter the name
%   of the function with no arguments
%   >> Extr_Data_Sprocket_Spoke
%
%   To see a plot created with your parameter values,
%   add 'plot' as the final argument
%   >> Extr_Data_Sprocket_Spoke(21,0.5,0.25,0.375,0.0375,'plot')

% Copyright 2012-2025 The MathWorks, Inc.

% Default data to show diagram
if (nargin == 0)
    n_spk = 21;
    rad_o = 0.504;
    rad_i = rad_o/2;
    rad_r = rad_o*3/4;
    rad_h = rad_o*0.075;
end

% Check if plot should be produced
if (isempty(varargin))
    showplot = 'n';
else
    showplot = varargin;
end

% Outer and inner arc
npts_arc  = ceil(360/n_spk/2);
sweep_arc = 360/n_spk;
angle_arc = linspace(0,sweep_arc,npts_arc)';
arc_o    = [sind(angle_arc) cosd(angle_arc)]*rad_o;
arc_i    = [sind(angle_arc) cosd(angle_arc)]*rad_i;

npts_hole   = 20;
angles_hole = linspace(0,180,npts_hole)';
arc_h       = [sind(angles_hole) cosd(angles_hole)]*rad_h;
arc_h_off_A = arc_h + [0 rad_r];

RR = [cosd(sweep_arc) -sind(sweep_arc);       % Rotation matrix
      sind(sweep_arc) cosd(sweep_arc)];             
arc_h_off_B = (arc_h_off_A.*[-1 1])*RR;

xy_spoke =[...
    flipud(arc_o);...
    arc_h_off_A;...
    arc_i;...
    flipud(arc_h_off_B)];

RRbh = [cosd(-sweep_arc*0.5+90) -sind(-sweep_arc*0.5+90);       % Rotation matrix
        sind(-sweep_arc*0.5+90)  cosd(-sweep_arc*0.5+90)];             

xy_data = xy_spoke*RRbh;

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
    
    % Plot extrusion data
    patch(xy_data(:,1),xy_data(:,2),[1 1 1]*0.90,'EdgeColor','none');
    hold on
    plot(xy_data(:,1),xy_data(:,2),'-','Marker','o','MarkerSize',4,'LineWidth',2);
    set(gca,'XLim',[-rad_o*0.05 rad_o*1.05]);
    
    % Show parameters
    hold on
    plot([0 rad_o],[0 0],'k-d','MarkerSize',10);
    text(rad_o/4,0,'rad\_o','VerticalAlignment','baseline');

    plot([0 rad_i*cosd(sweep_arc/2)],[0 rad_i*sind(sweep_arc/2)],'r-x','MarkerSize',10,'MarkerFaceColor','r');
    text(rad_i*cosd(sweep_arc/2)/2,rad_i*sind(sweep_arc/2)/2,'{\color{red}rad\_i}',...
        'HorizontalAlignment','right','VerticalAlignment','baseline');

    plot([0 rad_r*cosd(-sweep_arc/2)],[0 rad_r*sind(-sweep_arc/2)],'b-d','MarkerSize',4,'MarkerFaceColor','b');
    text(rad_r*cosd(-sweep_arc/2)/2,rad_r*sind(-sweep_arc/2)/2,'{\color{blue}rad\_r}',...
        'HorizontalAlignment','right','VerticalAlignment','top');

    plot([0 rad_h*cosd(-45)]+rad_r*cosd(sweep_arc/2),...
        [0 rad_h*sind(-45)]+rad_r*sind(sweep_arc/2),'m-d','MarkerSize',4,'MarkerFaceColor','m');
    text(rad_r*cosd(sweep_arc/2),rad_r*sind(sweep_arc/2),'rad\_h',...
        'HorizontalAlignment','right','VerticalAlignment','baseline');

    title('[xy\_data] = Extr\_Data\_Sprocket\_Spoke(n\_spk,rad\_o,rad\_i,rad\_r,rad\_h);');
    hold off
    box on
    clear xy_data
    axis('equal');

end
