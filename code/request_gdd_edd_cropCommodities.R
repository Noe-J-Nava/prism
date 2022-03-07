# Noé J Nava
# Noe.Nava@usda.gov
# ERS - MTED - APM

# Note:
# Script process PRISM data to be used in ag. econ analyses that require 
# gdd, edd and ppt.
# One dataset per commodity is created to be used in a SQL dataset

# Ppt is "daily total precipitation (rain + melted snow)" --- unit is mm
# Tmax is "daily maximum temperature"                     --- unit is Celsius
# Tmin is "daily minimum temperature"                     --- unit is Celsius

rm(list = ls())

out_directory <- "output/gdd_edd_cropCommodities/" # Output directory
library(tidyverse)

# Commodity list split by lower part of gdd threshold
# Upper part of gdd threshold is assummed to be 30C
# Above 30C, we are working with GDD.
commodityList_4.4C <- c("barley",
                        "oats",
                        "rye",
                        "wheat")
commodityList_10C  <- c("corn",
                        "rice",
                        "sorghum",
                        "soybeans")
commodityList <- append(commodityList_4.4C, commodityList_10C)

# GDD and EDD functions
gdd.function <- function(tmin, tmax, tbase) {
  
  taverage <- .5*(tmax + tmin)
  # GDD is capped at 30C, and GDD cannot be less than zero (e.g., negative)
  taverage <- ifelse(taverage <= 30, taverage, 30)
  taverage <- ifelse(taverage > tbase, taverage, tbase)
  gdd <- taverage - tbase
  
  return(gdd)
  
}

edd.function <- function(tmin, tmax) {
  
  taverage <- .5*(tmax + tmin)
  # EDD occur at higher than 30
  taverage <- ifelse(taverage > 30, taverage, 30)
  edd <- taverage - 30
  
  return(edd)
  
}

# Create receiving dataset
fipsList <- readRDS(file = "data/processed/df_ppt.rds") %>%
  select(fips) %>% distinct() %>% pull()
timeFrame <- seq(as.Date("1992-01-01"), as.Date("2020-12-31"), by = "days")

# Creating and saving the commodity datasets as R objects
for(commodity in commodityList) {
  
  dataset   <- expand.grid(fipsList, timeFrame)
  names(dataset) <- c("fips", "date")
  
  # Adding precipitation
  df_ppt  <- readRDS(file = "data/processed/df_ppt.rds")
  dataset <- left_join(dataset, df_ppt, by = c("fips", "date"))
  rm(list = "df_ppt")
  gc()
  
  # Creating edd and gdd specific to commodity
  if(commodity %in% commodityList_4.4C) { tbase <- 4.4 }else{ tbase <- 10 }
  
  df_tmin <- readRDS(file = "data/processed/df_tmin.rds")
  df_tmax <- readRDS(file = "data/processed/df_tmax.rds")
  
  df_dd <- left_join(df_tmin, df_tmax, by = c("fips", "date"))
  rm(list = c("df_tmin", "df_tmax"))
  gc()

  df_dd <- df_dd %>%
    mutate(gdd = gdd.function(tmin, tmax, tbase)) %>%
    mutate(edd = edd.function(tmin, tmax)) %>%
    select(fips, date, gdd, edd)
  
  dataset <- left_join(dataset, df_dd, by = c("fips", "date"))
  rm(list = "df_dd")
  gc()
  
  # Saving as .rds objects locally
  out_directoryCommodity <- paste0(out_directory, commodity, ".rds")
  saveRDS(dataset, file = out_directoryCommodity)

}
# End