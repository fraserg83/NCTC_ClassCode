require(lubridate)
require(tidyverse)
require(data.table)
require(sf)
require(mapview)

setwd("./DataWrangling/Exercise8_9_Workflows/ElkData")

# Read in the elk points. These are GPS locations for Elk between months 3 and 8 across a couple of years,
# some are migratory, some are resident
elk<- fread("Absorka_Elk.txt", header = TRUE, sep = "\t", stringsAsFactors = FALSE)

# Coerce the date to POSIXct
elk$TelemDate<- as.POSIXct(elk$TelemDate, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")

# Make spatially aware, the coordinates are in Albers Equal Area USGS version
elk<- st_as_sf(elk, coords = c("AEA_X", "AEA_Y"), crs = "+init=epsg:5072")
# Take a look at where they are
mapview(elk)

# Our goal is to calculate the Net Displacement for each animal for each year we have data.
# We will define net displacement as the distance between the earliest location and the latest location within a year

# First, create a table defining the min and max dates for each animal within a year
elk$Year <- year(elk$TelemDate)

# Aggregate the data so we know the min and max dates for each elk and year
elkSum<- summarize()

# Loop through the table and calculate the distances between the points
# In this exercise you will use the following functions
# filter, st_distance and rbind
outDist<- data.frame()
for(i in 1:nrow(elkSum)){
  # Filter for the rows matching current animal/year
  myelk<- elk %>% 
    filter(AID == elkSum$AID[i] & TelemDate %in% c(elkSum$minDate[i], elkSum$maxDate[i]))
  # Should only return two rows, so use GIS tools to calculate the distance between points
  dist<- st_distance(myelk)[1,2]
  # Append the rows, your output data.frame should have AID, Year, NetDisplace
  outDist<- rbind(outDist, data.frame(AID = elkSum$AID[i], 
                                      Year = elkSum$Year[i],
                                      NetDisplace = dist))
  
}

