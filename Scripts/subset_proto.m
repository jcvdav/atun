dir =('C:\Users\JC\Documents\GitHub\atun\Scripts\OceanTemperature\modis\L3\Aqua\4um\v2014.0\4km\monthly\2012\A20120012012031.L3m_MO_SST4_sst4_4km.nc');

Lat = ncread(dir, 'lat');
Lon = ncread(dir, 'lon');
sst = ncread(dir, 'sst4')';

xlim1 = 720;
xlim2 = 2520;

ylim1 = 1200;
ylim2 = 2160;

Lat = Lat(ylim1:ylim2);
Lon = Lon(xlim1:xlim2);
sst = sst(ylim1:ylim2, xlim1:xlim2);


image(Lon, Lat, sst), axis xy, caxis([0,30])

pcolor(sst), shading interp, axis ij, caxis([0,30])