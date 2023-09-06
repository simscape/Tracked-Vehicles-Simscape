%% Roller Chain, Idler Chain
Excv.Chain.plate_opc = 0.4;

Excv.Roller.Upper.opc = 0.2;
Excv.Roller.Lower.opc = 0.2;

Excv.Chain.contact_geo.chain_to_roller.opc = 0;

Excv.Shoe.contact_geo.plate_ptcld.opc = 0;

Excv.Idler.contact_geo.opc = 1;
Excv.Idler.opc = 0.1;

%% Segment
Excv.Chain.pin_opc = 0.2;
Excv.Chain.contact_geo.chain_to_teeth.opc = 1;
Excv.Chain.contact_geo.chain_to_teeth.clr = [1 0.2 0.2];

Excv.Shoe.ptcld.opc = 1;
Excv.Shoe.ptcld.rad = 2e-3;

Excv.Shoe.opc = 0.5;
Excv.Shoe.contact_geo.plate_solid.opc = 1;

%% Sprocket Chain
Excv.Chain.contact_geo.chain_to_roller.opc = 0;

Excv.Chain.pin_opc = 0;
Excv.Sprocket.sprocket_opc = 0.1;
Excv.Chain.contact_geo.chain_to_teeth.opc = 1;
Excv.Chain.plate_opc = 0.1;
Excv.Roller.Upper.opc = 0.2;
Excv.Roller.Lower.opc = 0.2;

%% Full track
Excv = sm_excv_track_param_machine;
Excv.Chain.contact_geo.chain_to_roller.opc = 0.2;
Excv.Chain.contact_geo.chain_to_teeth.opc = 1;
Excv.Chain.plate_opc = 0.1;
Excv.Chain.pin_opc = 0.4;
Excv.Roller.Upper.opc = 0.2;
Excv.Roller.Lower.opc = 0.2;
Excv.Sprocket.sprocket_opc = 0.1;
Excv.Sprocket.contact_geo_ptcld.rad = 4e-3;
Excv.Idler.contact_geo.opc = 1;
Excv.Idler.opc = 0.1;

%% Chain Segment Brick Solid
Excv = sm_excv_track_param_machine;

Excv.Chain.plate_opc = 0.1;
Excv.Chain.pin_opc = 0.2;
Excv.Shoe.opc = 0.5;

Excv.Chain.contact_geo.chain_to_roller.opc = 1;
Excv.Chain.contact_geo.chain_to_teeth.opc = 0.2;
Excv.Chain.contact_geo.chain_to_teeth.clr = [1 0.2 0.2];

%% Chain Segment Spherical Solid
Excv = sm_excv_track_param_machine;

Excv.Chain.plate_opc = 0.1;
Excv.Chain.pin_opc = 0.2;
Excv.Shoe.opc = 0.5;

Excv.Chain.contact_geo.chain_to_roller.opc = 0.2;
Excv.Chain.contact_geo.chain_to_teeth.opc = 1;
Excv.Chain.contact_geo.chain_to_teeth.clr = [1 0.2 0.2];

%% Chain Segment Shoe Plate Solid

rng(1,'twister');
rand(1);
s=rng;

Excv = sm_excv_track_param_machine;

%Excv.Chain.plate_opc = 0.1;
%Excv.Chain.pin_opc = 0.2;
Excv.Shoe.opc = 0.4;
Excv.Shoe.contact_geo.plate_solid.opc = 1;
