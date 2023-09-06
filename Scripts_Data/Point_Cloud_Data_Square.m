function ptcld = Point_Cloud_Data_Square(d1,d2,npts,varargin)
%Point_Cloud_Data_Brick Produce point cloud for exterior surface of a brick
%   [ptcld] = Point_Cloud_Data_Square(x,y,z)
%
%   You can specify:
%       x         length along (first column of ptcld)
%       y         length along (second column of ptcld)
%       z         length along (third column of ptcld)
%       pointset  'full':    corners, edges, and faces
%                 'corners': corners only
%   Point cloud data will be centered at [0,0,0]
%
% Copyright 2021-2023 The MathWorks, Inc.

% Default data to show diagram
if (nargin == 0)
    d1 = 3;
    d2 = 2;
    npts = [3 2];
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
    
    %xlabel(['x = ' num2str(x)],'Color','r');
    %ylabel(['y = ' num2str(y)],'Color','g');
    
    title(['[ptcld] = Point\_Cloud\_Data\_Square(x, y, z, pointset);']);
    hold off
    box on
    axis equal
    grid off
end