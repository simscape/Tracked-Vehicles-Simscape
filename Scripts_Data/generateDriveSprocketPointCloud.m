function [points, rPitch] = generateDriveSprocketPointCloud()

numLinks = 11; % For 22 teeth on the gear
linkLength = 0.2;
rPitch = linkLength / (2 * sin((2 * pi / numLinks) / 2));

rSphere = 0.03;
rInner = rPitch - rSphere;
rOuter = rPitch;

firstToothAngle = deg2rad(5.5);
%firstToothAngle = deg2rad(7);
currentToothAngle = firstToothAngle;
points = [];
while currentToothAngle < 2 * pi
    [newPoints, currentToothAngle] = computeCupPoints(currentToothAngle, rOuter, rInner);
    points = [points; newPoints]; %#ok<AGROW>

end

%% Orient sprocket so a
% Find index of point at deepest point of one of the cups
% This wil
[~,ind] = min(vecnorm(points,2,2));

rotAngle = atan2d(points(ind,2),points(ind,1))-90;
Rmat     = [cosd(rotAngle) sind(rotAngle) 0;
    -sind(rotAngle) cosd(rotAngle) 0;
    0               0             1];
points   = [Rmat*points']';


end


function [cupPoints, endAngle] = computeCupPoints(beginAngle, rOuter, rInner)

cupAngle = deg2rad(13.5);

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

cupPoints = zeros(numCupPoints,3);
for i = 1:numCupPoints
    rad = rads(i);
    pointAngle = beginAngle + (i - 1) * theta;
    cupPoints(i,:) = [rad * cos(pointAngle), rad * sin(pointAngle), 0.0];
end

toothAngle = deg2rad(2.85);
numToothPoints = 2;
theta = toothAngle / (numToothPoints + 1);
cupPoints = [cupPoints; zeros(numToothPoints, 3)];
for i = numCupPoints+1:numCupPoints+numToothPoints
    pointAngle = beginAngle + cupAngle + (i - numCupPoints) * theta;
    cupPoints(i,:) = [rOuter * cos(pointAngle), rad * sin(pointAngle), 0.0];
end

endAngle = beginAngle + cupAngle + toothAngle;

end