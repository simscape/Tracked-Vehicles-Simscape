function [track_joint_targets, tensioner_x0] = genTVchain_targets_planar(simlog)

% Extract set of joint targets for loop of track chain segments
trackLogFields = fieldnames(simlog.Track.Track);
segFieldInds   = startsWith(fieldnames(simlog.Track.Track),'Seg_');

segFields      = sort(trackLogFields(segFieldInds));

% Loop over segments
for i = 1:length(segFields)

    % Extract final angle of chain segment
    %qVal = simlog.Track.Track.(segFields{i}).Revolute_Joint.Rz.q.series.values;

    qVal = simlog.Track.Track.(segFields{i}).Planar_Joint.Rz.q.series.values;
    xVal = simlog.Track.Track.(segFields{i}).Planar_Joint.Px.p.series.values;
    yVal = simlog.Track.Track.(segFields{i}).Planar_Joint.Py.p.series.values;

    qChain(i) = qVal(end); %#ok<AGROW>
    xChain(i) = xVal(end); %#ok<AGROW>
    yChain(i) = yVal(end); %#ok<AGROW>

    % Assemble cell array with joint target information
    track_joint_targets{i,1} = 'on'; %#ok<AGROW>
    track_joint_targets{i,2} = 'Low'; %#ok<AGROW>
    track_joint_targets{i,3} = qChain(i); %#ok<AGROW>
    track_joint_targets{i,4} = xChain(i); %#ok<AGROW>
    track_joint_targets{i,5} = yChain(i); %#ok<AGROW>

end

% Cannot have joint targets all the way around a loop
% Turn off joint target whose value is nearest to 0
[~, minQi] = min(abs(qChain));
track_joint_targets{minQi,1} = 'off';

rollerFieldNames = fieldnames(simlog.Track.Undercarriage.Rollers);

if(~isempty(find(strcmp(rollerFieldNames,'Prismatic_Tensioner'), 1)))
    tensioner_x0_res = simlog.Track.Undercarriage.Rollers.Prismatic_Tensioner.Pz.p.series.values('m');
    tensioner_x0 = tensioner_x0_res(end);
else
    tensioner_x0 = 0;
end