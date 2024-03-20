%% Load targets for track segments
track_joint_targets      = sm_excv_track_segTargets_46seg1Idler(Excv.Chain.pin_sep, Excv.Sprocket.sprocket_rPitch);
track_joint_targetsC46I2 = sm_excv_track_segTargets_46seg2Idler(ExcvI2R4.Chain.pin_sep, ExcvI2R4.Sprocket.sprocket_rPitch);

%% Scene Road
Scene.Road.Bump.len      = 0.1;
Scene.Road.Bump.wid      = 1.2;
Scene.Road.Bump.hgt      = 0.05;
Scene.Road.Bump.startx   = 5;
Scene.Road.Bump.deltax   = 1.75;
Scene.Road.Bump.offsety  = 1.10;
Scene.Road.Bump.offsetz  = 0;

Scene.Road.len = 25;
Scene.Road.wid = 5;
Scene.Road.hgt = 0.02;

%% Scene Road with Rod
Scene.Road.Rod.len      = 4; % m
Scene.Road.Rod.rad      = 0.75*2.54/100; % m
Scene.Road.Rod.startx   = 5-0.1; % m
Scene.Road.Rod.offsety  = 0; % m
Scene.Road.Rod.offsetz  = 0.75*2.54/100; % m
Scene.Road.Rod.qz       = 0; % deg


%% Scene Hills
Scene.Terrain = stl_to_gridsurface('hills_terrain.stl',100,100,'n');

%% Scene Slope
Scene.Slope.road_len    = 25;
Scene.Slope.road_wid    = 9;
Scene.Slope.slope_run   = 7.5;
Scene.Slope.slope_rise  = 1.5;
Scene.Slope.slope_start = 5;
Scene.Slope.slope_xres  = 0.2;
Scene.Slope.clr         = [0.9216 0.8431 0.6627];
Scene.Slope.opc         = 1;

%% Plane
Scene.Plane.l      = 32;
Scene.Plane.w      = 32;
Scene.Plane.offset = [0 Scene.Plane.w/2-2 0];

%% Surface Contact Parameters
Scene.Contact.Terrain.K   = 1e5;
Scene.Contact.Terrain.B   = 1e3;
Scene.Contact.Terrain.TW  = 1e-3;
Scene.Contact.Terrain.mud = 0.5;
Scene.Contact.Terrain.mus = 0.5;
Scene.Contact.Terrain.CV  = 1e-1;

Scene.Contact.BrickBump.K  = 1e7;
Scene.Contact.BrickBump.B  = 1e5;
Scene.Contact.BrickBump.TW = 1e-3;

%% Surface Contact Parameters
Scene.Contact.Spheres.Terrain.K   = 1e5*10;
Scene.Contact.Spheres.Terrain.B   = 1e3*10;
Scene.Contact.Spheres.Terrain.TW  = 1e-3;
Scene.Contact.Spheres.Terrain.mud = 0.5;
Scene.Contact.Spheres.Terrain.mus = 0.5;
Scene.Contact.Spheres.Terrain.CV  = 1e-1;

%% Rough Road
Scene.Rough_Road = sm_car_scenedata_rdf_rough_road;

%% Plateau
Scene.Plateau = sm_car_scenedata_rdf_plateau;

%% Grid
Scene.Grid.length       = 400;  % m
Scene.Grid.width        = 400;  % m
Scene.Grid.depth        = 0.02; % m
Scene.Grid.linewidth    = 0.08; % m
Scene.Grid.numsquaresx  = 40; % m
Scene.Grid.numsquaresy  = 40; % m
Scene.Grid.linecolor    = [1 1 1]; % [RGB]
Scene.Grid.planecolor   = [0.8 0.8 0.8]; % [RGB]

%% Patch
Scene.Patch.l   = Excv.Roller.Lower.ground_contact.rolling_radius*2;
Scene.Patch.w   = Excv.Roller.Lower.ground_contact.rolling_radius*2;
Scene.Patch.clr = [1 1 1]*0.5;
Scene.Patch.opc = 0.25;

