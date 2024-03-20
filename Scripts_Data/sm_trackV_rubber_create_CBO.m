function [CBO_TrSpr, CBO_TrRoll] = sm_trackV_rubber_create_CBO(numSeg) 
% CREATE_CBO_TREADSPROCKET initializes a set of bus objects in the MATLAB base workspace 

% Connection bus object: CBO_TreadLug 
elems(1) = Simulink.ConnectionElement;
elems(1).Name = 'A';
elems(1).Type = 'Connection: simmechanics.connections.geometry';
elems(1).Description = '';

elems(2) = Simulink.ConnectionElement;
elems(2).Name = 'B';
elems(2).Type = 'Connection: simmechanics.connections.geometry';
elems(2).Description = '';

CBO_TreadLug = Simulink.ConnectionBus;
CBO_TreadLug.Description = '';
CBO_TreadLug.Elements = elems;
assignin('base','CBO_TreadLug', CBO_TreadLug);


% Connection bus object: CBO_TreadSprocket 
portLabel = "L";
for e_i = 1:numSeg
    elem(e_i,1)             = Simulink.ConnectionElement;
    elem(e_i,1).Name        = portLabel + pad(num2str(e_i),2,'left','0');
    elem(e_i,1).Type        = 'Bus: CBO_TreadLug';
    elem(e_i,1).Description = '';
end

CBO_TrSpr = Simulink.ConnectionBus;
CBO_TrSpr.Description = '';
CBO_TrSpr.Elements = elem;

clear elem
portLabel = "T";
for e_i = 1:numSeg
    elem(e_i,1)             = Simulink.ConnectionElement;
    elem(e_i,1).Name        = portLabel + pad(num2str(e_i),2,'left','0');
    elem(e_i,1).Type        = 'Connection: simmechanics.connections.geometry';
    elem(e_i,1).Description = '';
end

CBO_TrRoll = Simulink.ConnectionBus;
CBO_TrRoll.Description = '';
CBO_TrRoll.Elements = elem;


