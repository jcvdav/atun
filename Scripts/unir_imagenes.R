
library(ggplot2)
library(tidyr)
library(dplyr)
library(readr)

for (i in 2003:2014){
  
  img_data <- data.frame(Ano = NA, Mes = NA, Lat = NA, Lon = NA, Temp = NA)
  
  for (j in 1:12){
    
    img_path <- paste("./Datos/Oc/Imagenes/",i,"_",j,".csv", sep = "")
    
    img <- read_csv(img_path)
    cols <- colnames(img)
    colnames(img) <- c("Ano", "Mes", "Lat", cols[-c(1:3)])
    
   img <- gather(img, Lon, Temp, -c(1:3)) %>%
      mutate(Lat = round(Lat), Lon = round(as.numeric(Lon))) %>%
      group_by(Ano, Mes, Lat, Lon) %>%
      summarize(Temp = mean(Temp, na.rm = T)) %>%
      ungroup()

    img_data <- rbind(img_data, img)
    
    print(img_path)
    
  }
  
  save(img_data, file = paste("Datos/Oc/Temp_",i,".RData", sep =""))
}

# Leer los 14 RDatas anuales

load("Datos/Oc/Temp_2003.RData")
load("Datos/Oc/Temp_2004.RData")
load("Datos/Oc/Temp_2005.RData")
load("Datos/Oc/Temp_2006.RData")
load("Datos/Oc/Temp_2007.RData")
load("Datos/Oc/Temp_2008.RData")
load("Datos/Oc/Temp_2009.RData")
load("Datos/Oc/Temp_2010.RData")
load("Datos/Oc/Temp_2011.RData")
load("Datos/Oc/Temp_2012.RData")
load("Datos/Oc/Temp_2013.RData")
load("Datos/Oc/Temp_2014.RData")

#Concatenar los datos

img_data <- rbind(T2003,
                  T2004,
                  T2005,
                  T2006,
                  T2007,
                  T2008,
                  T2009,
                  T2010,
                  T2011,
                  T2012,
                  T2013,
                  T2014)

img_data <- mutate(img_data,
                   Lon = -1*abs(Lon),
                   ID = paste(Ano, Mes, Lon, Lat, sep = "-"))

save(img_data, file = paste("Datos/Oc/Temp.RData"))

write.csv(img_data, file = "Datos/Oc/Temp.csv")

