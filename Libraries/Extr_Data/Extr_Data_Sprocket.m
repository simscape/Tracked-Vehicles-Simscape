function [xy_data, rPitch] = Extr_Data_Sprocket(nTeeth,skipTeeth,linkLen,rRoller,varargin)
%Extr_Data_Sprocket Produce extrusion data for a sprocket.
%   Extr_Data_Sprocket(numTeeth,skipTeeth,linkLength,rRoller)
%   This function returns x-y data for a sprocket.
%   You can specify:
%       numTeeth      Number of teeth on the sprocket
%       skipTeeth     0 for normal, 1 for double pitch chain
%       linkLength    Length of chain links (roller to roller)
%       rRoller       Radius of roller
%       # holes 	  num_holes
%
%   To see a plot showing parameter values, enter the name
%   of the function with no arguments
%   >> Extr_Data_Sprocket
%
%   To see a plot created with your parameter values,
%   add 'plot' as the final argument
%   >> Extr_Data_Sprocket(22,1,0.2,0.03,'plot')
%
% Copyright 2014-2023 The MathWorks, Inc.

% Default data to show diagram
if (nargin == 0)
    nTeeth  = 22; % For 22 teeth on the gear
    skipTeeth = 1;
    linkLen = 0.2;
    rRoller = 0.03;
end

% Check if plot should be produced
if (isempty(varargin))
    showplot = 'n';
else
    showplot = char(varargin);
end

rOuter = linkLen / (2 * sin((2 * pi / (nTeeth/(skipTeeth+1))) / (skipTeeth+1) ));
rInner = rOuter - rRoller;

rPitch = rOuter; % Tooth gap could be deeper

firstToothAngle = deg2rad(0);
currentToothAngle = firstToothAngle;
xy_data = [];

for iTeeth = 1:nTeeth
    [newPoints, currentToothAngle] = computeCupPoints(currentToothAngle, rOuter, rInner, nTeeth);
    xy_data = [xy_data; newPoints]; %#ok<AGROW>
end

%% Orient sprocket so a tooth gap is directly behind sprocket center
% Find index of point at deepest point of one of the cups
[~,ind] = min(vecnorm(xy_data,2,2));

% Determine angle to rotate extrusion data
rotAngle = atan2d(xy_data(ind,2),xy_data(ind,1))+180;

% Construct rotation matrix
Rmat = [cosd(rotAngle) sind(rotAngle);
       -sind(rotAngle) cosd(rotAngle)];

% Rotate data
xy_data   = (Rmat*xy_data')';

%% Plot diagram to show parameters and extrusion
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
    plot(xy_data(:,1),xy_data(:,2),'-','Marker','.','MarkerSize',8,'LineWidth',0.5);

    axis('equal');
    axis([-1 1 -1 1]*rOuter*1.1);

    % Show parameters
    tAng    = 2*pi/nTeeth;
    tAngArr = tAng*[3 4 5]-pi;
    teeth_pts = 0.9*rInner*[cos(tAngArr(1)) sin(tAngArr(1));cos(tAngArr(2)) sin(tAngArr(2)); cos(tAngArr(3)) sin(tAngArr(3))];
    plot(teeth_pts(:,1),teeth_pts(:,2),'b-d','MarkerFaceColor','b');
    text(teeth_pts(2,1)*0.75,teeth_pts(2,2)*0.75,'{\color{blue}numTeeth}','HorizontalAlignment','center');

    %linkpt1 = [-rInner-rRoller 0];
    linkpt1 = [cos(tAng*(skipTeeth+1)-pi) sin(tAng*(skipTeeth+1)-pi)]*(rInner+rRoller);
    linkpt2 = [cos(tAng*(2*(skipTeeth+1))-pi) sin(tAng*(2*(skipTeeth+1))-pi)]*(rInner+rRoller);
    plot([linkpt1(1) linkpt2(1)],[linkpt1(2) linkpt2(2)],'k-d','MarkerFaceColor','k');
    text((linkpt1(1)+linkpt2(1))/2,(linkpt1(2)+linkpt2(2))/2,'{\color{black}linkLen}',...
        'HorizontalAlignment','right');

    rRollpt1 = linkpt1;
    rRollpt2 = linkpt1/(rInner+rRoller)*rInner;
    plot([rRollpt1(1) rRollpt2(1)],[rRollpt1(2) rRollpt2(2)],'r-d');
    text(rRollpt2(1),rRollpt2(2),'{\color{red}rRoller }','VerticalAlignment','bottom');

    title('[xy\_data] = Extr\_Data\_Sprocket(nTeeth,skipTeeth,linkLen,rRoller);');
    hold off
    box on
    clear xy_data

end


    function [cupPoints, endAngle] = computeCupPoints(beginAngle, rOuter, rInner, numTeeth)
    % Note - this method of constructing the tooth gap is not per any ISO norm
    %        and should be customized to your sprocket application

        toothFlatWidth = 0.1536;           % percentage
        cupFlatWidth   = 1-toothFlatWidth; % toothFlat + cupFlat = 100%
        
        cupAngle = deg2rad(360/numTeeth*cupFlatWidth);
        radDiff = rOuter - rInner;
        rads = [rInner + 1.0 * radDiff,...
            rInner + 0.8 * radDiff,...
            rInner + 0.55 * radDiff,...
            rInner + 0.35 * radDiff,...
            rInner + 0.21 * radDiff,...
            rInner + 0.12 * radDiff,...
            rInner + 0.07 * radDiff,...
            rInner + 0.03 * radDiff,...
            rInner + 0.01 * radDiff,...
            rInner + 0.002 * radDiff,...
            ];
        rads = [rads rInner fliplr(rads)];

        numCupPoints = length(rads);
        theta = cupAngle / (numCupPoints - 1);

        cupPoints = zeros(numCupPoints,2);
        for i = 1:numCupPoints
            rad = rads(i);
            pointAngle = beginAngle + (i - 1) * theta;
            cupPoints(i,:) = [rad * cos(pointAngle), rad * sin(pointAngle)];
        end

        toothAngle = deg2rad(360/numTeeth*toothFlatWidth);

        numToothPoints = 2;
        theta = toothAngle / (numToothPoints + 1);
        %cupPoints = [cupPoints];
        for i = numCupPoints+1:numCupPoints+numToothPoints
            pointAngle = beginAngle + cupAngle + (i - numCupPoints) * theta;
            cupPoints(i,:) = [rOuter * cos(pointAngle), rad * sin(pointAngle)];
        end

        endAngle = beginAngle + cupAngle + toothAngle;

    end
end