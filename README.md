# Collecting and processing PRISM data codes 

This repository reflects the working directory to collect and process PRISM data using R. First collect the data with `code/prism_data_collection.R`. The code collects the variables `tmax`, `tmin`, and `ppt` from [PRISM](https://prism.oregonstate.edu/). `code/prism_data_processing.R` shows a simple code to loop over the raw data and create a dataset for analysis. This script requires of polygon shapes (at the county level). Script identifies values from PRISM raster that belong to each county polygon, and then it calculates a value for the polygon. The outputs are three dataframes with county as identifier, across the several periods of time for each one of the variables: `tmax`, `tmin`, and `ppt`.  

Scripts are ad-hoc for my purposes, but can easily be modified to accommodate other purposes.

