function sm_tVtest_belt_IdlerArm_i2u0r3_lowerframe_config(mdl,testOption)


switch lower(testOption)
    case 'hang'
        set_param([mdl '/Contact Belt Roller/Planar Contact IdlerFix'],'Commented','on');
        set_param([mdl '/Contact Belt Roller/Planar Contact IdlerArm'],'Commented','on');
        set_param([mdl '/Contact Belt Roller/Planar Contact Roller'],'Commented','on');
        set_param([mdl '/Planar Joint'],'Commented','through');
        set_param([mdl '/Scene'],'Commented','on');
    case 'float'
        set_param([mdl '/Contact Belt Roller/Planar Contact IdlerFix'],'Commented','off');
        set_param([mdl '/Contact Belt Roller/Planar Contact IdlerArm'],'Commented','off');
        set_param([mdl '/Contact Belt Roller/Planar Contact Roller'],'Commented','off');
        set_param([mdl '/Planar Joint'],'Commented','through');
        set_param([mdl '/Scene'],'Commented','on');
    case 'drive'
        set_param([mdl '/Contact Belt Roller/Planar Contact IdlerFix'],'Commented','off');
        set_param([mdl '/Contact Belt Roller/Planar Contact IdlerArm'],'Commented','off');
        set_param([mdl '/Contact Belt Roller/Planar Contact Roller'],'Commented','off');
        set_param([mdl '/Planar Joint'],'Commented','off');
        set_param([mdl '/Scene'],'Commented','off');
    otherwise
        disp(['Configuration ' testOption ' not recognized.'])

end