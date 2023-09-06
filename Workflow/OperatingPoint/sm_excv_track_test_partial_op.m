mdl = 'sm_excv_track2_ptcld';

set_param(mdl,'SimscapeUseOperatingPoints','off')
opStart = simscape.op.create(mdl,'Start');

op2SecFull = sm_excv_track_get_op(mdl);

opTrackL = get(op2SecFull,'Track L');
opTrackR = get(op2SecFull,'Track R');

opNew = opStart;

opTracks = set(opNew,'Track L',opTrackL);
opTracks = set(opTracks,'Track R',opTrackR);
