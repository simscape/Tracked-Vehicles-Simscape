function Excv = sm_excv_track_param_machine
% Defines parameters structure for excavator model

% Copyright 2022-2023 The MathWorks, Inc

% Call internal functions to assemble structure
Excv.Contact  = Contact_Force_Parameters;
Excv.Chain    = Excv_Chain_Param;
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

Excv.Idler    = Excv_Idler_Param(Excv.Sprocket.sprocket_rPitch,...
    Excv.Chain.plate_h,Excv.Chain.chain_wid, ...
    Excv.Shoe.pad_h, Excv.Shoe.w,...
    Excv.Roller.Lower.ground_contact.ptcld.npts,...
    Excv.Roller.Lower.ground_contact.rolling_radius);

Excv.Vis.Track = Excv_TrackVis_Param(Excv.Frame.IdlerAssyX,...
            Excv.Frame.Sprk2UpperX, ...
            Excv.Roller.Upper.rad, Excv.Frame.Sprk2UpperY,...
            Excv.Sprocket.sprocket_rPitch, Excv.Chain.plate_h, Excv.Shoe.pad_h);

%% Contact parameters
    function CFP = Contact_Force_Parameters
        CFP.Idler.K  = 1e7;
        CFP.Idler.B  = 1e5;
        CFP.Idler.TW = 1e-3;

        CFP.Sprocket.K = 1e7;
        CFP.Sprocket.B = 1e5;
        CFP.Sprocket.TW = 1e-3;

        CFP.Roller.K = 1e7;
        CFP.Roller.B = 1e5;
        CFP.Roller.TW = 1e-3;

    end

%% Chain Link
    function Chain = Excv_Chain_Param
        
        Chain.plate_thk  = 0.013;  % Plate thickness
        Chain.plate_h    = 0.11;   % Chain plate height

        % Offset between plates from one link to the next
        % Assumes half link chain
        Chain.plate_off  = Chain.plate_thk+0.002;   

        % Separation of pins along direction of the chain
        Chain.pin_sep    = 0.2;

        % Calcluate hole separation along length of plate        
        Chain.hole_sep   = sqrt(Chain.plate_off^2 + Chain.pin_sep^2);

        % Calcluate hole separation along length of plate        
        % Assumes half link chain
        Chain.plate_ang  = atan2d(Chain.plate_off,  Chain.pin_sep);

        % Radius of hole in plate
        Chain.hole_rad   = 0.02;

        % Determine extrusion data for chain plate
        Chain.plate_xc   = Extr_Data_LinkHoles(Chain.hole_sep,Chain.plate_h,Chain.hole_rad,2);

        % Separation of plates, measured at plate center
        Chain.chain_wid = 0.1530;

        % Determine extrusion data for chain plate
        Chain.plate_clr  = [0.5 0.5 0.5];
        Chain.plate_opc  = 1;

        % Pin parameters
        Chain.pin_len   = 0.2;
        Chain.pin_rad   = 0.03;
        Chain.pin_clr   = [0.8 0.8 0.8];
        Chain.pin_opc   = 1;

        % Mass parameters for entire link (two plates + 1 pin)
        Chain.link_m    = 21.6;
        Chain.link_cg   = [0.03 -0.02 0.0];
        Chain.link_moi  = [0.37 0.43 0.12];
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
        Sprocket.nTeeth     = 22;   % Number of teeth

        % Number of gaps a chain link will skip
        % skipTeeth = 1 means chain meshes every other sprocket gap
        Sprocket.skipTeeth  = 1;

        % Calculate sprocket profile and pitch radius
        [temp_spr_pts, temp_rPitch] = Extr_Data_Sprocket(...
            Sprocket.nTeeth,Sprocket.skipTeeth,pin_sep,pin_rad);
        Sprocket.sprocket_xc    = temp_spr_pts;
        Sprocket.sprocket_rPitch = temp_rPitch;

        % Use extrusion data to assemble point cloud for teeth contact
        Sprocket.teeth_contact.ptcld.pts = [temp_spr_pts  zeros(size(temp_spr_pts,1),1)];

        % Color, opacity
        Sprocket.clr        = [0.5764706 0.61960787 0.6784314];
        Sprocket.opc        = 1;

        % Contact geometry for Teeth
        Sprocket.teeth_contact.ptcld.rad = 2e-3;
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
        Shoe.w          = 0.6;  % m
        Shoe.l          = 0.2;  % m

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
        xc = load('track_shoe_profile_0p2m.mat');
        Shoe.xc = xc.track_shoe_profile_0p2m;

        % Depth of shoe plate
        Shoe.pad_h      = 0.01;

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
        Frame.Sprk2LowerX = [0.520 0.810 1.220 1.685 2.170 2.580 2.870];
        Frame.Sprk2UpperX = [1.160 2.220];

        % Vertical distance from sprocket center to upper roller center
        Frame.Sprk2UpperY = 0.34;

        % Note - lower roller height is calculated based on 
        %        sprocket dimensions to keep chain flat

        % Vertical distance from sprocket center to idler center 
        % (design position - tensioner contracts for assembly, extends when in use)
        Frame.IdlerAssyX = 3.3750;

        % Distance between bottom of lower roller, bottom of idler
        Frame.IdlerRollerVoffset = 0.01; 

    end

%% Idler
    function Idler = Excv_Idler_Param(sprk_pitch_rad, chain_plate_h, ...
            chain_wid, shoe_pad_h, shoe_w, roller_ptcld_npts, roller_rad)

        % Idler radius - calculated here, could be set to a parameter
        Idler.rad    = sprk_pitch_rad-chain_plate_h/2;

        % Idler length - must fit within chain
        Idler.len    = chain_wid+0.02;
        Idler.rho    = 3000; % kg/^3

        % Color opacity
        Idler.clr    = [0.5764706 0.61960787 0.6784314];
        Idler.opc    = 1;

        % Contact geometry visual settings
        Idler.chain_contact.clr = [1 0 0];
        Idler.chain_contact.opc = 0;

        % Tensioner spring parameters
        Idler.Tensioner.xeq =  0.5;  % Preload distance for spring
        Idler.Tensioner.K   =  3e5;
        Idler.Tensioner.B   =  1e4;
        Idler.Tensioner.x0  = -0.06; % Compression at assembly

        % Tensioner Cylinder
        Idler.Tensioner.cyl.rad = 0.076;
        Idler.Tensioner.cyl.len = 0.48;
        Idler.Tensioner.cyl.rho = 2700;
        Idler.Tensioner.cyl.clr = [0.4 0.4 0.4];
        Idler.Tensioner.cyl.opc = 1;

        % For abstract model - assumes tensioner locked at max extension
        Idler.Tensioner.cyl.max_ext = 0.1; % m

        % Tensioner Piston
        Idler.Tensioner.piston.rad = 0.05;
        Idler.Tensioner.piston.len = 0.25;
        Idler.Tensioner.piston.rho = 1000;
        Idler.Tensioner.piston.clr = [0.8 0.8 0.8];
        Idler.Tensioner.piston.opc = 1;

        % Tensioner Bracket
        Idler.Tensioner.bracket.len    = 0.4;
        Idler.Tensioner.bracket.wid    = 0.25;
        Idler.Tensioner.bracket.height = 0.1;
        Idler.Tensioner.bracket.thk    = 0.02;
        Idler.Tensioner.bracket.rho    = 2700;
        Idler.Tensioner.bracket.clr    = [0.8 0.8 0.8];
        Idler.Tensioner.bracket.opc    = 1;

        % Idler rolling radius for ground contact
        % Idler radius + chain plate height + shoe pad height
        Idler.ground_contact.rolling_radius   = Idler.rad+chain_plate_h+shoe_pad_h;
        idler_cloud_rad = Idler.ground_contact.rolling_radius;

        % Scale number of points on idler to have same density (points/area)
        % as on lower roller
        npts_idler         = ceil(roller_ptcld_npts*idler_cloud_rad/roller_rad);
        Idler.ground_contact.ptcld.pts = Point_Cloud_Data_Cylinder(idler_cloud_rad,shoe_w,npts_idler,0);

        % Contact geometry visual settings for point cloud
        Idler.ground_contact.ptcld.rad = 1e-2;
        Idler.ground_contact.ptcld.clr = [1 0 0];
        Idler.ground_contact.ptcld.opc = 1;

        % Contact geometry visual settings for sphere
        Idler.ground_contact.sphere.clr = [0.78 0.3 0.3];
        Idler.ground_contact.sphere.opc = 0.2;

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