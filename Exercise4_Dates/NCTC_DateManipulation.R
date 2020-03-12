require(readxl)
require(lubridate)
require(tidyverse)
require(sf)
require(mapview)

setwd("./Exercise5_Dates")

# ---- Otter Dive Time ----
# Get the Otter Data
otter<- read_excel("OtterDiveTimes.xlsx", sheet = "Sheet1")

# Look at the structure
str(otter)

# We have a problem. Because Excel added in a format for the column, R assumed a date. This is bad, so fix it...
# To fix the issue, let's coerce to a character, then rip off date piece

# Coerce to a character
otter$startTime<- as.character(otter$startTime)

# Let's test what we are doing first, play with the first row and split the date by a " " (space)


# As you can see, the above string split function returns a List, inside the list is a character vector of length 2
# Get to the 2 value and you have the time only!


# Now that we know what we want and how to get it, do it for all of the rows
otter$startTime<- sapply(strsplit(otter$startTime, " "), "[", 2)

# Next we need to put all of the date components into a single string of values, paste function is our friend
otter$TelemDate<- paste(otter$SampMonth, "/", otter$SampDay, "/", otter$SampYear, " ", otter$startTime, sep = "")

# Now we need to coerce to a POSIXct so we can use the built in date functions to make calculations
otter$TelemDate <- as.POSIXct(otter$TelemDate, format = "%m/%d/%Y %H:%M:%S", tz = "UTC")

# Since we have data in a date format, we can use lubridate functions to grab whatever portion of the date we want!
year(otter$TelemDate)
day(otter$TelemDate)
month(otter$TelemDate)
hour(otter$TelemDate)
minute(otter$TelemDate)
second(otter$TelemDate)

# We can also perform math and make calculations on this continuous variable
# Loop through the rows and calculate the amount of time the otter was perfoming each behavior



# Give the first row a value
otter$TimeSpent[1]<- 0

# Summarize the total amount of time performing each behavior
bTime<- summarize(group_by(.data = otter, Activity), TotalSecs = sum(TimeSpent))


# ---- Different Date Formats ----
# Read in the Polar Bear Collars
bear<- read.table("PolarBears.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)

# This data has a format that no one should ever use, but that shouldn't stop us. Make thetime into POSIXct
# look at the strptime function help for all of the possible formats
bear$TelemDate<- as.POSIXct(strptime(bear$thetime, format = "%d%b%y:%H:%M:%S", tz="UTC"))

# Make the data spatially aware, data are in GCS WGS84 "+init=epsg:4326"
bear<- st_as_sf(bear, coords = c("longitud", "latitude"), crs = "+init=epsg:4326")

# Plot the points
mapview(bear)
