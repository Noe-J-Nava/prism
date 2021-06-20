rm(list = ls())

# Script downloads prism data for precipitation, minimum and maximum temperature at the daily resolution.
# Focus is on Growing season only: April 1 to September 30 based on the work of Burke and Emerick (2016)

library(prism)

vars <- c("ppt",  #precipitation
          "tmin", #Minimum temperature
          "tmax"  #Maximum temperature
          )

years <- seq(from = 1994, to = 1998)
years <- append(years, 
                seq(from = 2014,
                    to   = 2018 ))
years <- as.character(years)

for(var in vars) {
 
   dir.create(paste('data/raw/', 
                    var, 
                    sep = ""), 
              showWarnings = FALSE)

}

for(var in vars) {
  
  # Setting directory
  dir <- paste('data/raw/', var, sep = "")
  prism_set_dl_dir(dir)
  
  for(year in years) {
    minDate <- paste(year, "-04-01", sep = "")
    maxDate <- paste(year, "-09-30", sep = "")

    print(var)
    print(year)
    
    get_prism_dailys(
      type = var,
      minDate = minDate,
      maxDate = maxDate,
      keepZip = FALSE
      )
    
  }
}
#end