function CBO = sm_excv_track_create_CBO(busType,numElem)

switch busType
    case "Roller", portLabel = "P"; 
    case "Chain",  portLabel = "L";
    case "Road",   portLabel = "B";
end

CBO             = Simulink.ConnectionBus;
CBO.Description = ['Connection Bus Object for ' busType '  with ' num2str(numElem) ' elements.'];

if(portLabel=="B")
    elem{1}(1,1)             = Simulink.ConnectionElement;
    elem{1}(1,1).Name        = "Road";
    elem{1}(1,1).Type        = 'Connection: simmechanics.connections.geometry';
    elem{1}(1,1).Description = '';


    for e_i = 1:numElem
        elem{1}(e_i+1,1)             = Simulink.ConnectionElement;
        elem{1}(e_i+1,1).Name        = portLabel + num2str(e_i);
        elem{1}(e_i+1,1).Type        = 'Connection: simmechanics.connections.geometry';
        elem{1}(e_i+1,1).Description = '';
    end
else
    for e_i = 1:numElem
        elem{1}(e_i,1)             = Simulink.ConnectionElement;
        elem{1}(e_i,1).Name        = portLabel + num2str(e_i);
        elem{1}(e_i,1).Type        = 'Connection: simmechanics.connections.geometry';
        elem{1}(e_i,1).Description = '';
    end
end

CBO.Elements = elem{1};

