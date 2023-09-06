function track_seg_tgts = sm_excv_track_segTargets_46seg1Idler(pin_sep, sprk_pitch_rad)

%% Joint Targets for track segments
%
% This cell array contains the joint targets for the track.  
% The row of the array aligns with the track segment number.
% 
% Explanation of assembly: 
% 1. The location of the track pin furthest from the idler is fixed at assembly.
% 2. High priority and input parameters are use to mesh track pins 
%    with the correct sprocket teeth.
% 3. High priority targets are used to get the lower surface of the track
%    close to horizontal so it does not collide with the ground.
% 4. High priority targets are used to curve the track around the idler
% 5. Low priority targets are used for the upper surface of the track
% 6. One target is set to 'off' to avoid setting targets in a full loop.
%
% Adjusting targets below:
% 1. Make sure the number of rows matches the number of track segments.
% 2. Use qSegSpr for as many segments as it takes to wrap just less than
%    one quarter the way around the track.
% 3. Use two targets to get lower track edge to be near horizontal
%    Adjust gains and row number of non-zero targets to achieve this goal.
% 4. By visual inspection, determine which links will curve around idler.
% 5. Use qSegSpr to set angles around idler, but do not get too close to the idler.
% 6. Use low priority targets with two targets with small, equal non-zero values 
%    to complete the loop of track.  
% 7. Set one target priority to 'off', ideally near the middle of the upper
%    edge of the track.
%
% Done correctly, you should only be making small adjustments to gains
% and the rows where non-zero targets appear.

% Calculate angle between track segments
qSegSpr = (90-acosd(pin_sep/2/sprk_pitch_rad))*2;

track_seg_tgts = {...
    'on'     'High'    qSegSpr   %%
    'on'     'High'    qSegSpr 
    'on'     'High'    qSegSpr 
    'on'     'High'    qSegSpr*0.1 
    'on'     'High'    0  
    'on'     'High'    90-(2.5+0.1)*qSegSpr 
    'on'     'High'    0
    'on'     'High'    0 
    'on'     'High'    0 
    'on'     'High'    0  
    'on'     'High'    0
    'on'     'High'    0      
    'on'     'High'    0      
    'on'     'High'    0      
    'on'     'High'    0
    'on'     'High'    0
    'on'     'High'    0      
    'on'     'High'    0      
    'on'     'High'    90-(2.5+0.1)*qSegSpr 
    'on'     'High'    0  
    'on'     'High'    qSegSpr*0.2 
    'on'     'High'    qSegSpr
    'on'     'High'    qSegSpr 
    'on'     'High'    qSegSpr 
    'on'     'High'    qSegSpr 
    'on'     'Low'     qSegSpr*0.5 
    'on'     'Low'     0  
    'on'     'Low'     0 
    'on'     'Low'     0  
    'on'     'Low'     0 
    'on'     'Low'     0 
    'on'     'Low'     0
    'on'     'Low'     qSegSpr*0.1  
    'on'     'Low'     0 
    'off'    'Low'     0 
    'on'     'Low'     0 
    'on'     'Low'     0 
    'on'     'Low'     qSegSpr*0.1  
    'on'     'Low'     0  
    'on'     'Low'     0
    'on'     'Low'     0 
    'on'     'Low'     0 
    'on'     'Low'     0 
    'on'     'Low'     0   
    'on'     'Low'     qSegSpr*0.5  
    'on'     'High'    qSegSpr 
    }; 