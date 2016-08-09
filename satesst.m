function f = satesst(year)


F1 = ftp('podaac-ftp.jpl.nasa.gov');
data_save = '~';
filen= 
['/OceanTemperature/modis/L3/Aqua/4um/v2014.0/4km/monthly',num2str(year),'/'A,num2str(year),''0012011031.L3m_MO_SST4_sst4_4km.nc']
