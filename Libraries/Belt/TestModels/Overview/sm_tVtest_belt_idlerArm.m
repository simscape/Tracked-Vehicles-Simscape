%% Idler Arm with Tensioner
% 
% <<sm_tVtest_belt_idlerArm_Overview.png>>
%
% (<matlab:web('Tracked_Vehicle_Simscape_Overview.html') return to Tracked Vehicle Model with Simscape Overview>)
%
% This example shows the idler arm and its tensioner cylinder.
%
% Copyright 2023-2025 The MathWorks, Inc.

%% Model
%
% In this example an idler arm is modeled with its tensioner cylinder.
%
% <matlab:open_system('sm_tVtest_belt_idlerArm'); Open Model>

open_system('sm_tVtest_belt_idlerArm')

set_param(find_system('sm_tVtest_belt_idlerArm','FindAll', 'on','type','annotation','Tag','ModelFeatures'),'Interpreter','off')


%% Idler
%
% The edges of the idler press against the belt carcass. To streamline the
% contact force calculation, simpler geometry is connected to the Planar
% Contact Force block.
%
% # Disk geometry is used to model the idler contacting the carcass.
%
% <<sm_belt_contact_rollerToCarcass_Overview.png>>
%
% <matlab:open_system('sm_tVtest_belt_idlerArm');open_system('sm_tVtest_belt_idlerArm/Idler','force'); Open Subsystem>

set_param('sm_tVtest_belt_idlerArm/Idler','LinkStatus','none')
open_system('sm_tVtest_belt_idlerArm/Idler','force')


%%

close all
bdclose('sm_tVtest_belt_idlerArm');
