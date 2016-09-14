
library(ggplot2)
library(tidyr)
library(dplyr)
library(readr)

for (i in 2010:2014){
  
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

#Concatenar los datos

img_data <- mutate(img_data,
                   Lon = -1*abs(data$Lon),
                   ID = paste(Ano, Mes, Lon, Lat, sep = "-"))

save(img_data, file = paste("Datos/Oc/Temp.RData"))

write.csv(img_data, file = "Datos/Oc/Temp.csv")

