# Figuras exploratoria

library(RColorBrewer)
library(hexbin)
library(corrplot)
library(maps)
library(stargazer)
library(tidyverse)


load(file = "./Datos/Atun/BD_TallasAtun_Oc.RData")

# Tabla de resumen
t1 <- group_by(datos, Ano, Tipo) %>%
  summarize(N = n()) %>%
  ungroup()

t2 <- spread(t1, Tipo, N)
t2[dim(t2)[1]+1,1] = "Total"
t2[dim(t2)[1],2:4] = colSums(t2[,2:4], na.rm = T)

kable(t2)

# Gráfica de muestras por año

p1 <- ggplot(t1, aes(x = Ano, y = N, fill = Tipo)) +
  geom_bar(stat = "identity", color = "black") +
  scale_fill_brewer(palette = "Set1") +
  theme_bw()

tiff("./Docs/Figs/Fig1.tiff", width=6, height=3, units="in", res=300)
p1
dev.off()

# Corrplot
datos2 <- filter(datos, !is.na(MEI)) %>%
  filter(!is.na(Temp)) %>%
  group_by(Ano, Mes, Latitud, Longitud, MEI, ONI, SOI, Temp) %>%
  summarize(Talla = mean(Talla, na.rm = T)) %>%
  ungroup() %>%
  select(-Mes)

tiff("./Docs/Figs/Fig2.tiff", width=6, height=3, units="in", res=300)
corrplot(cor(datos2), method="ellipse", type="lower")
dev.off()

# Promedio anual de tallas por tipo de lance

p3 <- group_by(datos, Ano, Tipo) %>%
  summarize(MTalla = mean(Talla, na.rm = T), SDTalla = sd(Talla, na.rm = T)) %>%
  ggplot(aes(x = Ano, y = MTalla, color = Tipo, factor = Tipo)) +
  geom_point() +
  geom_line() +
  geom_errorbar(aes(ymin = MTalla - SDTalla, ymax = MTalla + SDTalla), color = "black", width = 0.2) +
  scale_color_brewer(palette = "Set1") +
  theme_bw() + 
  scale_x_continuous(breaks = seq(2003,2014))

tiff("./Docs/Figs/Fig3.tiff", width=6, height=3, units="in", res=300)
p3
dev.off()

# Distribución espacial de tallas por año
coastline <- map("world", ylim=c(0,40), xlim=c(-150,-60), plot = F)
coastline <- data.frame(Lon = coastline$x,
                        Lat = coastline$y)

p4 <- group_by(datos, Ano, Longitud, Latitud) %>%
  summarize(Talla = mean(Talla)) %>%
  ggplot(aes(x = Longitud, y = Latitud, color = Talla)) +
  geom_point(size = 1) +
  geom_point(data = coastline, aes(x = Lon, y = Lat), color = "black", pch = ".") +
  facet_wrap(~Ano, ncol = 3) + 
  theme_bw() +
  scale_y_continuous(limits = c(0,40)) +
  scale_x_continuous(limits = c(-150, -80)) +
  coord_fixed()

tiff("./Docs/Figs/Fig4.tiff", width=8, height=12, units="in", res=300)
p4
dev.off()

# Distribución espacial de muestras por año

p5 <- group_by(datos, Ano, Longitud, Latitud) %>%
  summarize(N = n()) %>%
  ggplot(aes(x = Longitud, y = Latitud, color = N)) +
  geom_point(size = 1) +
  geom_point(data = coastline, aes(x = Lon, y = Lat), color = "black", pch = ".") +
  facet_wrap(~Ano, ncol = 3) + 
  theme_bw() +
  scale_y_continuous(limits = c(0,40)) +
  scale_x_continuous(limits = c(-150, -80)) +
  coord_fixed()

tiff("./Docs/Figs/Fig5.tiff", width=8, height=12, units="in", res=300)
p5
dev.off()


# Tallas vs Latitud

#########################################
# datos <- filter(datos, Tipo == "LANATUN")## Filtrado por tipo
#########################################

t6 <- group_by(datos, Ano, Latitud) %>%
  summarize(Talla = mean(Talla, na.rm = T)) %>%
  ungroup()

m6 <- lm(Talla~Latitud, t6)

p6 <- group_by(datos, Ano, Latitud) %>%
  summarize(Talla = mean(Talla, na.rm = T)) %>%
  ggplot(aes(x = Latitud, y = Talla, color = Ano)) + 
  geom_point() +
  theme_bw() +
  geom_abline(slope = coef(m6)[[2]], intercept = coef(m6)[[1]])


tiff("./Docs/Figs/Fig6.tiff", width=6, height=3, units="in", res=300)
p6
dev.off()

# Tallas vs. Longitud

t7 <- group_by(datos, Ano, Longitud) %>%
  summarize(Talla = mean(Talla, na.rm = T)) %>%
  ungroup()

m7 <- lm(Talla~Longitud, t7)
  
p7 <- group_by(datos, Ano, Longitud) %>%
  summarize(Talla = mean(Talla, na.rm = T)) %>%
  ggplot(aes(x = Longitud, y = Talla, color = Ano)) + 
  geom_point() +
  theme_bw() +
  geom_abline(slope = coef(m7)[[2]], intercept = coef(m7)[[1]])

tiff("./Docs/Figs/Fig7.tiff", width=6, height=3, units="in", res=300)
p7
dev.off()

# Talla vs. MEI

t8 <- group_by(datos, Ano, Mes) %>%
  summarize(MEI = mean(MEI, na.rm = T), Talla = mean(Talla, na.rm = T)) %>%
  ungroup()

m8 <- lm(Talla~MEI, t8)

p8 <- group_by(datos, Ano, Mes) %>%
  summarize(MEI = mean(MEI, na.rm = T), Talla = mean(Talla, na.rm = T)) %>%
  ggplot(aes(x = MEI, y = Talla, color = Ano)) + 
  geom_point() +
  theme_bw() +
  geom_abline(slope = coef(m8)[[2]], intercept = coef(m8)[[1]])

tiff("./Docs/Figs/Fig8.tiff", width=6, height=3, units="in", res=300)
p8
dev.off()

# Talla vs. ONI

t9 <- group_by(datos, Ano, Mes) %>%
  summarize(ONI = mean(ONI, na.rm = T), Talla = mean(Talla, na.rm = T)) %>%
  ungroup()

m9 <- lm(Talla~ONI, t9)

p9 <- group_by(datos, Ano, Mes) %>%
  summarize(ONI = mean(ONI, na.rm = T), Talla = mean(Talla, na.rm = T)) %>%
  ggplot(aes(x = ONI, y = Talla, color = Ano)) + 
  geom_point() +
  theme_bw() +
  geom_abline(slope = coef(m9)[[2]], intercept = coef(m9)[[1]])

tiff("./Docs/Figs/Fig9.tiff", width=6, height=3, units="in", res=300)
p9
dev.off()

# Talla vs. SOI

t10 <- group_by(datos, Ano, Mes) %>%
  summarize(SOI = mean(SOI, na.rm = T), Talla = mean(Talla, na.rm = T)) %>%
  ungroup()

m10 <- lm(Talla~SOI, t10)

 p10 <- group_by(datos, Ano, Mes) %>%
   summarize(SOI = mean(SOI, na.rm = T), Talla = mean(Talla, na.rm = T)) %>%
   ggplot(aes(x = SOI, y = Talla, color = Ano)) + 
   geom_point() +
   theme_bw() +
   geom_abline(slope = coef(m10)[[2]], intercept = coef(m10)[[1]])

tiff("./Docs/Figs/Fig10.tiff", width=6, height=3, units="in", res=300)
p10
dev.off()

# Tallas vs. Temp

t11 <- filter(datos, Temp < 40) %>%
  group_by(Ano, Mes, Latitud, Longitud) %>%
  summarize(Temp = mean(Temp, na.rm = T), Talla = mean(Talla, na.rm = T)) %>%
  ungroup()

m11 <- lm(Talla~Temp, t11)

p11 <- filter(datos, Temp < 40) %>%
  group_by(Ano, Mes, Latitud, Longitud) %>%
  summarize(Temp = mean(Temp, na.rm = T), Talla = mean(Talla, na.rm = T)) %>%
  ggplot(aes(x = Temp, y = Talla, color = Ano)) + 
  geom_point() +
  theme_bw() +
  geom_abline(slope = coef(m11)[[2]], intercept = coef(m11)[[1]])


tiff("./Docs/Figs/Fig11.tiff", width=6, height=3, units="in", res=300)
p11
dev.off()

# Tabla modelos

stargazer(m6, m7, m8, m9, m10, m11, type = "html", dep.var.labels = c("Talla (cm)"), covariate.labels = c("Latitud", "Longitud", "MEI", "ONI", "SOI", "Temperatura (°C)"), out = "./Docs/Figs/Tabla1.htm")

# Modelo multiple

t12 <- group_by(datos, Ano, Mes, Latitud, Longitud) %>%
  summarize(MEI = mean(MEI, na.rm = T),
            SOI = mean(SOI, na.rm = T),
            ONI = mean(ONI, na.rm = T),
            Temp = mean(Temp, na.rm = T),
            Talla = mean(Talla, na.rm = T)) %>%
  ungroup()

m12 <- lm(Talla ~ Latitud + Longitud + MEI + ONI + SOI + Temp, t12)

m13 <- lm(Talla ~ MEI*ONI, t12)

m14 <- lm(Talla ~ Latitud + Longitud + MEI * ONI * Temp, t12)

m15 <- lm(Talla ~ Latitud + Longitud + MEI * Temp, t12)



stargazer(m12, m13, m14, m15, type = "html", dep.var.labels = c("Talla (cm)"), out = "./Docs/Figs/Tabla2.htm", keep.stat = c("adj.rsq", "aic", "n", "f"), add.lines = list(c("AIC", "42421.88", "43121.27", "42425.50", "42429.26")), single.row = T)

# Hovmoller tallas

t13 <- group_by(datos, Ano, Mes) %>%
  summarize(Talla = mean(Talla, na.rm = T)) %>%
  spread(Ano, Talla) %>%
  as.matrix()

tiff("./Docs/Figs/Fig13.tiff", width=6, height=4, units="in", res=300)
filled.contour(x = t13[,1], y = seq(1:12)+2002, z = t13[,2:13], color.palette=heat.colors)
dev.off()

# Hovmoller tallas (sd)

t14 <- group_by(datos, Ano, Mes) %>%
  summarize(Talla = sd(Talla, na.rm = T)) %>%
  spread(Ano, Talla) %>%
  as.matrix()

tiff("./Docs/Figs/Fig14.tiff", width=6, height=4, units="in", res=300)
filled.contour(x = t14[,1], y = seq(1:12)+2002, z = t14[,2:13], color.palette=heat.colors)
dev.off()

# Barras Temp vs Talla

hist(datos$Temp, main = "")

# Densidad de puntos en el mapa

Colors=colorRampPalette(brewer.pal(9,"RdBu"))

hexbinplot(datos$Latitud ~ datos$Longitud, xlab = "Longitud", ylab = "Latitud", colramp = Colors)

# Descomponer Tallas

Talla <- group_by(datos, Ano, Mes) %>%
  summarize(Talla = mean(Talla, na.rm = T)) %>%
  ungroup() %>%
  complete(Ano, Mes, fill = list (Talla = NA)) %>%
  select(Talla) %>%
  ts(frequency = 12, start = c(2003, 1)) %>%
  na.spline() %>%
  decompose()

# Descomponer MEI

MEI <- read.csv("./Datos/Oc/MEI_mensual.csv", sep=";") %>%
  complete(Year, Month, fill = list(Mei = NA)) %>%
  select(Mei) %>%
  ts(frequency = 12, start = c(1950, 1)) %>%
  na.spline() %>%
  decompose()  

#Descomponer ONI

ONI <- read.csv("Datos/Oc/ONI_SOI.csv", sep = ";") %>%
  complete(Ano, Mes, fill = list(oni = NA, Dia = 15)) %>%
  select(oni) %>%
  ts(frequency = 12, start = c(1950, 1)) %>%
  decompose()

#Descomponer SOI

SOI <- read.csv("Datos/Oc/ONI_SOI.csv", sep = ";") %>%
  complete(Ano, Mes, fill = list(soi = NA, Dia = 15)) %>%
  select(soi) %>%
  ts(frequency = 12, start = c(1950, 1)) %>%
  decompose()




