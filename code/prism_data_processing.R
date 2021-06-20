rm(list = ls())

# Create County Polygon averages

library(prism)
library(rgdal)
library(lubridate)
library(exactextractr)
library(tidyverse)
library(terra)

# County Polygons ----
USmap_county <- readOGR(dsn = 'assets/3109_county',
                        layer = 'USmap_county')
fips <- as.numeric(USmap_county@data$ANSI_ST_CO)
fips <- as.character(fips)

# Precipitation ----
df_ppt <- data.frame()
prism_set_dl_dir(path = 'output/raw/prism/ppt/')
for(i in seq(from = 6, 
             to = length(prism_archive_ls()),
             by = 6)) {
  upper <- i
  lower <- i - 5
  
  cat('Iteration: ', i/6, 'out of 366.')
  
  raster_stack <- pd_stack(prism_archive_ls()[lower:upper])
  
  daily_means <- exact_extract(raster_stack,
                               USmap_county,
                               fun = 'mean')
  
  daily_means <- cbind.data.frame(fips, daily_means)
  
  for(name in 2:length(daily_means)) {
    
    names(daily_means)[name] <- substr(names(daily_means)[name], 29, 36)
    
  }
  
  daily_means <- gather(daily_means, 
                        date, 
                        ppt, 
                        2:length(daily_means))
  
  daily_means$date <- as.Date(daily_means$date, 
                              format = "%Y%m%d")
  df_ppt <- rbind(df_ppt, daily_means)
  
}
saveRDS(df_ppt, file = 'output/processed/df_ppt.rds')

# Minimum Temperature ----
rm(list = "daily_means")
df_tmin <- data.frame()
prism_set_dl_dir(path = 'output/raw/prism/tmin/')
for(i in seq(from = 6, 
             to = length(prism_archive_ls()),
             by = 6)) {
  upper <- i
  lower <- i - 5
  
  cat('Iteration: ', i/6, 'out of 366.')
  
  raster_stack <- pd_stack(prism_archive_ls()[lower:upper])
  
  daily_means <- exact_extract(raster_stack,
                               USmap_county,
                               fun = 'mean')
  
  daily_means <- cbind.data.frame(fips, daily_means)
  
  for(name in 2:length(daily_means)) {
    
    names(daily_means)[name] <- substr(names(daily_means)[name], 30, 37)
    
  }
  
  daily_means <- gather(daily_means, 
                        date, 
                        tmin, 
                        2:length(daily_means))
  
  daily_means$date <- as.Date(daily_means$date, 
                              format = "%Y%m%d")
  df_tmin <- rbind(df_tmin, daily_means)
  
}
saveRDS(df_tmin, file = 'output/processed/df_tmin.rds')

# Maxium Temperature ----
rm(list = "daily_means")
df_tmax <- data.frame()
prism_set_dl_dir(path = 'output/raw/prism/tmax/')
for(i in seq(from = 6, 
             to = length(prism_archive_ls()),
             by = 6)) {
  upper <- i
  lower <- i - 5
  
  cat('Iteration: ', i/6, 'out of 366.')
  
  raster_stack <- pd_stack(prism_archive_ls()[lower:upper])
  
  daily_means <- exact_extract(raster_stack,
                               USmap_county,
                               fun = 'mean')
  
  daily_means <- cbind.data.frame(fips, daily_means)
  
  for(name in 2:length(daily_means)) {
    
    names(daily_means)[name] <- substr(names(daily_means)[name], 30, 37)
    
  }
  
  daily_means <- gather(daily_means, 
                        date, 
                        tmax, 
                        2:length(daily_means))
  
  daily_means$date <- as.Date(daily_means$date, 
                              format = "%Y%m%d")
  df_tmax <- rbind(df_tmax, daily_means)
  
}
saveRDS(df_tmax, file = 'processed/df_tmax.rds')
#end
