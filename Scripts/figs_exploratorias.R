# Figuras exploratoria

library(ggplot2)
library(tidyr)
library(dplyr)
library(RColorBrewer)
library(hexbin)
library(corrplot)
library(maps)


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
  filter(!is.na(Temp))
p2 <- corrplot(cor(datos2[,8:14]), method="ellipse", type="lower")

tiff("./Docs/Figs/Fig2.tiff", width=6, height=3, units="in", res=300)
p2
dev.off()

# Promedio anual de tallas por tipo de lance
p3 <- ggplot(datos, aes(x = Ano, y = Talla, color = Tipo, factor = Tipo)) +
  stat_summary(fun.y = mean, geom = "point") +
  stat_summary(fun.y = mean, geom = "line") +
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", fun.args = list(mult = 1), width = 0.2, color = "black") +
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

# Algo

Colors <- colorRampPalette(brewer.pal(9,"RdBu"))

tiff("./Docs/Figs/Fig6.tiff", width=6, height=3, units="in", res=300)
p6
dev.off()

# Algo

tiff("./Docs/Figs/Fig7.tiff", width=6, height=3, units="in", res=300)
p7
dev.off()

# Algo

tiff("./Docs/Figs/Fig8.tiff", width=6, height=3, units="in", res=300)
p8
dev.off()

# Algo

tiff("./Docs/Figs/Fig9.tiff", width=6, height=3, units="in", res=300)
p9
dev.off()

# Algo


tiff("./Docs/Figs/Fig10.tiff", width=6, height=3, units="in", res=300)
p10
dev.off()


tiff("./Docs/Figs/Fig11.tiff", width=6, height=3, units="in", res=300)
p10
dev.off()
