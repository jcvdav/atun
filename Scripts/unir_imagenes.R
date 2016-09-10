
library(ggplot2)
library(tidyr)
library(dplyr)

for (i in 2003:2014){
  for (j in 1:12){
    
    img_path <- paste("../Datos/Oc/",i,j,".csv", sep = "")
    
    img <- read.csv(img_path) %>%
      gather(Lon, Temp, -c(1:3))
    img$Lon <- -1*as.numeric(gsub('X.', '', Test$Lon))
    colnames(img) <- c("Ano", "Mes", "Lat", "Lon", "Temp")
    
    data <- rbind(data, img)
    
  }
}
