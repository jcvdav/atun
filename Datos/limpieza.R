library(ggplot2)
library(ggmap)
library(dplyr)
library(tidyr)

T2003 <- read.csv("TALLAS2003.csv", sep=";")
T2004 <- read.csv("TALLAS2004.csv", sep=";")
T2005 <- read.csv("TALLAS2005.csv", sep=";") %>%
  select(-No.LANCE) %>%
  select(-X)
T2006 <- read.csv("TALLAS2006.csv", sep=";")
T2007 <- read.csv("TALLAS2007.csv", sep=";")
T2008 <- read.csv("TALLAS2008.csv", sep=";") %>%
  select(-N.LANCE)
T2009 <- read.csv("TALLAS2009.csv", sep=";")
T2010 <- read.csv("TALLAS2010.csv", sep=";")
T2011 <- read.csv("TALLAS2011.csv", sep=";")
T2012 <- read.csv("TALLAS2012.csv", sep=";")

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

T2013a14 <- read.csv("TALLAS2013-2014.csv", sep=";") %>%
  select(FECHA, LATITUD, LONGITUD, TIPO, TALLA)

colnames(T2013a14) <- columnas
T2013a14$Latitud=round(T2013a14$Latitud)
T2013a14$Longitud=round(T2013a14$Longitud)

T_todos <- rbind(T2003, T2004, T2005, T2006, T2007, T2008, T2009, T2010, T2011, T2012, T2013a14)

T_todos$Talla <- as.numeric(T_todos$Talla)
T_todos$Longitud <- as.numeric(T_todos$Longitud)
T_todos$Longitud <- -1*abs(T_todos$Longitud)
T_todos$Tipo[T_todos$Tipo=="PALO"] <- "LANPALO"

T_todos <- T_todos %>%
  filter(Longitud < 180 & Longitud > -180) %>%
  filter(Latitud < 50) %>%
  filter(Talla < 300)

map <- get_map(location=c(lon=-115, lat=20), zoom=3)

windows()
ggmap(map)+
  ggplot()+
  geom_point(data=T_todos, aes(x = Longitud, y = Latitud, color=Talla, pch=Tipo))

T_todos$Fecha <- as.Date(T_todos$Fecha, format = "%d/%m/%Y")
T_todos$Dia <- as.numeric(format(T_todos$Fecha, format = "%d"))
T_todos$Mes <- as.numeric(format(T_todos$Fecha, format = "%m"))
T_todos$Ano <- as.numeric(format(T_todos$Fecha, format = "%Y"))

T_todos <- T_todos %>%
  mutate(AnoMes = paste(Ano, Mes, sep="-")) %>%
  select(Dia, Mes, Ano, AnoMes, Fecha, Tipo, Latitud, Longitud, Talla)

MEI <- read.csv("../MEI_mensual.csv", sep=";") %>%
  mutate(AnoMes = paste(Year, Month, sep="-")) %>%
  select(Mei, AnoMes)
  
colnames(MEI) <- c("MEI", "AnoMes")

T_todos <- left_join(T_todos, MEI, by="AnoMes") # %>%
  #left_join(ONI) %>%
  #left_join(SOI) falta cargar y jointear esto

ggplot(data=T_todos, aes(x=MEI, y=Talla, color=Tipo))+
  geom_point()+
  stat_smooth(method = "ls")

p2 <- ggplot(data=T_todos, aes(x=Latitud, y=Talla, color=Tipo))+
  geom_point()



