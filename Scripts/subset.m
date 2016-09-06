function img = subset(img_dir, xlim, ylim)

Lat = ncread(img_dir, 'lat');
Lon = ncread(img_dir, 'lon');
sst = ncread(img_dir, 'sst4')';

Lat = Lat(ylim(1):ylim(2));
Lon = Lon(xlim(1):xlim(1));
sst = sst(ylim(1):ylim(1), xlim(1):xlim(2));

img = array2table(sst)

end