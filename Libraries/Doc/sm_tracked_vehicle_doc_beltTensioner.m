%% Tracked Vehicle Documentation, Tensioner for Belt Track
% 
% Documentation for parameters of tensioner used on belted track, which
% includes cylinder, piston, and bracket.  The spring force is modeled
% using the internal mechanics of the Prismatic Tensioner Joint.
%
% Copyright 2023-2025 The MathWorks, Inc.

%% Test Model for Tensioner
%
% This test model shows the tensioner, idler arm, and idler.
%
% <matlab:open_system('sm_tVtest_belt_idlerArm'); Open Model>

open_system('sm_tVtest_belt_idlerArm');

%% Reference Frames
%
% <<sm_tracked_vehicle_doc_beltTensioner_dims.png>>

%% Parameters, Tensioner
%
% |Trac.IdlerF.Tensioner| 
Trac.IdlerF.Tensioner

%% Parameters, Cylinder
% |Trac.IdlerF.Tensioner.cyl| 
Trac.IdlerF.Tensioner.cyl

%% Parameters, Piston
% |Trac.IdlerF.Tensioner.piston| 
Trac.IdlerF.Tensioner.piston

%% Parameters, Bracket
% |Trac.IdlerF.Tensioner.bracket| 
Trac.IdlerF.Tensioner.bracket

%%
close all
bdclose all
