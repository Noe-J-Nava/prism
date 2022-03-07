# Noé J Nava
# Noe.Nava@usda.gov
# ERS - MTED - APM

# Note:
# Script downloads data from Oregon's PRISM: Climate Group. 
# I download daily values for precipitation, maximum and minimum temperatures
# from 1992 - 2020.

rm(list = ls())

# Settings:
fromYear       <- 1992       # Year collection starts
toYear         <- 2020       # Year collection ends
leftInterval   <- "-01-01"   # First day of the year format "-mm-dd"
rightInterval  <- "-12-31"   # First day of the year format "-mm-dd"

library(prism)

vars <- c("ppt",  # Precipitation
          "tmin", # Minimum temperature
          "tmax"  # Maximum temperature
          )

years <- seq(from = fromYear, to = toYear)
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
    minDate <- paste(year, leftInterval, sep = "")
    maxDate <- paste(year, rightInterval, sep = "")

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