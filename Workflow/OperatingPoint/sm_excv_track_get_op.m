function op = sm_excv_track_get_op(mdl)
%mdl = sm_excv_track2_ptcld;

mdlStopTime  = get_param(mdl,'StopTime');
mdlSimlogVar = get_param(mdl,'SimscapeLogName');

set_param(mdl,'StopTime','2');
sim(mdl)
set_param(mdl,'StopTime',mdlStopTime);

simlogRes = eval(mdlSimlogVar);

op = simscape.op.create(simlogRes,2);
