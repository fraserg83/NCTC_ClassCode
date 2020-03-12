
require(stringr)
require(tidyverse)

setwd("./DataWrangling/Exercise8_9_Workflows/NN_Met_2/YEAR_2018/MONTH_01/DAY_01")

# ---- Single File ----
# Get a list of files within the directory
file<- dir(pattern = ".dat$")

# Copy the column names from row 2 of text file for the RepeaterSensor
datNames<- c("TIMESTAMP","RECORD","AirTC_6","RH_6_min","RH_6_max","AirTC_10","RH_10_min","RH_10_max","WS_ms_30","WindD_30_D1_WVT","WS_ms_15","SlrkW_R","SlrMJ_R","SoilC_2","DT_R","Q_R","TCDT_R","DBTCDT_R","repeat_rain")

# We only want the data within the Repeater files. Let's use function to determine
# which one has Repeater in the file name
str_locate(file, "Repeater")

# Use the str_locate function to help us read in the one file we want


# Rename the columns
names(dat)<- datNames

# Look at the structure
str(dat)

# Things look appropriate except for the date, let's simply cast to a character
dat$TIMESTAMP<- as.character(dat$TIMESTAMP)

# Great! Now that we have created a data.frame from one file and know the steps, 
# We should now create a process to automate and process ALL of the Repeater files within the directories

# ---- Step 1: Directory Structure ----
setwd("./DataWrangling/Exercise8_9_Workflows/NN_Met_2/YEAR_2018")

# Get all of the files within the directory, use the recursive argument
files<- dir(pattern = ".dat$", recursive = TRUE)

# Find which files, by index, have Repeater data
rep<- which(!is.na(str_locate(files, "Repeater")[,1]))

# Reduce the list of files
files<- files[rep]

# Copy the column names from row 2 of text file
datNames<- c("TIMESTAMP","RECORD","AirTC_6","RH_6_min","RH_6_max","AirTC_10","RH_10_min","RH_10_max","WS_ms_30","WindD_30_D1_WVT","WS_ms_15","SlrkW_R","SlrMJ_R","SoilC_2","DT_R","Q_R","TCDT_R","DBTCDT_R","repeat_rain")

# Create a blank data.frame
outDF<- data.frame()
# Now loop through each file and append rows to our output
for(i in 1:length(files)){
  # Read in current file
  
  # Give the table names
  
  # Things look appropriate except for the date, let's simply cast to a character
  
  # Append the output
  
}

# Make the TIMESTAMP POSIXct


# Plot temperature through time as a line

