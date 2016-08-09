function f = satesst(year)


F1 = ftp('podaac-ftp.jpl.nasa.gov'); %crear el ftp
data_save = '~'; %Directorio donde se guarda
file = ['/OceanTemperature/modis/L3/Aqua/4um/v2014.0/4km/monthly',num2str(year),'/A',num2str(year),'0012011031.L3m_MO_SST4_sst4_4km.nc'] %archivo que buscamos

mget(f1,filee,data_save); % Se descarga el archivo con mget
close(f1) %cierra el ftm

%  ftp://podaac-ftp.jpl.nasa.gov/OceanTemperature/modis/L3/aqua/4um/v2014.0/4km/monthly/2003/