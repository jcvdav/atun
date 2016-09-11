library(ggplot2)
library(dplyr)
library(tidyr)

## Cargar datos MEI
MEI <- read.csv("./Datos/Oc/MEI_mensual.csv", sep=";") %>%
  mutate(AnoMes = paste(Year, Month, sep="-")) %>%
  select(Mei, AnoMes)

colnames(MEI) <- c("MEI", "AnoMes")

## Cargar datos ONI

ONI_SOI <- read.csv("Datos/Oc/ONI_SOI.csv", sep = ";") %>%
  #mutate(Fecha = as.Date(datenum, origin = "1970-01-01") - 719529) #Esto era cuando cargaba los recién exportados de MatLab... ahora los cargo ya manipulados en R y Excel
  mutate(AnoMes = paste(Ano, Mes, sep = "-")) %>%
  select(AnoMes, ONI = oni, SOI = soi)

## Cargar datos Temp

Temp <- read.csv("Datos/Oc/Temp.csv")

## Cargar datos Atún

T2003 <- read.csv("./Datos/Atun/TALLAS2003.csv", sep=";")
T2004 <- read.csv("./Datos/Atun/TALLAS2004.csv", sep=";")
T2005 <- read.csv("./Datos/Atun/TALLAS2005.csv", sep=";") %>%
  select(-No.LANCE) %>%
  select(-X)
T2006 <- read.csv("./Datos/Atun/TALLAS2006.csv", sep=";")
T2007 <- read.csv("./Datos/Atun/TALLAS2007.csv", sep=";")
T2008 <- read.csv("./Datos/Atun/TALLAS2008.csv", sep=";") %>%
  select(-N.LANCE)
T2009 <- read.csv("./Datos/Atun/TALLAS2009.csv", sep=";")
T2010 <- read.csv("./Datos/Atun/TALLAS2010.csv", sep=";")
T2011 <- read.csv("./Datos/Atun/TALLAS2011.csv", sep=";")
T2012 <- read.csv("./Datos/Atun/TALLAS2012.csv", sep=";")
T2013a14 <- read.csv("./Datos/Atun/TALLAS2013-2014.csv", sep=";") %>%
  select(FECHA, LATITUD, LONGITUD, TIPO, TALLA)

columnas <- c("Fecha", "Latitud", "Longitud", "Tipo", "Talla")

colnames(T2003) <- columnas
colnames(T2004) <- columnas
colnames(T2005) <- columnas
colnames(T2006) <- columnas
colnames(T2007) <- columnas
colnames(T2008) <- columnas
colnames(T2009) <- columnas
colnames(T2010) <- columnas
colnames(T2011) <- columnas
colnames(T2012) <- columnas
colnames(T2013a14) <- columnas

T2013a14$Latitud=round(T2013a14$Latitud)
T2013a14$Longitud=round(T2013a14$Longitud)

T_todos <- rbind(T2003, T2004, T2005, T2006, T2007, T2008, T2009, T2010, T2011, T2012, T2013a14)

T_todos$Talla  <- as.character(T_todos$Talla)
T_todos$Talla <- as.numeric(T_todos$Talla)
T_todos$Longitud <- as.numeric(T_todos$Longitud)
T_todos$Longitud <- -1*abs(T_todos$Longitud)

T_todos$Tipo <- as.character(T_todos$Tipo)
T_todos$Tipo[T_todos$Tipo=="PALO"] <- "LANPALO"

T_todos$Fecha <- as.Date(T_todos$Fecha, format = "%d/%m/%Y")
T_todos$Dia <- as.numeric(format(T_todos$Fecha, format = "%d"))
T_todos$Mes <- as.numeric(format(T_todos$Fecha, format = "%m"))
T_todos$Ano <- as.numeric(format(T_todos$Fecha, format = "%Y"))

T_todos <- T_todos %>%
  filter(Longitud < 180) %>%
  filter(Longitud > -180) %>%
  filter(Latitud < 50) %>%
  filter(Talla < 300) %>%
  filter(Ano > 2000) %>%
  filter(Talla < 500) %>%
  mutate(AnoMes = paste(Ano, Mes, sep="-"),
         ID = paste(Ano, Mes, Longitud, Latitud, sep = "-")) %>%
  select(ID, AnoMes, Dia, Mes, Ano, Fecha, Tipo, Latitud, Longitud, Talla) %>%
  left_join(MEI, by = "AnoMes") %>%
  left_join(ONI_SOI, by = "AnoMes") #%>%
  left_join(Temp, by = ID)

datos <- T_todos

write.csv(datos, file = "./Datos/Atun/BD_TallasAtun_Oc.csv", row.names = F)
#writeMat("./Datos/Atun/BD_TallasAtun_Oc.csv", datos = datos)
save(datos, file = "./Datos/Atun/BD_TallasAtun_Oc.RData")
