function img = subset(img_dir, xlim, ylim)

Lat = ncread(img_dir, 'lat');
Lon = ncread(img_dir, 'lon');
sst = ncread(img_dir, 'sst4')';

Lat = Lat(ylim(1):ylim(2));
Lon = Lon(xlim(1):xlim(2));
sst = sst(ylim(1):ylim(2), xlim(1):xlim(2));

img = zeros(962, 1802);
img(1,1) = NaN;
img(2:end,1) = Lat;
img(1, 2:end) = Lon;
img(2:end,2:end) = sst;

end