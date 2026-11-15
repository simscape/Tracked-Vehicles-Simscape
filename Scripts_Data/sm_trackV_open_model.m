function sm_trackV_open_model(mdl,vntblk,vnt,blk)

open_system(mdl);

if(~isempty(vntblk))
       switch vnt
           case 'ChainPts', vntName = 'Chain, Points';
           case 'RollerPts', vntName = 'Rollers, Points';
           case 'ChainPtsCAD', vntName = 'Chain, Points, CAD';
           case 'ChainPtsPlanar', vntName = 'Chain, Points, Planar';
           case 'BeltPts', vntName = 'Belt, Points';
       end

    for j = 1:length(vntblk)
        set_param(strrep([mdl '/' vntblk{j}],'%20',' '),'popup_trackModel',vntName);
    end
end

if(~isempty(blk))
    open_system(strrep([mdl '/' blk],'%20',' '),'force');
end

