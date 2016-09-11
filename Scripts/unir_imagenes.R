
library(ggplot2)
library(tidyr)
library(dplyr)

img_data <- data.frame(Ano = NA, Mes = NA, Lat = NA, Lon = NA, Temp = NA)

for (i in 2003:2014){
  for (j in 1:12){
    
    img_path <- paste("./Datos/Oc/Imagenes/",i,"_",j,".csv", sep = "")
    
    img <- read.csv(img_path) %>%
      gather(Lon, Temp, -c(1:3))
    img$Lon <- as.numeric(gsub('X.', '', img$Lon))
    colnames(img) <- c("Ano", "Mes", "Lat", "Lon", "Temp")
    
    img_data <- rbind(img_data, img)
    
    print(img_path)
    
  }
}

img_data <- mutate(img_data,
                   Lon = -1*abs(data$Lon),
                   ID = paste(Ano, Mes, Lon, Lat, sep = "-"))

write.csv(img_data, file = "Datos/Oc/Temp.csv")

