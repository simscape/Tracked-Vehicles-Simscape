
figure(99)
patch(Excv.Shoe.xc(:,1),Excv.Shoe.xc(:,2),[1 1 1]*0.95,'EdgeColor','none');
hold on
plot(Excv.Shoe.xc(:,1),Excv.Shoe.xc(:,2),'-','Marker','o','MarkerSize',4,'LineWidth',2);
axis('equal');
hold off
box on
title('Track Shoe Profile from MATLAB Function')
axis tight
axis padded

Extr_Data_LinkHoles(Excv.Chain.hole_sep,Excv.Chain.plate_h,Excv.Chain.hole_rad,2,'plot');
title('Chain Plate Profile from MATLAB Function')
axis tight
axis padded

Extr_Data_Sprocket(Excv.Sprocket.nTeeth,Excv.Sprocket.skipTeeth,Excv.Chain.pin_sep,Excv.Chain.pin_rad,'plot')
title('Sprocket Profile from MATLAB Function')
axis tight
axis padded

Grid_Surface_Data_Slope(25, 9, 7.5, 1.5, 5, 0.5, 'plot')
title('Test Terrain Defined Using MATLAB Function')

xy_terrain = stl_to_gridsurface('hills_terrain.stl',100,100,'n');
[X,Y] = meshgrid(xy_terrain.xg, xy_terrain.yg);
s_h = surf(X',Y',xy_terrain.z_heights,'EdgeColor','none');
axis equal
axis tight
box on
title('Uneven Terrain Imported into MATLAB')

