library(tidyverse)
library(sf)
library(sp)

Korea <- read_sf("~/Downloads/SIG_20220324/sig.shp") #path should be modified
Korea$SIG_KOR_NM <- iconv(Korea$SIG_KOR_NM, from = "CP949", to = "UTF-8", sub = NA, mark = TRUE, toRaw = FALSE)

location <- read.csv("~/git/ThemisKorea/location/location_v6.csv") #path should be modified (e.g. location table from CDM)
location_df <- data.frame(location_id = location$LOCATION_ID, lat = as.double(location$LATITUDE), lon = as.double(location$LONGITUDE))
sp::coordinates(location_df) <- ~ lon + lat
Korea_shp <- sf::as_Spatial(Korea)
Korea_shp <- spTransform(Korea_shp, "+proj=longlat +datum=WGS84")
proj4string(location_df) <- proj4string(Korea_shp)

location_mapped_df <- over(location_df, Korea_shp)
location_mapped_df$location_id <- c(1:nrow(location_mapped_df))