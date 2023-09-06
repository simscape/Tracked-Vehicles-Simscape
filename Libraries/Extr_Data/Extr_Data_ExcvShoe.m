function [xy_data] = Extr_Data_ExcvShoe(L, h, hp, wgo, wgi, ngr, varargin)
%Extr_Data_ExcvShoe Produce extrusion data for a link with an arbitrary
%number of holes and rounded ends.
%   [xy_data] = Extr_Data_ExcvShoe(L, h, hp, wgo, wgi, ngr)
%   This function returns x-y data for a link with half a hole at one end.
%   You can specify:
%       Length                 L
%       Height                 h
%       Width outer grouser    wgo
%       Width inner grouser    wgi
%       Number of grousers     ngr
%
%   To see a plot showing parameter values, enter the name
%   of the function with no arguments
%   >> Extr_Data_ExcvShoe
%
%   To see a plot created with your parameter values,
%   add 'plot' as the final argument
%   >> Extr_Data_ExcvShoe(0.2, 0.03,0.005, 0.019, 0.013, 3,'plot')
%
% Copyright 2014-2023 The MathWorks, Inc.

% Default data to show diagram
if (nargin == 0)
    L  = 0.25;
    h  = 0.03;
    hp = 0.005;
    wgo = 0.018;
    wgi = 0.013;
    ngr = 3;
end

% Check if plot should be produced
if (isempty(varargin))
    showplot = 'n';
else
    showplot = char(varargin);
end

gg = (L-wgo*2-wgi*(ngr-2))/(ngr-1); % Grouser Gaps

x = L;
for i = 1:(ngr-1)
    if((2*i)==2)
        x((2*i)) = x((2*i-1))-wgo;
    else
        x((2*i)) = x((2*i-1))-wgi;
    end
        
    x((2*i)+1) = x((2*i))-gg;
end

x = x(2:end);
xy_data1 = [...
    0 h;
    0 0;
    L 0;
    L h];

for i=1:2:length(x)
    xy_data2(2*i-1,:) = [x(i)   h];
    xy_data2(2*i,:) = [x(i)   hp];
    xy_data2(2*i+1,:) = [x(i+1) hp];
    xy_data2(2*i+2,:)   = [x(i+1)  h];
end

xy_data = [xy_data1;xy_data2];

xy_data = xy_data - [L/2 0];

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
    patch(xy_data(:,1),xy_data(:,2),[1 1 1]*0.95,'EdgeColor','none');
    hold on
    plot(xy_data(:,1),xy_data(:,2),'-','Marker','o','MarkerSize',4,'LineWidth',2);
    
    axis('equal');
    axis padded;
    
    % Show parameters
    plot([-L/2 L/2],[-1 -1]*h*0.5,'r-d','MarkerFaceColor','r');
    text(0,-h*0.5,'{\color{red}L}','VerticalAlignment','top');
    plot([L/4 L/4],[0 h],'b-d','MarkerFaceColor','b');
    text(L/4,h/2,'{\color{blue} h}','HorizontalAlignment','left');
    plot([-L/4 -L/4],[0 hp],'b-d','MarkerFaceColor','b');
    text(-L/4,hp*1.5,'{\color{blue}hp}','HorizontalAlignment','center',...
        'VerticalAlignment','baseline');
    plot([-L/2 -L/2+wgo],[1 1]*h*1.1,'r-d','MarkerFaceColor','r');
    text(-L/2+wgo/2,h*1.2,'{\color{red}wgo}','HorizontalAlignment','center',...
        'VerticalAlignment','baseline');
    plot([-wgi/2 wgi/2],[1 1]*h*1.1,'r-d','MarkerFaceColor','r');
    text(0,h*1.2,'{\color{red}wgi}','HorizontalAlignment','center',...
        'VerticalAlignment','baseline');
    plot([-L/2+wgo/2 0 +L/2-wgo/2],[1 1 1]*3*h/4,'k--','Marker','d','MarkerFaceColor','k');
    text(-L/8,3*h/4,'{\color{black}ngr}','HorizontalAlignment','center',...
        'VerticalAlignment','top');
    

    %{    
    plot([-L/2 -L/2+r*sin(30*pi/180)],[0 r*cos(30*pi/180)],'k-d','MarkerFaceColor','k');
    text(-L/2+r*sin(30*pi/180)*1.4,1.4*r*cos(30*pi/180),'r');
    %}
    
    title('[xy\_data] = Extr\_Data\_ExcvShoe(L, h, hp, wgo, wgi, ngr);');
    hold off
    box on
    clear xy_data
end


