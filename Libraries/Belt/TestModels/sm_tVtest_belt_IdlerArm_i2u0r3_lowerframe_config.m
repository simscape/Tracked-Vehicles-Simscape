function sm_tVtest_belt_IdlerArm_i2u0r3_lowerframe_config(mdl,testOption)


switch lower(testOption)
    case 'hang'
        set_param([mdl '/Contact Belt Roller/CF Roller Idler Fix'],'Commented','on');
        set_param([mdl '/Contact Belt Roller/CF Roller Idler Arm'],'Commented','on');
        set_param([mdl '/Contact Belt Roller/CF Roller Roller L1'],'Commented','on');
        set_param([mdl '/Contact Belt Roller/CF Roller Roller L2'],'Commented','on');
        set_param([mdl '/Contact Belt Roller/CF Roller Roller L3'],'Commented','on');
        set_param([mdl '/Planar Joint'],'Commented','through');
        set_param([mdl '/Scene'],'Commented','on');
    case 'float'
        set_param([mdl '/Contact Belt Roller/CF Roller Idler Fix'],'Commented','off');
        set_param([mdl '/Contact Belt Roller/CF Roller Idler Arm'],'Commented','off');
        set_param([mdl '/Contact Belt Roller/CF Roller Roller L1'],'Commented','off');
        set_param([mdl '/Contact Belt Roller/CF Roller Roller L2'],'Commented','off');
        set_param([mdl '/Contact Belt Roller/CF Roller Roller L3'],'Commented','off');
        set_param([mdl '/Planar Joint'],'Commented','through');
        set_param([mdl '/Scene'],'Commented','on');
    case 'drive'
        set_param([mdl '/Contact Belt Roller/CF Roller Idler Fix'],'Commented','off');
        set_param([mdl '/Contact Belt Roller/CF Roller Idler Arm'],'Commented','off');
        set_param([mdl '/Contact Belt Roller/CF Roller Roller L1'],'Commented','off');
        set_param([mdl '/Contact Belt Roller/CF Roller Roller L2'],'Commented','off');
        set_param([mdl '/Contact Belt Roller/CF Roller Roller L3'],'Commented','off');
        set_param([mdl '/Planar Joint'],'Commented','off');
        set_param([mdl '/Scene'],'Commented','off');
    otherwise
        disp(['Configuration ' testOption ' not recognized.'])

end