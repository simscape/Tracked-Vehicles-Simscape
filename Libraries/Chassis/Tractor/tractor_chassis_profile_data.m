function [tp, tpf, tpr] = tractor_chassis_profile_data

% -------------------------------------------------------------------
%  Generated by MATLAB on 16-Mar-2024 15:21:34
%  MATLAB version: 23.2.0.2485118 (R2023b) Update 6
% -------------------------------------------------------------------
                                                       

tractor_chassis_profile = ...
  [1.2913043478260871 0.57391304347826111;
   0.79565217391304333 0.54782608695652213;
   0.682608695652174 0.71304347826086989;
   -0.33478260869565224 0.71304347826086989;
   -0.92608695652173911 0.80000000000000027;
   -1.4565217391304348 0.973913043478261;
   -1.4565217391304348 0.81739130434782625;
   -1.4391304347826086 0.54782608695652213;
   -1.4739130434782608 -0.05217391304347796;
   -0.9521739130434782 -0.19130434782608674;
   -0.66521739130434776 -0.25217391304347814;
   -0.36956521739130421 -0.25217391304347814;
   -0.36956521739130421 -0.42608695652173889;
   -0.36086956521739122 -0.643478260869565;
   -0.14347826086956528 -0.68695652173913047;
   0.30869565217391304 -0.79130434782608683;
   0.73478260869565237 -0.834782608695652;
   1.0739130434782609 -0.80869565217391282;
   1.0391304347826089 0;
   1.3782608695652174 0;
   1.5347826086956522 -0.26086956521739113;
   1.5086956521739132 -0.59999999999999964;
   1.5000000000000002 -0.76521739130434785;
   1.5260869565217392 -1.1478260869565216;
   1.5956521739130436 -1.2086956521739129;
   1.5608695652173912 -1.5652173913043477;
   1.5695652173913046 -1.8173913043478258;
   1.5956521739130436 -1.9913043478260868;
   1.4826086956521738 -2.026086956521739;
   1.4043478260869564 -2.0782608695652174;
   1.4304347826086958 -2.1391304347826088;
   1.656521739130435 -2.1913043478260867;
   1.9173913043478261 -2.2086956521739127;
   2.2826086956521738 -2.2173913043478262;
   2.6739130434782608 -2.2260869565217387;
   2.9347826086956523 -2.2086956521739127;
   3.160869565217391 -2.1826086956521737;
   3.2043478260869565 -2.0956521739130434;
   3.1347826086956516 -2.034782608695652;
   2.9869565217391303 -1.9739130434782606;
   3.0304347826086957 -1.5391304347826085;
   3.0217391304347823 -1.1217391304347823;
   3.2478260869565219 -1.1217391304347823;
   3.3869565217391306 -1.2347826086956519;
   3.6565217391304348 -1.2434782608695651;
   3.8826086956521735 -1.2173913043478259;
   4.6652173913043473 -1.1565217391304345;
   5.195652173913043 -1.034782608695652;
   5.7086956521739127 -0.90434782608695641;
   5.8217391304347821 -0.826086956521739;
   5.7695652173913041 -0.53043478260869525;
   5.7 -0.27826086956521712;
   5.6217391304347828 -0.05217391304347796;
   5.552173913043478 0.1739130434782612;
   5.5260869565217385 0.34782608695652195;
   5.5086956521739125 0.48695652173913073;
   5.4130434782608692 0.60869565217391308;
   3.2652173913043478 0.5913043478260871;
   1.5434782608695652 0.57391304347826111];

tp = tractor_chassis_profile;
tpr = tractor_chassis_profile([1:20 end],:);
tpf = tractor_chassis_profile(20:end,:)+[-3.87 0];