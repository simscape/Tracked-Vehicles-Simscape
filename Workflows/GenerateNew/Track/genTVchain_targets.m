function [track_joint_targets, tensioner_x0] = genTVchain_targets(simlog)

% Extract set of joint targets for loop of track chain segments
trackLogFields = fieldnames(simlog.Track.Track);
segFieldInds   = startsWith(fieldnames(simlog.Track.Track),'Seg_');

segFields      = sort(trackLogFields(segFieldInds));

% Loop over segments
for i = 1:length(segFields)

    % Extract final angle of chain segment
    qVal = simlog.Track.Track.(segFields{i}).Revolute_Joint.Rz.q.series.values;
    qChain(i) = qVal(end); %#ok<AGROW>

    % Assemble cell array with joint target information
    track_joint_targets{i,1} = 'on'; %#ok<AGROW>
    track_joint_targets{i,2} = 'Low'; %#ok<AGROW>
    track_joint_targets{i,3} = qChain(i); %#ok<AGROW>
end

% Cannot have joint targets all the way around a loop
% Turn off joint target whose value is nearest to 0
[~, minQi] = min(abs(qChain));
track_joint_targets{minQi,1} = 'off';

tensioner_x0_res = simlog.Track.Undercarriage.Rollers.Prismatic_Tensioner.Pz.p.series.values('m');

tensioner_x0 = tensioner_x0_res(end);