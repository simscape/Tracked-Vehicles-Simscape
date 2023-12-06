function [ptcld_grousers, ptcld_plate] = track_shoe_ptcloud_createFromSTEP(stlfilename,varargin)
%track_shoe_ptcloud_createFromSTEP Produce point cloud data from track shoe STEP file.
%   [ptcld_grousers, ptcld_plate] = track_shoe_ptcloud_createFromSTEP(stlfilename,<point_option>)  
%   This function returns x-y-z data extracted from STEP geometry.
%
%  [ptcld_grousers, ptcld_plate] = track_shoe_ptcloud_createFromSTEP('CAD_Track_Shoe.STEP');

% Read in STEP file
model = createpde(1);
trshoe_geoObj = importGeometry(model,stlfilename);
%numPtsAll = size(trshoe_geoObj.Vertices,1);

% Extract all points within the plane z=4
ind_z_lim = intersect(...
    find(trshoe_geoObj.Vertices(:,3) >= 3.95/1000),...
    find(trshoe_geoObj.Vertices(:,3) <= 4.05/1000));
trshoe_stp_pts_z  = trshoe_geoObj.Vertices(ind_z_lim,:);
%numPtsUZ = length(trshoe_stp_pts_z);

% Extract points above height 37.455 mm
ind_y_lim = trshoe_stp_pts_z(:,2) >= 37.455/1000;
trshoe_stp_pts_yz  = trshoe_stp_pts_z(ind_y_lim,:);
%numPtsUYZ = length(trshoe_stp_pts_yz);

% Create 20 locations for points along the width of the track shoe
ptcld_z = linspace(4,596,20)/1000;

% Create 20 sets of x-y-z points, varying the z location
ptcld_grousers = [];
vector_zPts = ones(size(trshoe_stp_pts_yz(:,1)));
for i = 1:length(ptcld_z)
    ptcld_grousers = [...
        ptcld_grousers;
        trshoe_stp_pts_yz(:,1:2) vector_zPts*ptcld_z(i)];
end

%numPtsPtcld = size(ptcld_grousers,1);

% Get Points for Plate
ind_xy_lim = intersect(intersect(...
    find(trshoe_geoObj.Vertices(:,1) >= 25/1000),...
    find(trshoe_geoObj.Vertices(:,1) <= 55/1000)),...
    find(trshoe_geoObj.Vertices(:,2) >= 5/1000));

trshoeplate_stp_pts_xy = trshoe_geoObj.Vertices(ind_xy_lim,:);
plate_height = mean(trshoeplate_stp_pts_xy(:,2));

% The width of the plate is 0.6m, which can be obtained from the figure.  The
% point cloud needs to cover the shoe plate evenly and should not overlap
% with the next shoe.  We need to have evenly spaced gaps between the lines
% of the point cloud including a gap between two shoes.  To set the length
% of the point cloud patch, we need to know the length of the plate and the
% number of rows of points we plan to place.  That way, we can leave half a
% gap at either end to keep the density of points even across the entire
% track.

num_rows     = 3;
plate_width  = 596-4; % Visual inspection CAD geometry
plate_length = 200;   % Distance between pin centers
cloud_len    = plate_length*num_rows/(num_rows +1);
grid_spacing = cloud_len/2;
num_cols     = round(plate_width/grid_spacing)+1;

temp_plate_pts = Point_Cloud_Data_Square(cloud_len,plate_width,[num_rows num_cols]);

%%
ptcld_plate  = [temp_plate_pts(:,1) temp_plate_pts(:,1)*0+plate_height temp_plate_pts(:,2)+600/2];

