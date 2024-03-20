function [ptcld_grousers, ptcld_plate, ptcld_profile] = track_shoe_ptcloud_createFromSTL(stlfilename,varargin)
%track_shoe_ptcloud_createFromSTL Produce point cloud data from track shoe STL file.
%   [ptcld_grousers, ptcld_plate] = track_shoe_ptcloud_createFromSTL(stlfilename,<point_option>)  
%   This function returns x-y-z data extracted from STL geometry.
%
%  [ptcld_grousers, ptcld_plate] = track_shoe_ptcloud_createFromSTL('CAD_Track_Shoe.STL');

% Read in STL file
trshoe_stl_pts = stlread(stlfilename);
%numPtsAll = size(trshoe_stl_pts.Points,1);

% Extract unique points
trshoe_stl_pts_unique = unique(trshoe_stl_pts.Points,'Rows');

% Extract all points within the plane z=4
ind_z_lim = intersect(...
    find(trshoe_stl_pts_unique(:,3) >= 3.95),...
    find(trshoe_stl_pts_unique(:,3) <= 4.05));
trshoe_stl_pts_unique_z  = trshoe_stl_pts_unique(ind_z_lim,:);
%numPtsUZ = length(trshoe_stl_pts_unique_z);

% Extract points above height 37.455 mm
ind_y_lim = trshoe_stl_pts_unique_z(:,2) >= 37.455;
trshoe_stl_pts_unique_yz  = trshoe_stl_pts_unique_z(ind_y_lim,:);
%numPtsUYZ = length(trshoe_stl_pts_unique_yz);

% Create 20 locations for points along the width of the track shoe
% Limits of plate determined by visual inspection

plate_left_edge  = 4; % mm
plate_right_edge = 596; % mm
ptcld_z = linspace(plate_left_edge,plate_right_edge,20);

% Create 20 sets of x-y-z points, varying the z location
ptcld_grousers = [];
vector_zPts = ones(size(trshoe_stl_pts_unique_yz(:,1)));
for i = 1:length(ptcld_z)
    ptcld_grousers = [...
        ptcld_grousers;
        trshoe_stl_pts_unique_yz(:,1:2) vector_zPts*ptcld_z(i)];
end
ptcld_grousers = ptcld_grousers/1000; % mm to m

%numPtsPtcld = size(ptcld_grousers,1);

% Get Points for Plate
ind_xy_lim = intersect(intersect(...)
    find(trshoe_stl_pts_unique(:,1) >= 25),...
    find(trshoe_stl_pts_unique(:,1) <= 55)),...
    find(trshoe_stl_pts_unique(:,2) >= 5));

trshoeplate_stl_pts_xy = trshoe_stl_pts_unique(ind_xy_lim,:);
plate_height = mean(trshoeplate_stl_pts_xy(:,2));

% The width of the plate is 0.6m, which can be obtained from the figure.  The
% point cloud needs to cover the shoe plate evenly and should not overlap
% with the next shoe.  We need to have evenly spaced gaps between the lines
% of the point cloud including a gap between two shoes.  To set the length
% of the point cloud patch, we need to know the length of the plate and the
% number of rows of points we plan to place.  That way, we can leave half a
% gap at either end to keep the density of points even across the entire
% track.

num_rows     = 3;
plate_width    = 596-4; % Visual inspection CAD geometry
plate_length   = 200;   % Distance between pin centers
cloud_len    = plate_length*num_rows/(num_rows +1);
grid_spacing = cloud_len/2;
num_cols     = round(plate_width/grid_spacing)+1;

temp_plate_pts = Point_Cloud_Data_Square(cloud_len,plate_width,[num_rows num_cols]);

%%
ptcld_plate  = [temp_plate_pts(:,1) temp_plate_pts(:,1)*0+plate_height temp_plate_pts(:,2)+(plate_width+8)/2];

ptcld_plate = ptcld_plate/1000; % mm to m

%% Method to get points for entire upper profile

inds_UP   = find(trshoe_stl_pts_unique_z(:,2)>1.5);
inds_excl = intersect(find(trshoe_stl_pts_unique_z(:,1)>80),find(trshoe_stl_pts_unique_z(:,2)<15));
inds_use = setdiff(inds_UP,inds_excl);
pts_UP  = trshoe_stl_pts_unique_z(inds_use,:);

[~,sortInd] = sort(pts_UP(:,1));
pts_UP_sort = pts_UP(sortInd,:);

x = pts_UP_sort(:,1); y = pts_UP_sort(:,2);

% Close the contour, temporarily
xc = [x(:); x(end); x(1)];
yc = [y(:); y(1);   y(1)];

% Current spacing may not be equally spaced
dx = diff(xc);
dy = diff(yc);

% Distances between consecutive coordinates
dS = sqrt(dx.^2+dy.^2);
dS = [0; dS];     % including start point

% Arc length, going along (around) snake
d = cumsum(dS);  % here is your independent variable
perim = d(end);

% Number of points per profile
N = 100;  % Includes "close" portion of profile
ds = perim / N;
dSi = ds*(0:N).'; %' your NEW independent variable, equally spaced

dSi(end) = dSi(end)-.005; % appease interp1

xi = interp1(d,xc,dSi);
yi = interp1(d,yc,dSi);

xi(end)=[]; yi(end)=[];

% Create profile
finalIndex = find(xi==max(xi),1); % Eliminate lower half
pt_profile = [xi(1:finalIndex) yi(1:finalIndex)];
ptcld_z = linspace(4,plate_width,20);

% Create 20 sets of x-y-z points, varying the z location
ptcld_profile = [];
vector_zPts = ones(size(pt_profile(:,1)));
for i = 1:length(ptcld_z)
    ptcld_profile = [...
        ptcld_profile;
        pt_profile(:,1:2) vector_zPts*ptcld_z(i)];
end

numPtsPtcld = size(ptcld_profile,1);

ptcld_profile = ptcld_profile/1000;


