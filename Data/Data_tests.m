% Data comes from the following url.
% http://chlthredds.erdc.dren.mil/thredds/catalog/frf/projects/bathyduck/data/catalog.html

%% Boundary Condition Data %% 
bc.time=ncread('http://chlthredds.erdc.dren.mil/thredds/dodsC/frf/projects/bathyduck/data/FRF-ocean_waves_awac04_201510.nc?waveHs[0:1:644],time[0:1:644],depth[0:1:0],lat,lon','time');
bc.waveHs=ncread('http://chlthredds.erdc.dren.mil/thredds/dodsC/frf/projects/bathyduck/data/FRF-ocean_waves_awac04_201510.nc?waveHs[0:1:644],time[0:1:644],depth[0:1:0],lat,lon','waveHs');
bc.depth=ncread('http://chlthredds.erdc.dren.mil/thredds/dodsC/frf/projects/bathyduck/data/FRF-ocean_waves_awac04_201510.nc?waveHs[0:1:644],time[0:1:644],depth[0:1:0],lat,lon','depth');
bc.lat=ncread('http://chlthredds.erdc.dren.mil/thredds/dodsC/frf/projects/bathyduck/data/FRF-ocean_waves_awac04_201510.nc?waveHs[0:1:644],time[0:1:644],depth[0:1:0],lat,lon','lat');
bc.lon=ncread('http://chlthredds.erdc.dren.mil/thredds/dodsC/frf/projects/bathyduck/data/FRF-ocean_waves_awac04_201510.nc?waveHs[0:1:644],time[0:1:644],depth[0:1:0],lat,lon','lon');

%% Bathy Data %%
point_input = [04,11,12,13,14,22,23,24,83]';
max_ind_input = [6931,5497,5493,3047,3908,5452,5450,4014,5165];

bathydata = struct;

for i = 1:length(point_input)
    filename = sprintf('http://chlthredds.erdc.dren.mil/thredds/dodsC/frf/projects/bathyduck/data/BathyDuck-ocean_bathy_p%02d_201510.nc?time[0:1:%d],xloc,yloc,seafloorLocation[0:1:%d]',point_input(i),max_ind_input(i),max_ind_input(i));
    fieldname = sprintf('p%02d',point_input(i));
    
    time = ncread(filename,'time');
    xloc = ncread(filename, 'xloc');
    yloc = ncread(filename, 'yloc');
    seafloorLocation = ncread(filename, 'seafloorLocation');
    
    value = {time, xloc, yloc, seafloorLocation};
    
    bathydata(:).(fieldname) = deal(value);
end 

%% Bathy Spatial Check %%
point_input = [04,11,12,13,14,22,23,24,83]';


%% Wave Data %%
point_input = [11,12,13,14,21,22,23,24,83,84];
max_ind_input = [474,451,474,474,450,450,473,451,426,357];

wavedata = struct; 

for i = 1:length(point_input)
   filename = sprintf('http://chlthredds.erdc.dren.mil/thredds/dodsC/frf/projects/bathyduck/data/BathyDuck-ocean_waves_p%02d_201510.nc?time[0:1:%d],zloc[0:1:%d],waveHs[0:1:%d],waveHsArray[0:1:%d][0:1:5],xloc[0:1:%d],yloc[0:1:%d]',point_input(i),max_ind_input(i),max_ind_input(i),max_ind_input(i),max_ind_input(i),max_ind_input(i),max_ind_input(i));
   fieldname = sprintf('p%02d',point_input(i));
   
   time = ncread(filename,'time');
   zloc = ncread(filename,'zloc');
   waveHs = ncread(filename, 'waveHs');
   waveHsArray = ncread(filename, 'waveHsArray');
   xloc = ncread(filename, 'xloc');
   yloc = ncread(filename, 'yloc');
   
   value = {time, zloc, waveHs, waveHsArray, xloc, yloc};
   
   wavedata(:).(fieldname) = deal(value);
end
