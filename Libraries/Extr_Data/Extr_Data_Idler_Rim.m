function [xy_data] = Extr_Data_Idler_Rim(r_rim, r_axle, r_lip, w_roll, varargin)
%Extr_Data_Idler_Rim Produce revolution data for the rim of an idler in a tracked vehicle.
%   [xy_data] = Extr_Data_Idler_Rim(r_rim, r_axle, r_lip, w_roll)
%   This function returns x-y data that when revolved about an axis
%   produces the face of an idler in a tracked vehicle.
%
%   You can specify:
%       Radius of rim                       r_rim
%       Radius of axle (hole in rim)        r_axle
%       Radius of lip at edge of rim        r_lip
%       Width of rolling face               w_roll
%
%   To see a plot showing parameter values, enter the name
%   of the function with no arguments
%   >> Extr_Data_Idler_Rim
%
%   To see a plot created with your parameter values,
%   add 'plot' as the final argument
%   >> Extr_Data_Idler_Rim(0.33,0.165,0.02,0.2,'plot')

% Copyright 2012-2024 The MathWorks, Inc.

% Default data to show diagram
if (nargin == 0)
    r_rim  = 0.33;
    r_axle = 0.5*r_rim;
    r_lip  = r_rim*0.05;
    w_roll = 0.2;
end

% Check if plot should be produced
if (isempty(varargin))
    showplot = 'n';
else
    showplot = varargin;
end

% Outer and inner arc
npts_lip  = 20;
angles_lip = linspace(0,180,npts_lip)';
arc_lip       = [sind(angles_lip) cosd(angles_lip)]*r_lip + [0 r_rim-r_lip];

xy_rim =[...
    arc_lip;...
    0 r_axle]+[w_roll/2 0];

xy_data = fliplr([...
    xy_rim;
    flipud(xy_rim.*[-1 1])]);

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
    axis('square');

    patch(-xy_data(:,1),xy_data(:,2),[1 1 1]*0.90,'EdgeColor','none');
    plot(-xy_data(:,1),xy_data(:,2),'-.','Marker','o','MarkerSize',4,'LineWidth',2);
    axis('square');
    hold off
    
    
    % Show parameters
    hold on
    plot([0 r_rim],[1 1]*w_roll/2+r_lip*4,'r-d','MarkerFaceColor','r','MarkerSize',10);
    text(r_rim/2,w_roll/2+r_lip*4,'r\_rim','VerticalAlignment','bottom');
    
    plot([0 r_axle],[1 1]*w_roll/2,'m-d','MarkerSize',10);
    text(r_axle/2,w_roll/2,'r\_axle','VerticalAlignment','bottom','HorizontalAlignment','center');
    
    plot([0 0],[-1 1]*w_roll/2,'b-d','MarkerFaceColor','b');
    text(0,0,'w\_roll','HorizontalAlignment','left');

    theta1 = 225;
    plot([0 r_lip*cos(theta1*pi/180)]+r_rim-r_lip,[0 r_lip*sin(theta1*pi/180)]-w_roll/2,...
        'g-d','MarkerFaceColor','g');
    text(r_lip*cos(theta1*pi/180)+r_rim-r_lip,r_lip*sin(theta1*pi/180)-w_roll/2,'r\_lip',...
        'HorizontalAlignment','right','VerticalAlignment','top');
    
    set(gca,'XLim',[-1 1]*(r_rim)*1.1);

    title('[xy\_data] = Extr\_Data\_Idler\_Rim(r\_rim,r\_axle,r\_lip,w\_roll);');
    hold off
    box on
    clear xy_data
    axis equal
end
