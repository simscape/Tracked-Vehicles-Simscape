function ptcld = Point_Cloud_Data_Square(d1,d2,npts,varargin)
%Point_Cloud_Data_Brick Produce point cloud covering a square
%   [ptcld] = Point_Cloud_Data_Square(d1,d2,npts)
%
%   You can specify:
%       d1         length along x
%       d2         length along y
%       npts       [number of points along x, number of points along y]
%   Point cloud data will be centered at [0,0,0]
%
% Copyright 2021-2024 The MathWorks, Inc.

% Default data to show diagram
if (nargin == 0)
    d1 = 3;
    d2 = 2;
    npts = [5 4];
end

% Check if plot should be produced
if (isempty(varargin))
    showplot = 'n';
else
    showplot = varargin;
end

d1_locs = linspace(0,d1,npts(1))-d1/2;
d2_locs = linspace(0,d2,npts(2))-d2/2;

[pts_set1_grid_x,pts_set1_grid_y] = meshgrid(d1_locs, d2_locs);
pts_set1      = [reshape(pts_set1_grid_x,[],1) reshape(pts_set1_grid_y,[],1)];

d1_int  = mean([d1_locs(1:end-1);d1_locs(2:end)]);
d2_int  = mean([d2_locs(1:end-1);d2_locs(2:end)]);
[pts_set2_grid_x,pts_set2_grid_y] = meshgrid(d1_int,d2_int);
pts_set2      = [reshape(pts_set2_grid_x,[],1) reshape(pts_set2_grid_y,[],1)];

ptcld = [pts_set1;pts_set2];

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
    
    temp_colororder = get(gca,'defaultAxesColorOrder');
    
    plot(ptcld(:,1),ptcld(:,2),'o','MarkerFaceColor',temp_colororder(2,:))
    hold on

    plot([1 1]*0.1*d1,[-0.5 0.5]*d2,'r--d','MarkerFaceColor','r');
    text(0.1*d1,0.6*0.5*d2,'{\color{red} d2}','HorizontalAlignment','left');

    plot([-0.5 0.5]*d1,[1 1]*0.1*d2,'b--d','MarkerFaceColor','b');
    text(0.6*0.5*d1,0.1*d2,'{\color{blue} d1}','VerticalAlignment','top');

    plot(d1_locs,ones(1,length(d1_locs))*0.45*d2,'c--d');
    text(mean(d1_locs(1:2)),0.45*d2,'{\color{cyan} npts(1)}',...
        'HorizontalAlignment','center','VerticalAlignment','top');
    
    plot(-ones(1,length(d2_locs))*0.45*d1,d2_locs,'k--d');
    text(-0.45*d1,mean(d2_locs(1:2))*0.75,'{\color{black} npts(2)}',...
        'HorizontalAlignment','left');
    
    title(['[ptcld] = Point\_Cloud\_Data\_Square(d1, d2, npts);']);
    hold off
    box on
    axis equal
    grid off
end