# Noé J Nava
# Noe.Nava@usda.gov
# ERS - MTED - APM

# Note:
# Script process PRISM data to create county weather averages for each one of the 
# historical weather variables.
# Script requires of county polygons' shape file.

# Known issues: 
# One drive has an annoying issue in which some of the directories are rendered
# useless, and they are unable to be modified/deleted/dealt with. There is a solution
# which requires administrator's priviledges. I can spend 2 weeks trying to contact
# IT or simply move on with out those files. Because these are daily values and
# the portion of errors is relatively small, I will just ignore. See the bunch
# of daily values that cannot be processed.

rm(list = ls())

library(prism)
library(rgdal)
library(lubridate)
library(exactextractr)
library(tidyverse)
library(terra)

# Daily values that cannot be processed because of one drive issue: 
ppt_onedrive <- c("PRISM_ppt_stable_4kmD2_19991010_bil",
                  "PRISM_ppt_stable_4kmD2_20000417_bil",
                  "PRISM_ppt_stable_4kmD2_20050205_bil",
                  "PRISM_ppt_stable_4kmD2_20051226_bil",
                  "PRISM_ppt_stable_4kmD2_20070515_bil",
                  "PRISM_ppt_stable_4kmD2_20080412_bil",
                  "PRISM_ppt_stable_4kmD2_20090321_bil",
                  "PRISM_ppt_stable_4kmD2_20111121_bil",
                  "PRISM_ppt_stable_4kmD2_20120904_bil",
                  "PRISM_ppt_stable_4kmD2_20140531_bil",
                  "PRISM_ppt_stable_4kmD2_20160209_bil",
                  "PRISM_ppt_stable_4kmD2_20170709_bil",
                  "PRISM_ppt_stable_4kmD2_20190329_bil",
                  "PRISM_ppt_stable_4kmD2_20200111_bil")
tmax_onedrive <- c("PRISM_tmax_stable_4kmD2_19940203_bil",
                   "PRISM_tmax_stable_4kmD2_20001005_bil",
                   "PRISM_tmax_stable_4kmD2_20080404_bil",
                   "PRISM_tmax_stable_4kmD2_20100506_bil",
                   "PRISM_tmax_stable_4kmD2_20110702_bil")
tmin_onedrive <- c("PRISM_tmin_stable_4kmD2_19950829_bil",
                   "PRISM_tmin_stable_4kmD2_19960729_bil",
                   "PRISM_tmin_stable_4kmD2_19991015_bil",
                   "PRISM_tmin_stable_4kmD2_20111225_bil",
                   "PRISM_tmin_stable_4kmD2_20130621_bil",
                   "PRISM_tmin_stable_4kmD2_20180719_bil")

# County Polygons ----
USmap_county <- readOGR(dsn = 'assets/3109_county',
                        layer = 'USmap_county')
fips <- as.numeric(USmap_county@data$ANSI_ST_CO)
fips <- as.character(fips)

# Precipitation ----
df_ppt  <- data.frame()
prism_set_dl_dir(path = 'data/raw/ppt/')
prism_archive_ls_noIssues <- prism_archive_ls()[!prism_archive_ls() %in% ppt_onedrive]
totIter <- length(prism_archive_ls_noIssues)
for(i in seq(from = 6, 
             to = length(prism_archive_ls_noIssues),
             by = 6)) {
  
  upper <- i
  lower <- i - 5
  
  cat('Iteration: ', i/6, 'out of', totIter/6, ".")

  raster_stack <- pd_stack(prism_archive_ls_noIssues[lower:upper])
  
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
saveRDS(df_ppt, file = 'data/processed/df_ppt.rds')

# Minimum Temperature ----
rm(list = "daily_means")
df_tmin <- data.frame()
prism_set_dl_dir(path = 'data/raw/tmin/')
prism_archive_ls_noIssues <- prism_archive_ls()[!prism_archive_ls() %in% tmin_onedrive]
totIter <- length(prism_archive_ls_noIssues)
for(i in seq(from = 6, 
             to = length(prism_archive_ls_noIssues),
             by = 6)) {
  upper <- i
  lower <- i - 5
  
  cat('Iteration: ', i/6, 'out of', totIter/6, ".")
  
  raster_stack <- pd_stack(prism_archive_ls_noIssues[lower:upper])
  
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
saveRDS(df_tmin, file = 'data/processed/df_tmin.rds')

# Maxium Temperature ----
rm(list = "daily_means")
df_tmax <- data.frame()
prism_set_dl_dir(path = 'data/raw/tmax/')
prism_archive_ls_noIssues <- prism_archive_ls()[!prism_archive_ls() %in% tmax_onedrive]
totIter <- length(prism_archive_ls_noIssues)
for(i in seq(from = 6, 
             to = length(prism_archive_ls_noIssues),
             by = 6)) {
  upper <- i
  lower <- i - 5
  
  cat('Iteration: ', i/6, 'out of', totIter/6, ".")
  
  raster_stack <- pd_stack(prism_archive_ls_noIssues[lower:upper])
  
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
saveRDS(df_tmax, file = 'data/processed/df_tmax.rds')
#end
