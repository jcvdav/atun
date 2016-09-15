# Figuras exploratoria

library(ggplot2)
library(tidyr)
library(dplyr)

load(file = "./Datos/Atun/BD_TallasAtun_Oc.RData")

ggplot(datos, aes(x = Ano, y = Talla, color = Tipo, factor = Tipo)) +
  stat_summary(fun.y = mean, geom = "point") +
  stat_summary(fun.y = mean, geom = "line") +
  # stat_summary(fun.y = mean_se, geom = "errorbar") +
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", fun.args = list(mult = 1), width = 0.2, color = "black") +
  scale_color_brewer(palette = "Set1") +
  theme_bw()

