%% Tracked Vehicle Documentation, Articulated Chassis
% 
% Documentation for parameters of articulated chassis.
%
% Copyright 2023-2024 The MathWorks, Inc.

%% Chassis Model
%
% Articulated Chassis

load_system('sm_excv_chassis_lib');
open_system('sm_excv_chassis_lib/Chassis 4 Track No Suspension','force');

%%
% Chassis Front

load_system('sm_excv_chassis_lib');
open_system('sm_excv_chassis_lib/Chassis Articulated Front','force');

%%
% Chassis Rear

load_system('sm_excv_chassis_lib');
open_system('sm_excv_chassis_lib/Chassis Articulated Rear','force');


%% Reference Frames
%
% <<sm_tracked_vehicle_doc_chassisArtic_dims.png>>

%% Parameters, Chassis Front / Rear
%
% The offsets in the chassis are defined relative to the sprocket location
% projected onto the central plane of the chassis.  The chassis is
% articulated with a joint between the front half and the rear half of the
% chassis.  The offsets are relative to the sprockets on the respective
% chassis half.
%
% |Trac.Chassis.Front| 
Trac.Chassis.Front

%% Parameters, Chassis
%
% The only parameter unique to the chassis is |AxleSeparation| which only
% used in the steering model.  The steering model adjusts track angles per
% ackermann steering in one model, and it adjusts sprocket drive speed for
% the inner and outer tracks.  This parameter is somewhat abstract, as
% this approximation assumes a small contact patch and our tracks have a
% large contact patch.  The other chassis parameters are mainly reference.
%
% |Trac.Chassis| 
Trac.Chassis

%%
close all
bdclose all
