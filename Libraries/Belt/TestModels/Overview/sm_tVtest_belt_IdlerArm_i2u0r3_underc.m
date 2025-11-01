%% Undercarriage Test
% 
% <<sm_tVtest_belt_IdlerArm_i2u0r3_underc_Overview.png>>
%
% (<matlab:web('Tracked_Vehicle_Simscape_Overview.html') return to Tracked Vehicle Model with Simscape Overview>)
%
% This example shows the placement of the components in the undercarriage.
%
% Copyright 2023-2025 The MathWorks, Inc.

%% Model
%
% In this example a sprocket, fixed idler, idler with tensioner, and three
% rollers are shown.  Contact geometry is also modeled.
%
% <matlab:open_system('sm_tVtest_belt_IdlerArm_i2u0r3_underc'); Open Model>

open_system('sm_tVtest_belt_IdlerArm_i2u0r3_underc')

set_param(find_system('sm_tVtest_belt_IdlerArm_i2u0r3_underc','FindAll', 'on','type','annotation','Tag','ModelFeatures'),'Interpreter','off')

%% Undercarriage
%
% The undercarriage is separated into two pieces.  The frame connects 
% the chassis of the vehicle to the moving elements, including sprocket,
% rollers, idlers, and tensioner.  The Rollers subsystem contains the parts
% of the undercarriage which move.
%
% <matlab:open_system('sm_tVtest_belt_IdlerArm_i2u0r3_underc');open_system('sm_tVtest_belt_IdlerArm_i2u0r3_underc/Undercarriage','force'); Open Subsystem>

set_param('sm_tVtest_belt_IdlerArm_i2u0r3_underc/Undercarriage','LinkStatus','none')
open_system('sm_tVtest_belt_IdlerArm_i2u0r3_underc/Undercarriage','force')

%% Frame
%
% The frame connects the chassis of the vehicle to the moving elements.
% Connection points for the sprocket, idler, tensioner, and rollers are
% provided. The portion of the frame holding the rollers, idler, and
% tensioner can be configured to have a rigid connection to the chassis.
% That portion of the frame may also be permitted to rotate with respect to
% the chassis.  A variant subsytem configures that connection.
%
% <matlab:open_system('sm_tVtest_belt_IdlerArm_i2u0r3_underc');open_system('sm_tVtest_belt_IdlerArm_i2u0r3_underc/Undercarriage/Frame','force'); Open Subsystem>

set_param('sm_tVtest_belt_IdlerArm_i2u0r3_underc/Undercarriage/Frame','LinkStatus','none')
open_system('sm_tVtest_belt_IdlerArm_i2u0r3_underc/Undercarriage/Frame','force')



%% Rollers
%
% This subsytem contains the sprocket, idlers, tensioner, and rollers. To
% streamline the contact force calculation, simple geometry is used for
% contact detection.  The spring for the tensioner is modeled within
% Prismatic Tensioner.
%
% <matlab:open_system('sm_tVtest_belt_IdlerArm_i2u0r3_underc');open_system('sm_tVtest_belt_IdlerArm_i2u0r3_underc/Undercarriage/Rollers','force'); Open Subsystem>

set_param('sm_tVtest_belt_IdlerArm_i2u0r3_underc/Undercarriage/Rollers','LinkStatus','none')
open_system('sm_tVtest_belt_IdlerArm_i2u0r3_underc/Undercarriage/Rollers','force')

%% Sprocket
%
% The sprocket has spokes which press against the belt lugs. The edges of
% the sprocket press against the belt carcass. To streamline the contact
% force calculation, simpler geometry is connected to the Planar Contact
% Force block.
%
% 1. Disk geometry is used to model the sprocket contacting the carcass.
%
% <<sm_belt_contact_sprocketToCarcass_Overview.png>>
%
% 2. Disk geometry is used to model contact between each spoke and the lugs 
%
% <<sm_belt_contact_sprocketToLugs_Overview.png>>
%
% <matlab:open_system('sm_tVtest_belt_IdlerArm_i2u0r3_underc');open_system('sm_tVtest_belt_IdlerArm_i2u0r3_underc/Undercarriage/Rollers/Sprocket','force'); Open Subsystem>

set_param('sm_tVtest_belt_IdlerArm_i2u0r3_underc/Undercarriage/Rollers/Sprocket','LinkStatus','none')
open_system('sm_tVtest_belt_IdlerArm_i2u0r3_underc/Undercarriage/Rollers/Sprocket','force')

%% Idler
%
% The edges of the idler press against the belt carcass. To streamline the
% contact force calculation, simpler geometry is connected to the Planar
% Contact Force block.  The same approach is used for the rollers.
%
% # Disk geometry is used to model the idler contacting the carcass.
%
% <<sm_belt_contact_rollerToCarcass_Overview.png>>
%
% <matlab:open_system('sm_tVtest_belt_IdlerArm_i2u0r3_underc');open_system('sm_tVtest_belt_IdlerArm_i2u0r3_underc/Undercarriage/Rollers/IdlerR','force'); Open Subsystem>

set_param('sm_tVtest_belt_IdlerArm_i2u0r3_underc/Undercarriage/Rollers/IdlerR','LinkStatus','none')
open_system('sm_tVtest_belt_IdlerArm_i2u0r3_underc/Undercarriage/Rollers/IdlerR','force')


%%

close all
bdclose('sm_tVtest_belt_IdlerArm_i2u0r3_underc');
