function Excv = sm_excv_track_param_machine_2Idler4Roller
% Defines parameters structure for excavator model

% Copyright 2022-2025 The MathWorks, Inc

% Call internal functions to assemble structure
Excv.Contact  = Contact_Force_Parameters;
Excv.Chain    = Excv_Chain_Param;
Excv.Chassis  = Excv_Chassis_Param;
Excv.Shoe     = Excv_Shoe_Param;
Excv.Frame    = Excv_Frame_Param;
Excv.Drive    = Excv_Drive_Param;

% The following functions require parameters from other pieces
Excv.Roller   = Excv_Roller_Param(Excv.Chain.plate_h, Excv.Shoe.pad_h, Excv.Shoe.w);

Excv.Sprocket = Excv_Sprocket_Param(...
    Excv.Chain.chain_wid, Excv.Chain.plate_h, Excv.Shoe.pad_h,...
    Excv.Chain.pin_sep, Excv.Chain.pin_rad,...
    Excv.Shoe.w,...
    Excv.Roller.Lower.ground_contact.ptcld.npts,...
    Excv.Roller.Lower.ground_contact.rolling_radius);

[Excv.IdlerF Excv.IdlerR]    = Excv_Idler_Param(Excv.Sprocket.sprocket_rPitch,...
    Excv.Chain.plate_h,Excv.Chain.chain_wid, ...
    Excv.Shoe.pad_h, Excv.Shoe.w,...
    Excv.Roller.Lower.ground_contact.ptcld.npts,...
    Excv.Roller.Lower.ground_contact.rolling_radius);

%Excv.Vis.Track = Excv_TrackVis_Param(Excv.Frame.IdlerAssyX,...
%            Excv.Frame.Sprk2UpperX, ...
%            Excv.Roller.Upper.rad, Excv.Frame.Sprk2UpperY,...
%            Excv.Sprocket.sprocket_rPitch, Excv.Chain.plate_h, Excv.Shoe.pad_h);

%% Contact parameters
    function CFP = Contact_Force_Parameters
        CFP.IdlerF.K  = 1e7;
        CFP.IdlerF.B  = 1e5;
        CFP.IdlerF.TW = 1e-3;

        CFP.IdlerR.K  = 1e7;
        CFP.IdlerR.B  = 1e5;
        CFP.IdlerR.TW = 1e-3;

        CFP.Sprocket.K = 1e7;
        CFP.Sprocket.B = 1e5;
        CFP.Sprocket.TW = 1e-3;

        CFP.Roller.K = 1e7;
        CFP.Roller.B = 1e5;
        CFP.Roller.TW = 1e-3;

    end

%% Chain Link
    function Chain = Excv_Chain_Param
        
        Chain.plate_thk  = 0.013/2;  % Plate thickness
        Chain.plate_h    = 0.11/2;   % Chain plate height

        % Offset between plates from one link to the next
        % Assumes half link chain
        Chain.plate_off  = Chain.plate_thk+0.002/2;   

        % Separation of pins along direction of the chain
        Chain.pin_sep    = 0.2/3;

        % Calcluate hole separation along length of plate        
        Chain.hole_sep   = sqrt(Chain.plate_off^2 + Chain.pin_sep^2);

        % Calcluate hole separation along length of plate        
        % Assumes half link chain
        Chain.plate_ang  = atan2d(Chain.plate_off,  Chain.pin_sep);

        % Radius of hole in plate
        Chain.hole_rad   = 0.02/2;

        % Determine extrusion data for chain plate
        Chain.plate_xc   = Extr_Data_LinkHoles(Chain.hole_sep,Chain.plate_h,Chain.hole_rad,2);

        % Separation of plates, measured at plate center
        Chain.chain_wid = 0.1530/2;

        % Determine extrusion data for chain plate
        Chain.plate_clr  = [0.5 0.5 0.5];
        Chain.plate_opc  = 1;

        % Pin parameters
        Chain.pin_len   = 0.2/2;
        Chain.pin_rad   = 0.03/2;
        Chain.pin_clr   = [0.8 0.8 0.8];
        Chain.pin_opc   = 1;

        % Mass parameters for entire link (two plates + 1 pin)
        Chain.link_m    = 21.6;
        Chain.link_cg   = [0.03 -0.02 0.0]/2;
        Chain.link_moi  = [0.37 0.43 0.12]/8;
        Chain.link_poi  = [0 0 0];

        % Friction between chain links
        Chain.damping   = 1;

        % Contact geometry
        Chain.roller_contact.clr = [1.0 0.0 0.2];
        Chain.roller_contact.opc = 0;
        Chain.teeth_contact.clr  = [1.0 0.0 0.0];
        Chain.teeth_contact.opc  = 0.5;

    end

%% Sprocket
    function Sprocket = Excv_Sprocket_Param(chain_wid, chain_plate_h, shoe_pad_h,...
            pin_sep, pin_rad, shoe_w, roller_ptcld_npts, roller_rad)

        % Contact geometry
        % Sprocket width (must be narrower than chain)
        Sprocket.sprk_width = chain_wid*0.7;
        Sprocket.density    = 6000; % kg/m^3
        Sprocket.nTeeth     = 17;%22;   % Number of teeth

        % Number of gaps a chain link will skip
        % skipTeeth = 1 means chain meshes every other sprocket gap
        Sprocket.skipTeeth  = 0;

        % Calculate sprocket profile and pitch radius
        [temp_spr_pts, temp_rPitch] = Extr_Data_Sprocket(...
            Sprocket.nTeeth,Sprocket.skipTeeth,pin_sep,pin_rad);

        % Position gap on sprocket towards the chassis (up).
        Rmat = [cosd(-90) sind(-90);
               -sind(-90) cosd(-90)];
        temp_spr_pts = (Rmat*temp_spr_pts')';

        Sprocket.sprocket_xc     = temp_spr_pts;
        Sprocket.sprocket_rPitch = temp_rPitch;

        % Use extrusion data to assemble point cloud for teeth contact
        Sprocket.teeth_contact.ptcld.pts = [temp_spr_pts  zeros(size(temp_spr_pts,1),1)];

        % Color, opacity
        Sprocket.clr        = [0.5764706 0.61960787 0.6784314];
        Sprocket.opc        = 1;

        % Contact geometry for Teeth
        Sprocket.teeth_contact.ptcld.rad = 2e-3/2;
        Sprocket.teeth_contact.ptcld.clr = [1 0 0];
        Sprocket.teeth_contact.ptcld.opc = 1;

        % Ground geometry for rolling contact
        Sprocket.ground_contact.rolling_radius = Sprocket.sprocket_rPitch+chain_plate_h/2+shoe_pad_h;
        sprk_cloud_rad = Sprocket.ground_contact.rolling_radius;

        % Ensure point cloud on sprocket has similar density (points per area)
        % to point cloud on roller
        npts_sprk         = ceil(roller_ptcld_npts*sprk_cloud_rad/roller_rad);

        % Generate point cloud
        Sprocket.ground_contact.ptcld.pts = Point_Cloud_Data_Cylinder(sprk_cloud_rad,shoe_w,npts_sprk,0);

        % Contact geometry visual settings for point cloud ground contact
        Sprocket.ground_contact.ptcld.rad = 1e-2;
        Sprocket.ground_contact.ptcld.clr = [1 0 0];
        Sprocket.ground_contact.ptcld.opc = 1;

        % Contact geometry visual settings for sphere ground contact
        Sprocket.ground_contact.sphere.clr = [0.78 0.3 0.3];
        Sprocket.ground_contact.sphere.opc = 0.2;
    end

%% Shoe with Grouser
    function Shoe = Excv_Shoe_Param

        % Shoe width (side-to-side) and length (fore-aft)
        Shoe.w          = 0.6/2;  % m
        Shoe.l          = 0.2/3;  % m

        %{
        % Parameterized with symmetrical grouser
        Shoe.h          = 0.03;
        Shoe.pad_h      = 0.005;
        Shoe.grouser_wo = 0.019;
        Shoe.grouser_wi = 0.013;
        Shoe.xc         = Extr_Data_ExcvShoe(...
            Shoe.l, Shoe.h,Shoe.pad_h,...
            Shoe.grouser_wo, Shoe.grouser_wi,3);
        %}

        % Load custom shoe profile
        %xc = load('track_shoe_profile_0p2m.mat');
        %Shoe.xc = xc.track_shoe_profile_0p2m;

        % Depth of shoe plate
        Shoe.pad_h      = 0.02;

        xc = Extr_Data_LinkHoles(Shoe.l, Shoe.pad_h, 0, 0);
        Shoe.xc = xc + [0 Shoe.pad_h/2];
        % Height of grouser tips
        Shoe.h          = 0.0375;

        % Geometry settings
        Shoe.clr        = [0.37254903 0.3254902 0.2];
        Shoe.opc        = 1;

        % Generate point cloud for plate contact
        temp_shoe_pts          = Point_Cloud_Data_Square(Shoe.l,Shoe.w,[3 8]);
        Shoe.ptcld_sets.plate  = [temp_shoe_pts(:,1) temp_shoe_pts(:,1)*0-Shoe.pad_h temp_shoe_pts(:,2)];

        % Generate point cloud for grouser contact
        temp_grouserPtsInd     = find(Shoe.xc(:,2)>Shoe.h*0.999);
        temp_grouserPts_w      = linspace(0,Shoe.w,20)-Shoe.w/2;

        temp_shoe_ptcld_grousers = [];
        for temp_i = 1:length(temp_grouserPts_w)
            temp_shoe_ptcld_grousers = [
                temp_shoe_ptcld_grousers;
                Shoe.xc(temp_grouserPtsInd,:).*[1 -1] ones(length(temp_grouserPtsInd),1)*temp_grouserPts_w(temp_i)];
        end
        Shoe.ptcld_sets.grousers = temp_shoe_ptcld_grousers;

        % By default, only use point cloud on shoe plate
        Shoe.ground_contact.ptcld.pts     = Shoe.ptcld_sets.plate;

        % Contact geometry visual settings for point cloud contact
        Shoe.ground_contact.ptcld.rad = 2e-3;
        Shoe.ground_contact.ptcld.clr = [1 1 0.06667];
        Shoe.ground_contact.ptcld.opc = 1;

        % Custom mass settings for plate
        Shoe.mass = 5.85;
        Shoe.cg   = [-0.001450 -0.0175 0];    % CG Location
        Shoe.moi  = [0.17759519 0.19840052 0.02499571]; % Moments of inertia
        Shoe.poi  = [0 0 0];                            % Products of inertia

        % Contact geometry visual settings for brick solid contact
        Shoe.ground_contact.plate_solid.clr = [1 0 0];
        Shoe.ground_contact.plate_solid.opc = 0;

    end

%% Rollers
    function Roller = Excv_Roller_Param(chain_plate_h, shoe_pad_h, shoe_w)
        Roller.Upper.rad = 0.07; % m
        Roller.Upper.len = 0.24; % m
        Roller.Upper.rho = 7800; % kg/m^3
        Roller.Upper.clr = [0.3 0.3 0.3];
        Roller.Upper.opc = 1;

        Roller.Lower.rad = 0.065; % m
        Roller.Lower.len = 0.24; % m
        Roller.Lower.rho = 7800; % kg/m^3
        Roller.Lower.clr = [0.3 0.3 0.3];
        Roller.Lower.opc = 1;
        
        % Rolling radius = roller radius + chain plate height + shoe pad height
        Roller.Lower.ground_contact.rolling_radius = ...
            Roller.Lower.rad+chain_plate_h+shoe_pad_h;
        lrrad = Roller.Lower.ground_contact.rolling_radius;

        % Number of points on roller - will be adjusted to be even
        Roller.Lower.ground_contact.ptcld.npts = 30;
        npts = Roller.Lower.ground_contact.ptcld.npts;

        % Obtain point cloud
        Roller.Lower.ground_contact.ptcld.pts = Point_Cloud_Data_Cylinder(lrrad,shoe_w,npts,0);

        % Contact geometry visual settings for point cloud contact        
        Roller.Lower.ground_contact.ptcld.clr = [1.0 0.0 0.0];
        Roller.Lower.ground_contact.ptcld.opc = 1;
        Roller.Lower.ground_contact.ptcld.rad = 1e-2;
        
        % Contact geometry visual settings for sphere contact        
        Roller.Lower.ground_contact.sphere.clr = [0.78 0.3 0.3];
        Roller.Lower.ground_contact.sphere.opc = 0.2;

        % Contact geometry visual settings for cylinder visualization
        Roller.Lower.ground_contact.cyl_vis.clr = [0.3 0.3 0.3];
        Roller.Lower.ground_contact.cyl_vis.opc = 1;

    end
% Roller Locations

    function Frame = Excv_Frame_Param

        % Longitudinal distances from sprocket center to roller centers
        Frame.Sprk2LowerX = [0.10 0.30 0.50 0.675]-0.05;
        %Frame.Sprk2UpperX = [1.160 2.220];

        % Vertical distance from sprocket center to upper roller center
        %Frame.Sprk2UpperY = 0.34;

        Frame.Sprk2LowerY  = -0.30;
        Frame.Sprk2IdlerFY = -0.25;
        Frame.Sprk2IdlerRY = -0.25;

        % Note - lower roller height is calculated based on 
        %        sprocket dimensions to keep chain flat

        % Vertical distance from sprocket center to idler center 
        % (design position - tensioner contracts for assembly, extends when in use)
        Frame.IdlerAssyX      =  3.3750-2.5;
        Frame.Sprk2IdlerRX    = -0.15; 

        % Distance between bottom of lower roller, bottom of idler
        %Frame.IdlerRollerVoffset = 0.01; 

        % Distance from sprocket center to axle center
        % NOTE: x is longitudinal, y is vertical
        Frame.AxleX = 0;
        Frame.AxleY = 0;

        % Distance from sprocket center to frame CG
        % NOTE: x is longitudinal, y is vertical, z is lateral
        Frame.CGOffset  = [0.2 -0.5 0];

        % Mass parameters
        Frame.Mass = 500;
        % NOTE: x is longitudinal, y is vertical, z is lateral
        Frame.MOI  = [1 10 10];
        Frame.POI  = [0 0 0];

        % Distance from sprocket center to suspension attachment
        % Define as all positive values, mirroring for left/right happens in model
        % NOTE: x is longitudinal, y is vertical, z is lateral
        Frame.SuspOffset  = [1 -0.5 0.1];
    end

    function Chassis = Excv_Chassis_Param
        Chassis.Mass        = 7000/2;       % kg
        Chassis.MOI         = [53 53 53]; % kg*m^2
        Chassis.POI         = [0 0 0];    % kg*m^2

        Chassis.CGOffset         = [-0.08   0.5 0]/2;  % m
        Chassis.AxleOffset       = [-0.5    0.395 0]/2;  % m
        Chassis.SuspOffset       = [ 1     -0.1   0.65];     % m

        Chassis.TrackSepCtr      = 2.2;   % m
        Chassis.AxleRad          = 0.15;   % m
        Chassis.Camera.SprocketTrackCtr = 0.3; % m (for camera)
        Chassis.Camera.Sprocket2CtrRear = [0 0 0]; % m (for camera)
        Chassis.Camera.ToFront          = 0.3*2; % m (for camera)
        Chassis.Camera.ToFrontAimLR     = 180-15; % m (for camera)
        Chassis.Camera.ToLeftAimRight   = 4;
        Chassis.Camera.ToRightAimLeftTR = [0 -4 0];
        Chassis.Camera.ToIsoFR_xyz      = [4 -4 3];
        Chassis.Camera.ToIsoFR_rpy      = [135 20 0];
        Chassis.Camera.ToRightAimLeftTL = [0 -1 0];
        Chassis.Camera.LeftRearAimLF    = 2.2;
        Chassis.Camera.LeftRearAimLFAng = -15;
        Chassis.Camera.CtrRearAimLFAng  =  15;

        Chassis.Camera.FRAimFront_rpy   = [140     20 0];
        Chassis.Camera.FRAimFront_xyz   = [0.3*2+1.3 -0.35 0.5];

        Chassis.Camera.ToIsoFRBig_xyz      = [8 -2.5 2.5];
        Chassis.Camera.ToIsoFRBig_rpy      = [155 20 0];

        Chassis.Camera.ToIsoFRBigFront_xyz      = [4 -2.5-2.2 2.5];
        Chassis.Camera.ToIsoFRBigFront_rpy      = [155-20 17 0];

        Chassis.Camera.Sprocket2Top_xyz   = [4 0 8];
        Chassis.Camera.Sprocket2Top_rpy   = [0 0 0];

        Chassis.Susp.Cylinder.Piston.Len    = 0.30;
        Chassis.Susp.Cylinder.Piston.Rad    = 0.05;
        Chassis.Susp.Cylinder.Piston.Mass   = 2.35;
        %Chassis.Susp.Cylinder.Piston.MOI    = [0.019 0.019 0.002];
        %Chassis.Susp.Cylinder.Piston.POI    = [0     0     0];

        Chassis.Susp.Cylinder.Cylinder.Len  = 0.20;
        Chassis.Susp.Cylinder.Cylinder.Rad  = 0.07;
        Chassis.Susp.Cylinder.Cylinder.Mass = 3.07;
        % Chassis.Susp.Cylinder.Cylinder.MOI  = 0.07;
        % Chassis.Susp.Cylinder.Cylinder.POI  = 0.07;
        Chassis.Susp.Cylinder.xeq = 0.13;
        Chassis.Susp.Cylinder.k = 5e5;
        Chassis.Susp.Cylinder.b = 5e4;
    end

%% Idler
    function [IdlerF IdlerR] = Excv_Idler_Param(sprk_pitch_rad, chain_plate_h, ...
            chain_wid, shoe_pad_h, shoe_w, roller_ptcld_npts, roller_rad)

        % Idler radius - calculated here, could be set to a parameter
        IdlerF.rad    = 0.1086;%sprk_pitch_rad-chain_plate_h/2;
        IdlerR.rad    = 0.1086;%sprk_pitch_rad-chain_plate_h/2;

        % Idler length - must fit within chain
        IdlerF.len    = chain_wid+0.02;
        IdlerF.rho    = 3000; % kg/^3
        IdlerR.len    = chain_wid+0.02;
        IdlerR.rho    = 3000; % kg/^3

        % Color opacity
        IdlerF.clr    = [0.5764706 0.61960787 0.6784314];
        IdlerF.opc    = 1;
        IdlerR.clr    = [0.5764706 0.61960787 0.6784314];
        IdlerR.opc    = 1;

        % Contact geometry visual settings
        IdlerF.chain_contact.clr = [1 0 0];
        IdlerF.chain_contact.opc = 0;
        IdlerR.chain_contact.clr = [1 0 0];
        IdlerR.chain_contact.opc = 0;

        % Tensioner spring parameters
        IdlerF.Tensioner.xeq =  0.5/2;  % Preload distance for spring
        IdlerF.Tensioner.K   =  3e5;
        IdlerF.Tensioner.B   =  1e4;
        IdlerF.Tensioner.x0  = -0.06; % Compression at assembly

        % Tensioner Cylinder
        IdlerF.Tensioner.cyl.rad = 0.076/2;
        IdlerF.Tensioner.cyl.len = 0.48/2;
        IdlerF.Tensioner.cyl.rho = 2700;
        IdlerF.Tensioner.cyl.clr = [0.4 0.4 0.4];
        IdlerF.Tensioner.cyl.opc = 1;

        % For abstract model - assumes tensioner locked at max extension
        IdlerF.Tensioner.cyl.max_ext = 0.1/2; % m

        % Tensioner Piston
        IdlerF.Tensioner.piston.rad = 0.05/2;
        IdlerF.Tensioner.piston.len = 0.25/2;
        IdlerF.Tensioner.piston.rho = 1000;
        IdlerF.Tensioner.piston.clr = [0.8 0.8 0.8];
        IdlerF.Tensioner.piston.opc = 1;

        % Tensioner Bracket
        IdlerF.Tensioner.bracket.len    = 0.4/3;
        IdlerF.Tensioner.bracket.wid    = 0.25/2;
        IdlerF.Tensioner.bracket.height = 0.1/2;
        IdlerF.Tensioner.bracket.thk    = 0.02;
        IdlerF.Tensioner.bracket.rho    = 2700;
        IdlerF.Tensioner.bracket.clr    = [0.8 0.8 0.8];
        IdlerF.Tensioner.bracket.opc    = 1;

        % Idler rolling radius for ground contact
        % Idler radius + chain plate height + shoe pad height
        IdlerF.ground_contact.rolling_radius   = IdlerF.rad+chain_plate_h+shoe_pad_h;
        idlerF_cloud_rad = IdlerF.ground_contact.rolling_radius;
        IdlerR.ground_contact.rolling_radius   = IdlerR.rad+chain_plate_h+shoe_pad_h;
        idlerR_cloud_rad = IdlerR.ground_contact.rolling_radius;

        % Scale number of points on idler to have same density (points/area)
        % as on lower roller
        npts_idlerF         = ceil(roller_ptcld_npts*idlerF_cloud_rad/roller_rad);
        IdlerF.ground_contact.ptcld.pts = Point_Cloud_Data_Cylinder(idlerF_cloud_rad,shoe_w,npts_idlerF,0);
        npts_idlerR         = ceil(roller_ptcld_npts*idlerR_cloud_rad/roller_rad);
        IdlerR.ground_contact.ptcld.pts = Point_Cloud_Data_Cylinder(idlerR_cloud_rad,shoe_w,npts_idlerR,0);

        % Contact geometry visual settings for point cloud
        IdlerF.ground_contact.ptcld.rad = 1e-2;
        IdlerF.ground_contact.ptcld.clr = [1 0 0];
        IdlerF.ground_contact.ptcld.opc = 1;
        IdlerR.ground_contact.ptcld.rad = 1e-2;
        IdlerR.ground_contact.ptcld.clr = [1 0 0];
        IdlerR.ground_contact.ptcld.opc = 1;

        % Contact geometry visual settings for sphere
        IdlerF.ground_contact.sphere.clr = [0.78 0.3 0.3];
        IdlerF.ground_contact.sphere.opc = 0.2;
        IdlerR.ground_contact.sphere.clr = [0.78 0.3 0.3];
        IdlerR.ground_contact.sphere.opc = 0.2;

    end

    function Drive = Excv_Drive_Param
        % Stiffness and damping for drive shaft
        Drive.Shaft.k    = 1e5;
        Drive.Shaft.b    = 1e4;
    end

    function TrackVis = Excv_TrackVis_Param(idler_x, upper_roller_x, ...
            upper_roller_rad, upper_roller_y, sprk_rpitch, chain_plate_h, shoe_pad_h)
        % Parameters for track visualization extrusion
        % Note that the extrusion uses the same radius for the front and
        % rear end, so if the sprocket and idler have different rolling radii, 
        % the extrusion will not line up perfectly with the contact geometry

        % Upper and lower length
        lenL = idler_x+0.1; % Idler Extended
        lenU = upper_roller_x(2)-upper_roller_x(1);

        % Upper and lower radii
        rL   = sprk_rpitch+chain_plate_h/2+shoe_pad_h;
        rU   = upper_roller_rad+chain_plate_h+shoe_pad_h;

        % Radius for holes
        riU  = 0.01;
        riL  = 0.01;

        % Offset lower and upper lines
        xU   = (upper_roller_x(2)+upper_roller_x(1))/2-lenL/2;
        H    = upper_roller_y;

        % Obtain extrusion data
        track_xc = Extr_Data_TrapezoidRounded(lenL, lenU, rL, rU, riL, riU, xU, H);

        % Center extrusion data
        TrackVis.track_xc = track_xc+[lenL/2 0];

        % Inertial properties of stretched, unmoving track
        TrackVis.m   = 1263;
        TrackVis.cg  = [1.749 0 0];
        TrackVis.moi = [221 6068 6242];
        TrackVis.poi = [0 0 71];

        % Visual properties
        TrackVis.clr = [0.5 0.5 0.5];
        TrackVis.opc = 0.5;
    end

end