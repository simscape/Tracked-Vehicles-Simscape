% Publish all test scripts
% Copyright 2022-2026 The MathWorks, Inc.

publishStart = tic;
warning('off','Simulink:Engine:MdlFileShadowedByFile');
warning('off','Simulink:Harness:WarnABoutNameShadowingOnActivation');
%bdclose all % DO NOT CLOSE  -track lib

curr_proj = simulinkproject;
homedir   = curr_proj.RootFolder;

%% Publish documentation for Simulink examples: Chain Tracks
publishFolderList = {...
    ['Models'   filesep 'Excavator_Tracks'    filesep 'Overview'],...
    }; 

for pf_i = 1:length(publishFolderList)
    cd([homedir filesep publishFolderList{pf_i}])
    filelist_m=dir('*.m');
    filenames_m = {filelist_m.name};
    for i=1:length(filenames_m)
        if ~(strcmp(filenames_m{i},'publish_all_html.m'))
            publish(filenames_m{i},'showCode',false)
        end
    end
end

%% Publish documentation for Simulink examples: Belt Tracks
publishFolderList = {...
    ['Models'   filesep 'Tractor_Tracks'    filesep 'Overview'],...
    }; 

for pf_i = 1:length(publishFolderList)
    cd([homedir filesep publishFolderList{pf_i}])
    filelist_m=dir('*.m');
    filenames_m = {filelist_m.name};
    for i=1:length(filenames_m)
        if ~(strcmp(filenames_m{i},'publish_all_html.m'))
            %if ~(contains(filenames_m{i},'belt4'))
                publish(filenames_m{i},'showCode',false)
            %else
            %    disp(['SKIPPING ' filenames_m{i}]);
            %end
        end
    end
end

%% Publish documentation for Simulink libraries: Chain Tracks
publishFolderList = {...
    ['Libraries' filesep 'Chain' filesep 'TestModels' filesep 'Overview'],...
    }; 

for pf_i = 1:length(publishFolderList)
    cd([homedir filesep publishFolderList{pf_i}])
    filelist_m=dir('*.m');
    filenames_m = {filelist_m.name};
    for i=1:length(filenames_m)
        if ~(strcmp(filenames_m{i},'publish_all_html.m'))
            publish(filenames_m{i},'showCode',false)
        end
    end
end

%% Publish documentation for Simulink libraries: Test Belt Tracks
publishFolderList = {...
    ['Libraries' filesep 'Belt' filesep 'TestModels' filesep 'Overview'],...
    }; 

for pf_i = 1:length(publishFolderList)
    cd([homedir filesep publishFolderList{pf_i}])
    filelist_m=dir('*.m');
    filenames_m = {filelist_m.name};
    for i=1:length(filenames_m)
        if ~(strcmp(filenames_m{i},'publish_all_html.m'))
            publish(filenames_m{i},'showCode',false)
        end
    end
end
%% Publish workflow documentation
publishFolderList_wkf = {...
    ['Workflows' filesep 'PointCloudfromCAD' filesep 'Overview'],...
    ['Workflows' filesep 'GenerateNew' filesep 'Track' filesep 'Overview']
    };

for pf_i = 1:length(publishFolderList_wkf)
    cd([homedir filesep publishFolderList_wkf{pf_i}])
    filelist_m=dir('*.m');
    filenames_m = {filelist_m.name};
    for i=1:length(filenames_m)
        if ~(strcmp(filenames_m{i},'publish_all_html.m'))
            publish(filenames_m{i},'showCode',true)
        end
    end
end

%% Publish workflow documentation, generate joint targets
publishFolderList_jtgt = {...
    ['Workflows' filesep 'TrackJointTargets']
    };
FileList_jtgt = {...
    'get_jntTgts_Track_seg46i1u2l7.m','get_jntTgts_Track_seg46i2u0l4.m','get_jntTgts_TrackV_seg45i2u0l3.m'};

cd([homedir filesep publishFolderList_jtgt{1}])
for ft_i=1:length(FileList_jtgt)
    publish(FileList_jtgt{ft_i},'showCode',true)
end

%% Publish library documentation
publishFolderList = {...
    ['Libraries' filesep 'Doc'],...
    }; 

for pf_i = 1:length(publishFolderList)
    cd([homedir filesep publishFolderList{pf_i}])
    filelist_m=dir('*.m');
    filenames_m = {filelist_m.name};
    for i=1:length(filenames_m)
        if ~(strcmp(filenames_m{i},'publish_all_html.m'))
            publish(filenames_m{i},'showCode',false)
        end
    end
end


%%
publishDuration = toc(publishStart)