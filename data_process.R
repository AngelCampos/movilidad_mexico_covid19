library(data.table)
library(magrittr)
library(stringr)
library(tidyr)

# Loading data
data <- fread(grep(pattern = "^applemobilitytrends*", list.files(), value = T, ),
              sep = ",", header = T)

# A Espa�ol y correcciones de nombres
mxDATA <- data[country == "Mexico" | region == "Mexico",]
mxDATA$geo_type <- gsub(pattern = "country/region", replacement = "Nacional", x = mxDATA$geo_type)
mxDATA$geo_type <- gsub(pattern = "city", replacement = "Ciudad", x = mxDATA$geo_type)
mxDATA$geo_type <- gsub(pattern = "sub-region", replacement = "Estado", x = mxDATA$geo_type)

mxDATA$region[str_detect(mxDATA$region, pattern = "^Mexico$")] <- "Nacional"
mxDATA$region[str_detect(mxDATA$region, pattern = "^Ju(.)+rez$")] <- "Ju�rez"
mxDATA$region[str_detect(mxDATA$region, pattern = "^Mexico City$")] <- "Cd. de M�xico"
mxDATA$region[str_detect(mxDATA$region, pattern = "^Le(.)+n$")] <- "Le�n"
mxDATA$region[str_detect(mxDATA$region, pattern = "^Nuevo Le(.)+n$")] <- "Nuevo Le�n"
mxDATA$region[str_detect(mxDATA$region, pattern = "^Puebla$")] <- "Cd. de Puebla"
mxDATA$region[str_detect(mxDATA$region, pattern = "^Puebla(.)+$")] <- "Estado de Puebla"
mxDATA$region[str_detect(mxDATA$region, pattern = "^State of Mex(.)+$")] <- "Estado de M�xico"
mxDATA$region[str_detect(mxDATA$region, pattern = "^Michoa(.)+$")] <- "Michoac�n"
mxDATA$region[str_detect(mxDATA$region, pattern = "^Quer(.)+taro$")] <- "Quer�taro"
mxDATA$region[str_detect(mxDATA$region, pattern = "^San Luis Poto(.)+$")] <- "San Luis Potos�"
mxDATA$region[str_detect(mxDATA$region, pattern = "^Yucat(.)+$")] <- "Yucat�n"

mxDATA$transportation_type[str_detect(mxDATA$transportation_type, pattern = "^driving$")] <- "Automovil"
mxDATA$transportation_type[str_detect(mxDATA$transportation_type, pattern = "^walking$")] <- "Peatones"
mxDATA$transportation_type[str_detect(mxDATA$transportation_type, pattern = "^transit$")] <- "P�blico"
mxDATA <- mxDATA[,c(-4:-6)]

# Long data format
longDATA <- pivot_longer(mxDATA, names_to = "day", -c("region", "transportation_type", "geo_type"), values_to = "Movilidad") %>% data.table()
longDATA$day <- longDATA$day %>% as.Date()
longDATA$Movilidad <- longDATA$Movilidad-100
longDATA$region <- longDATA$region %>% as.factor %>% relevel(ref = "Nacional")

saveRDS(longDATA, "mexData.rds")
