function [xy_data] = Extr_Data_Belt_Frame(C, R, varargin)
%Extr_Data_Belt_Frame Produce extrusion data for a cam formed from two circles.
%   [xy_data] = Extr_Data_Cam_Circles(rad1, rad2, d, radh1, radh2)
%   This function returns x-y data for a cam formed from two circles
%   that are connected by lines tangent to the circles.
%
%   You can specify:
%       Radius, circle 1                       rad1
%       Radius, circle 2                       rad2
%       Radius, circle 3                       rad3
%       Distance between lower holes           L
%       Distance from line connecting          H
%        lower holes to uppper hole     
%       Top hole offset (0-1)*L          xL
%       Radius of hole at center of circle 1   radh1
%       Radius of hole at center of circle 2   radh2
%       Radius of hole at center of circle 3   radh3
%
%   To see a plot showing parameter values, enter the name
%   of the function with no arguments
%   >> Extr_Data_Triangle_RoundCorners
%
%   To see a plot created with your parameter values,
%   add 'plot' as the final argument
%   >> Extr_Data_Triangle_RoundCorners(4,3,5,1,0,'plot')

% Copyright 2012-2024 The MathWorks, Inc.

% Default data to show diagram
if (nargin == 0)
  C = [0 0;-1 -1;-1 2];
  R = [0.5;0.2;0.2];
end

% Check if plot should be produced
if (isempty(varargin))
    showplot = 'n';
else
    showplot = varargin;
end

% Create sets of points for all rollers

npts     = 20;
thetaSet = linspace(0,360-360/npts,npts);
unitCircle = [cosd(thetaSet)'  sind(thetaSet)'];

ptset = [];
for i = 1:length(R)
    ptset = [ptset;unitCircle*R(i)+C(i,:)];
end

k = convhull(ptset);

xy_data = ptset(k(1:end-1),:);

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
    
    for i = 1:length(R)
        ptset = unitCircle*R(i)+C(i,:);
        plot(ptset(:,1),ptset(:,2),'c')
    end    
    title(['[xy\_data] = Extr\_Data\_Belt\_Frame(C, R);']);
    hold off
    box on
    axis('equal');
    clear xy_data
end
