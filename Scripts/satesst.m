function f = satesst(year)
F1 = ftp('podaac-ftp.jpl.nasa.gov'); %crear el ftp
data_save = pwd(); %Directorio donde se guarda

for i =1:12
    month=i;
    %En la concatenación de abajo incluir mes
    file = ['/OceanTemperature/modis/L3/aqua/4um/v2014.0/4km/monthly/',num2str(year),'/','A',num2str(year),'001',num2str(year),'031.L3m_MO_SST4_sst4_4km.nc'];
    mget(F1,file,data_save); % Se descarga el archivo con mget
    close(F1) %cierra el ftp
end
end

% ftp://podaac-ftp.jpl.nasa.gov/OceanTemperature/modis/L3/aqua/4um/v2014.0/4km/monthly/2003/


