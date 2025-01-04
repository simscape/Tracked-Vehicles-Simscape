function track_seg_tgts = sm_excv_track_segTargets_forAsy(pin_sep, sprk_pitch_rad,nSeg)

%% Joint Targets for track segments
% Calculate angle between track segments
qSegSpr = (90-acosd(pin_sep/2/sprk_pitch_rad))*2;

for i = 1:nSeg
    if((i<4)||(i>(nSeg-2)))
        track_seg_tgts{i,1} = 'on';
        track_seg_tgts{i,2} = 'High';
        track_seg_tgts{i,3} = qSegSpr;
    elseif ((i>nSeg/2-3)&&(i<nSeg/2+3))
        track_seg_tgts{i,1} = 'off';
        track_seg_tgts{i,2} = 'Low';
        track_seg_tgts{i,3} = 0;
    else
        track_seg_tgts{i,1} = 'on';
        track_seg_tgts{i,2} = 'Low';
        track_seg_tgts{i,3} = qSegSpr*3*0+1;
    end
end

