tic
F1 = ftp('neoftp.sci.gsfc.nasa.gov'); %crear el ftp
data_save = pwd(); %Directorio donde se guarda

file = ['/geotiff.float/MWOI_SST_M/*.FLOAT.TIFF'];
mget(F1,file,data_save); % Se descarga el archivo con mget
close(F1) %cierra el ftp
toc

% ftp://neoftp.sci.gsfc.nasa.gov/geotiff.float/MWOI_SST_M/