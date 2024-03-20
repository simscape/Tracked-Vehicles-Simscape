function Excv = sm_trackV_belt_param_machine_seg45i2u0r3_IdlerArm
% Defines parameters structure for excavator model

% Copyright 2022-2024 The MathWorks, Inc

% Call internal functions to assemble structure
Excv.Belt     = Excv_Belt_Param;
Excv.Contact  = Contact_Force_Parameters;
Excv.Chassis  = Excv_Chassis_Param;
Excv.Frame    = Excv_Frame_Param;
Excv.Drive    = Excv_Drive_Param;
Excv.IdlerArm = Excv_IdlerArm_Param;

% The following functions require parameters from other pieces
Excv.Roller   = Excv_Roller_Param(Excv.Belt.Lug.w, Excv.Belt.pad_h,Excv.Belt.w);

Excv.Sprocket = Excv_Sprocket_Param(...
    Excv.Belt.w, Excv.Belt.pad_h,...
    Excv.Roller.Lower.ground_contact.ptcld.npts,...
    Excv.Roller.Lower.ground_contact.rolling_radius);

[Excv.IdlerF, Excv.IdlerR]    = Excv_Idler_Param(...
    Excv.Belt.Lug.w, Excv.Belt.pad_h,Excv.Belt.w,...
    Excv.Roller.Lower.ground_contact.ptcld.npts,...
    Excv.Roller.Lower.ground_contact.rolling_radius);

% Assemble frame locations for abstract tread visual
C(1,:)  = [0 0]; 
R(1)    = Excv.Sprocket.Roller.rad+Excv.Belt.pad_h;
C(2,:)  = [Excv.Frame.SprkOffLon.IdlerR Excv.Frame.SprkOffVer.IdlerR];
R(2)    = Excv.IdlerR.ground_contact.rolling_radius;
C(3,:)  = [Excv.Frame.SprkOffLon.IdlerF Excv.Frame.SprkOffVer.IdlerF];
R(3)    = Excv.IdlerR.ground_contact.rolling_radius;

rollerC = [Excv.Frame.SprkOffLon.Lower' ones(length(Excv.Frame.SprkOffLon.Lower),1)*Excv.Frame.SprkOffVer.Lower];
rollerR = ones(length(Excv.Frame.SprkOffLon.Lower),1)*Excv.Roller.Lower.ground_contact.rolling_radius;

C       =[C;rollerC];
R       =[R';rollerR];

Excv.Vis.Track = Excv_TrackVis_Param(C,R);


%% Contact parameters
    function CFP = Contact_Force_Parameters
        CFP.IdlerF.K  = 1e7;
        CFP.IdlerF.B  = 1e5;
        CFP.IdlerF.TW = 1e-3;

        CFP.IdlerR.K  = 1e7;
        CFP.IdlerR.B  = 1e5;
        CFP.IdlerR.TW = 1e-3;

        CFP.SprocketLug.K = 1e7;
        CFP.SprocketLug.B = 1e5;
        CFP.SprocketLug.TW = 1e-3;

        CFP.SprocketRoller.K = 1e7;
        CFP.SprocketRoller.B = 1e5;
        CFP.SprocketRoller.TW = 1e-3;


        CFP.Roller.K = 1e7;
        CFP.Roller.B = 1e5;
        CFP.Roller.TW = 1e-3;

    end

%% Sprocket
    function Sprocket = Excv_Sprocket_Param(belt_wid, belt_pad_h,...
            roller_ptcld_npts, roller_rad)

        % Contact geometry
        % Sprocket width (must be narrower than chain)
        sprk_wid       = belt_wid-0.01;
        Sprocket.Roller.rad = 0.504;
        Sprocket.Roller.wid = sprk_wid*0.3;

        Sprocket.Spoke.rad        = 0.017;
        Sprocket.Spoke.len        = sprk_wid*0.4;
        pin_roller_edge_offset    = 0.01;
        Sprocket.Spoke.pitch_rad  = Sprocket.Roller.rad-Sprocket.Spoke.rad-pin_roller_edge_offset;

        Sprocket.Roller.rad_i     = Sprocket.Spoke.pitch_rad-Sprocket.Spoke.rad; 
        Sprocket.nSpokes          = 21; % kg/m^3

        % Sprocket rim geometry - for visual only

        sproket_rim_ir      = Sprocket.Roller.rad*0.35;
        sproket_rim_hcr     = Sprocket.Roller.rad*0.75;
        sproket_rim_hr      = Sprocket.Roller.rad*0.075;
        Sprocket.Rim.spoke_xc      = Extr_Data_Sprocket_Spoke(...
            Sprocket.nSpokes, Sprocket.Roller.rad,...
            sproket_rim_ir, sproket_rim_hcr, sproket_rim_hr);
        Sprocket.Rim.thk     = 0.05;
        Sprocket.Rim.rad_inner      = sproket_rim_ir;

        % Position gap on sprocket towards the chassis (up).

        % Color, opacity
        Sprocket.Roller.clr     = [1 1 0];
        Sprocket.Roller.opc     = 1;
        Sprocket.Spoke.clr        = [1 1 0];
        Sprocket.Spoke.opc        = 1;

        % Contact geometry for Teeth
        Sprocket.spoke_contact.clr = [1 0 0];
        Sprocket.spoke_contact.opc = 0.5;
        Sprocket.roller_contact.clr = [1 0 0];
        Sprocket.roller_contact.opc = 0.5;

        % Ground geometry for rolling contact
        Sprocket.ground_contact.rolling_radius = Sprocket.Roller.rad+belt_pad_h;
        sprk_cloud_rad = Sprocket.ground_contact.rolling_radius;

        % Ensure point cloud on sprocket has similar density (points per area)
        % to point cloud on roller
        npts_sprk         = ceil(roller_ptcld_npts*sprk_cloud_rad/roller_rad);

        % Generate point cloud
        Sprocket.ground_contact.ptcld.pts = Point_Cloud_Data_Cylinder(sprk_cloud_rad,belt_wid,npts_sprk,0);

        % Contact geometry visual settings for point cloud ground contact
        Sprocket.ground_contact.ptcld.rad = 1e-2;
        Sprocket.ground_contact.ptcld.clr = [1 0 0];
        Sprocket.ground_contact.ptcld.opc = 1;

        % Contact geometry visual settings for sphere ground contact
        Sprocket.ground_contact.sphere.clr = [0.78 0.3 0.3];
        Sprocket.ground_contact.sphere.opc = 0.2;
    end

%% Belt with Grouser
    function Belt = Excv_Belt_Param

        % Belt width (side-to-side) and segment length (fore-aft)
        Belt.w          = 0.61;  % m
        Belt.l          = 0.15346;  % m

        %{
        % Parameterized with symmetrical grouser
        Belt.h          = 0.03;
        Belt.pad_h      = 0.005;
        Belt.grouser_wo = 0.019;
        Belt.grouser_wi = 0.013;
        Belt.xc         = Extr_Data_ExcvBelt(...
            Belt.l, Belt.h,Belt.pad_h,...
            Belt.grouser_wo, Belt.grouser_wi,3);
        %}

        % Load custom shoe profile
        %xc = load('track_shoe_profile_0p2m.mat');
        %Belt.xc = xc.track_shoe_profile_0p2m;

        % Depth of shoe plate
        Belt.pad_h      = 0.035;

        % Lug dimensions
        Belt.Lug.w      = 0.1595;  % Width (m)
        Belt.Lug.h      = 0.0634;  % Height (m)
        Belt.Lug.lb     = 0.1081;  % Length at base (m)
        Belt.Lug.lt     = 0.0584;  % Length at tip (m)

        % Lug extrusion
        Belt.Lug.xc     = [...
             Belt.Lug.lb/2   0;
             Belt.Lug.lt/2   Belt.Lug.h;
            -Belt.Lug.lt/2   Belt.Lug.h;
            -Belt.Lug.lb/2   0;
            ];

        % Geometry settings
        Belt.clr        = [0.3 0.3 0.3];
        %[0.37254903 0.3254902 0.2];
        Belt.opc        = 0.5;

        % Friction between segments
        Belt.damping   = 1;

        Belt.lug_contact.clr = [1.0 0.0 0.2];
        Belt.lug_contact.opc = 0.5;
        Belt.carcass_contact.clr  = [1.0 0.0 0.0];
        Belt.carcass_contact.opc  = 0.5;

        % Generate point cloud for plate contact
        temp_shoe_pts_all          = Point_Cloud_Data_Square(Belt.l,Belt.w,[3 8]);

        % Remove final row of points to avoid overlap
        min_x = min(temp_shoe_pts_all(:,1));
        inds =  find(temp_shoe_pts_all(:,1) == min_x);
        keepinds = setdiff(1:size(temp_shoe_pts_all,1),inds);
        temp_shoe_pts = temp_shoe_pts_all(keepinds,:);

        Belt.ptcld_sets.plate  = [temp_shoe_pts(:,1) temp_shoe_pts(:,1)*0-Belt.pad_h temp_shoe_pts(:,2)];

        

        % Generate point cloud for grouser contact
        %{
        temp_grouserPtsInd     = find(Belt.xc(:,2)>Belt.h*0.999);
        temp_grouserPts_w      = linspace(0,Belt.w,20)-Belt.w/2;

        temp_shoe_ptcld_grousers = [];
        for temp_i = 1:length(temp_grouserPts_w)
            temp_shoe_ptcld_grousers = [
                temp_shoe_ptcld_grousers;
                Belt.xc(temp_grouserPtsInd,:).*[1 -1] ones(length(temp_grouserPtsInd),1)*temp_grouserPts_w(temp_i)];
        end
        Belt.ptcld_sets.grousers = temp_shoe_ptcld_grousers;
        %}

        % By default, only use point cloud on shoe plate
        Belt.ground_contact.ptcld.pts     = Belt.ptcld_sets.plate;

        % Contact geometry visual settings for point cloud contact
        Belt.ground_contact.ptcld.rad = 2e-3;
        Belt.ground_contact.ptcld.clr = [1 1 0.06667];
        Belt.ground_contact.ptcld.opc = 1;

        % Custom mass settings for plate
        Belt.mass = 4.8279;
        Belt.cg   = [0 0 0];    % CG Location
        Belt.moi  = [0.23 0.24 0.011]; % Moments of inertia
        Belt.poi  = [0 0 0];                            % Products of inertia

        % Contact geometry visual settings for brick solid contact
        Belt.ground_contact.plate_solid.clr = [1 0 0];
        Belt.ground_contact.plate_solid.opc = 0;

    end

%% Rollers
    function Roller = Excv_Roller_Param(belt_lug_w, belt_h, belt_w)

        Roller.Lower.rad = 0.165; % m
        Roller.Lower.len = 0.2; % m
        Roller.Lower.rim_thk = 0.03; % m
        Roller.Lower.rim_len = 0.05; % m
        Roller.Lower.rho = 7800; % kg/m^3
        Roller.Lower.clr = [0.3 0.3 0.3];
        Roller.Lower.opc = 1;

        Roller.Lower.Axle.rad = 0.03; % m
        pin_lug_clearance    = 0.01; 
        Roller.Lower.Axle.len = belt_lug_w + pin_lug_clearance*2; % m
        Roller.Lower.Axle.rho = 7800; % kg/m^3
        Roller.Lower.Axle.clr = [0.3 0.3 0.3];
        Roller.Lower.Axle.opc = 1;

        %
        Roller.Lower.belt_contact.clr = [1 0 0];
        Roller.Lower.belt_contact.opc = 0.5;


        % Rolling radius = roller radius + belt pad height
        Roller.Lower.ground_contact.rolling_radius = ...
            Roller.Lower.rad+belt_h;
        lrrad = Roller.Lower.ground_contact.rolling_radius;

        % For Roller contact model - simpler roller model
        Roller.Lower.len_total =  Roller.Lower.len*2+Roller.Lower.Axle.len;
        Roller.Lower.rho_total = 7800*0.8;

        % Number of points on roller - will be adjusted to be even
        Roller.Lower.ground_contact.ptcld.npts = 30;
        npts = Roller.Lower.ground_contact.ptcld.npts;

        % Obtain point cloud
        Roller.Lower.ground_contact.ptcld.pts = Point_Cloud_Data_Cylinder(lrrad,belt_w,npts,0);

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
        Frame.SprkOffLon.Lower    = [-0.3514 0.0126 0.376];
        Frame.SprkOffLon.IdlerR   = -0.9376; 
        Frame.SprkOffLon.PivotFra = 0.0137; 
        Frame.SprkOffLon.TensionC = 0.441; 
        Frame.SprkOffLon.IdlerArm = 0.875; 
        Frame.SprkOffLon.Axle     = 0;

        % For abstract visualization only
        Frame.SprkOffLon.IdlerF   = 0.95039; 


        % Vertical distance from sprocket center to upper roller center
        Frame.SprkOffVer.Lower    = -1.0649;
        Frame.SprkOffVer.IdlerR   = -0.8509; 
        Frame.SprkOffVer.PivotFra = -0.4448; 
        Frame.SprkOffVer.TensionC = -0.5686; 
        Frame.SprkOffVer.IdlerArm = -1.006; 
        Frame.SprkOffVer.Axle     = 0;

        Frame.SprkOffVer.IdlerF   = -0.8509; 

        % Note - lower roller height is calculated based on 
        %        sprocket dimensions to keep chain flat

        % Vertical distance from sprocket center to idler center 
        % (design position - tensioner contracts for assembly, extends when in use)

        % Distance between bottom of lower roller, bottom of idler
        %Frame.IdlerRollerVoffset = 0.01; 

        % Mass parameters
        % Sprocket Frame
        Frame.SprkFrame.Mass = 100;
        % NOTE: x is longitudinal, y is vertical, z is lateral
        Frame.SprkFrame.CG   = [0 -0.2 0];
        Frame.SprkFrame.MOI  = [1 10 10];
        Frame.SprkFrame.POI  = [0 0 0];

        % Roller Frame
        Frame.TrackFrame.Mass = 100;
        % NOTE: x is longitudinal, y is vertical, z is lateral
        Frame.TrackFrame.CG   = [0.0137 -0.4448 0];
        Frame.TrackFrame.MOI  = [1 10 10];
        Frame.TrackFrame.POI  = [0 0 0];

        % Roller Frame Pivot
        Frame.PivotFra.Range   = 10;  % deg
        Frame.PivotFra.LimitK  = 1e4; % (N*m)/deg
        Frame.PivotFra.LimitB  = 10;  % (N*m)/(deg/s)
        Frame.PivotFra.LimitTW = 0.1; % deg

        % Distance from sprocket center to suspension attachment
        % Define as all positive values, mirroring for left/right happens in model
        % NOTE: x is longitudinal, y is vertical, z is lateral
        Frame.SuspOffset  = [1.2 -0.2 0.848];
        %Frame.SuspOffset  = [2.7750 0.1 0.45];
        
    end

    function Chassis = Excv_Chassis_Param
        Chassis.Mass        = 25546/4;        % kg
        Chassis.Front.Mass  = Chassis.Mass/2; % kg
        Chassis.Rear.Mass   = Chassis.Mass/2; % kg
        Chassis.MOI         = [53 53 53]*4;   % kg*m^2
        Chassis.Front.MOI   = Chassis.MOI/2;   % kg*m^2
        Chassis.Rear.MOI    = Chassis.MOI/2;   % kg*m^2
        Chassis.POI         = [0 0 0];        % kg*m^2
        Chassis.Front.POI   = Chassis.POI/2;        % kg*m^2
        Chassis.Rear.POI    = Chassis.POI/2;        % kg*m^2

        Chassis.AxleSeparation          = 3.15+0.72;    % m

        Chassis.Rear.CGOffset       = [-0.08   0.5 0];  % m
        Chassis.Rear.AxleOffset     = [0    0  0];  % m
        Chassis.Rear.SuspOffset     = [ 1     -0.1   0.65];     % m
        Chassis.Rear.CADOffset      = [0  0        0];     % m
        Chassis.Rear.HingeOffset    = [ 1.8  0     -0.61];     % m
        Chassis.Rear.TrackSepCtr    = 3.048-0.8;   % m
        Chassis.Rear.AxleRad        = 0.15;   % m

        Chassis.Front.CGOffset      = [-0.08   0.5 0];  % m
        Chassis.Front.AxleOffset    = [0    0  0];  % m
        Chassis.Front.SuspOffset    = [ 1     -0.1   0.65];     % m
        Chassis.Front.CADOffset     = [-3.15-0.72  0        0];     % m
        Chassis.Front.HingeOffset   = [-2.07  0     -0.61];     % m
        Chassis.Front.TrackSepCtr   = 3.048-0.8;   % m
        Chassis.Front.AxleRad       = 0.15;   % m

        % Double Axle tests

        Chassis.Camera.SprocketTrackCtr = 2; % m (for camera)
        Chassis.Camera.Sprocket2CtrRear = [-2 0 -0.5]; % m (for camera)
        Chassis.Camera.ToFront          = 3.5; % m (for camera)
        Chassis.Camera.ToFrontAimLR     = 180-30; % m (for camera)
        Chassis.Camera.ToLeftAimRight   = 4;
        Chassis.Camera.ToRightAimLeftTR = [0 -4 0.1];
        Chassis.Camera.ToIsoFR_xyz      = [4 -6 1];
        Chassis.Camera.ToIsoFR_rpy      = [155 20 0];
        Chassis.Camera.ToRightAimLeftTL = [0 -1.25 0.1];
        Chassis.Camera.LeftRearAimLF    = 2.2;
        Chassis.Camera.LeftRearAimLFAng = -15;
        Chassis.Camera.CtrRearAimLFAng  =  15;

        Chassis.Camera.FRAimFront_rpy   = [143     0 0];
        Chassis.Camera.FRAimFront_xyz   = [4.5 -0.1 0];

        Chassis.Camera.ToIsoFRBig_xyz      = [8 -2.5-2.2 2.5];
        Chassis.Camera.ToIsoFRBig_rpy      = [155-20 17 0];

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
        Chassis.Susp.Cylinder.xeq = 0.0;
        Chassis.Susp.Cylinder.k = 5e5;
        Chassis.Susp.Cylinder.b = 5e4;

        %% Chassis
        [tp, tpf, tpr] = tractor_chassis_profile_data;
        Chassis.Visual.profile_xc = tp;
        Chassis.Front.Visual.profile_xc = tpf;
        Chassis.Rear.Visual.profile_xc  = tpr;
        Chassis.Visual.wid        = 1;
        Chassis.Visual.clr        = [0.2 0.59607846 0.28627452];
        Chassis.Visual.opc        = 1.0;        
    end

%% Idler
    function [IdlerF, IdlerR] = Excv_Idler_Param(belt_lug_w, belt_h, belt_w,...
            roller_ptcld_npts, roller_rad)

        % Idler radius
        IdlerF.rad     = 0.350;
        IdlerF.Rim.rad = 0.33;
        % Idler length - must fit within chain
        IdlerF.len    = 0.2;

        IdlerF.Wheel.clr = [0.5 0.5 0.5];
        IdlerF.Wheel.clr = [0.5 0.5 0.5];

        IdlerF.rho    = 3000; % kg/^3

        IdlerF.Axle.rad = 0.025; % m
        idler_pin_lug_clearance    = 0.01; 
        IdlerF.Axle.len = belt_lug_w + idler_pin_lug_clearance*2; % m
        IdlerF.Axle.rho = 7800; % kg/m^3
        IdlerF.Axle.clr = [1 1 0];
        IdlerF.Axle.opc = 1;

        % For geometry - visual only
        idler_hub_rad = IdlerF.Rim.rad*0.5;
        idler_lip_rad  = IdlerF.Rim.rad*0.05;
        idler_axle_dep = 0.02;

        IdlerF.Rim.rim_xc = ...
            Extr_Data_Idler_Rim(IdlerF.Rim.rad, idler_hub_rad, ...
            idler_lip_rad, IdlerF.len);
        IdlerF.Rim.hub_rad = idler_hub_rad;

        IdlerR = IdlerF;

        % Color opacity
        IdlerF.clr    = [1 1 0];
        IdlerF.opc    = 1;
        IdlerR.clr    = [1 1 0];
        IdlerR.opc    = 1;

        % Contact geometry visual settings
        IdlerF.belt_contact.clr = [1 0 0];
        IdlerF.belt_contact.opc = 0.5;
        IdlerR.belt_contact.clr = [1 0 0];
        IdlerR.belt_contact.opc = 0.5;

        % Tensioner spring parameters
        IdlerF.Tensioner.xeq =  0.25;  % Preload distance for spring
        IdlerF.Tensioner.K   =  3e5;
        IdlerF.Tensioner.B   =  1e4;
        IdlerF.Tensioner.x0  =  0.2; % Compression at assembly

        % Tensioner Cylinder
        IdlerF.Tensioner.cyl.rad = 0.066;
        IdlerF.Tensioner.cyl.len = 0.35;
        IdlerF.Tensioner.cyl.rho = 2700;
        IdlerF.Tensioner.cyl.clr = [0.4 0.4 0.4];
        IdlerF.Tensioner.cyl.opc = 1;

        % For abstract model - assumes tensioner locked at max extension
        IdlerF.Tensioner.cyl.max_ext = 0.1/2; % m

        % Tensioner Piston
        IdlerF.Tensioner.piston.rad = 0.04;
        IdlerF.Tensioner.piston.len = 0.25;
        IdlerF.Tensioner.piston.rho = 1000;
        IdlerF.Tensioner.piston.clr = [0.8 0.8 0.8];
        IdlerF.Tensioner.piston.opc = 1;

        % Tensioner Bracket
        IdlerF.Tensioner.bracket.len    = 0.2;
        IdlerF.Tensioner.bracket.wid    = 0.125;
        IdlerF.Tensioner.bracket.height = 0.1;
        IdlerF.Tensioner.bracket.thk    = 0.02;
        IdlerF.Tensioner.bracket.rho    = 2700;
        IdlerF.Tensioner.bracket.clr    = [0.8 0.8 0.8];
        IdlerF.Tensioner.bracket.opc    = 1;

        % Idler rolling radius for ground contact
        % Idler radius + chain plate height + shoe pad height
        IdlerF.ground_contact.rolling_radius   = IdlerF.rad+belt_h;
        idlerF_cloud_rad = IdlerF.ground_contact.rolling_radius;
        IdlerR.ground_contact.rolling_radius   = IdlerR.rad+belt_h;
        idlerR_cloud_rad = IdlerR.ground_contact.rolling_radius;

        % Idler length for roller ground contact
        IdlerF.len_total = IdlerF.len*2+IdlerF.Axle.len+1e-3;
        IdlerF.rho_avg = IdlerF.rho*0.8;

        IdlerR.len_total = IdlerR.len*2+IdlerR.Axle.len+1e-3;
        IdlerR.rho_avg = IdlerR.rho*0.8;
    

        % Scale number of points on idler to have same density (points/area)
        % as on lower roller
        npts_idlerF         = ceil(roller_ptcld_npts*idlerF_cloud_rad/roller_rad);
        IdlerF.ground_contact.ptcld.pts = Point_Cloud_Data_Cylinder(idlerF_cloud_rad,belt_w,npts_idlerF,0);
        npts_idlerR         = ceil(roller_ptcld_npts*idlerR_cloud_rad/roller_rad);
        IdlerR.ground_contact.ptcld.pts = Point_Cloud_Data_Cylinder(idlerR_cloud_rad,belt_w,npts_idlerR,0);

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

    function IdlerArm = Excv_IdlerArm_Param
        % Stiffness and damping for drive shaft
        IdlerArm.Pivot_to_Idler      =  0.165;
        IdlerArm.Pivot_to_TensionerX =  0.3182;
        IdlerArm.Pivot_to_TensionerY =  0.1286;

        IdlerArm.wid                 =  0.075;
        IdlerArm.thk                 =  0.05;
        IdlerArm.rho                 =  7800;
        IdlerArm.clr                 =  [0.2 0.4 0.6];
        IdlerArm.opc                 =  1;
    end

    function Drive = Excv_Drive_Param
        % Stiffness and damping for drive shaft
        Drive.Shaft.k    = 1e5;
        Drive.Shaft.b    = 1e4;
    end

    function TrackVis = Excv_TrackVis_Param(C, R)
        % Parameters for track visualization extrusion
        % Note that the extrusion uses the same radius for the front and
        % rear end, so if the sprocket and idler have different rolling radii, 
        % the extrusion will not line up perfectly with the contact geometry


        % Obtain extrusion data
        track_xc = Extr_Data_Belt_Frame(C, R);
        TrackVis.track_xc = track_xc;

        % Inertial properties of stretched, unmoving track
        TrackVis.m   = 50;
        TrackVis.cg  = [-0.5 0 0];
        TrackVis.moi = [5 10 10];
        TrackVis.poi = [0 0 0];

        % Visual properties
        TrackVis.clr = [0.5 0.5 0.5];
        TrackVis.opc = 0.5;
    end

end