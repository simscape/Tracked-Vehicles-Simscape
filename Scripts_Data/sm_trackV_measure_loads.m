function sm_trackV_measure_loads(var_track_h,sigMeas)
% Function to set block parameter for measurement setting.
% Used function to simplify maintenance of setting.

set_param(var_track_h,'popup_sense_roller',sigMeas);