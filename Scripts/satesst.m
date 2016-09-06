function f = satesst(year)

F1 = ftp('podaac-ftp.jpl.nasa.gov'); %crear el ftp
data_save = pwd(); %Directorio donde se guarda

file = ['/OceanTemperature/modis/L3/aqua/4um/v2014.0/4km/monthly/',num2str(year),'/*.nc'];
mget(F1,file,data_save); % Se descarga el archivo con mget
close(F1) %cierra el ftp

end

% ftp://podaac-ftp.jpl.nasa.gov/OceanTemperature/modis/L3/aqua/4um/v2014.0/4km/monthly/2003/


