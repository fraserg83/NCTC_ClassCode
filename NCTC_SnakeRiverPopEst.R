require(tidyverse)
require(fishmethods)

# Set the working directory
setwd("C:/Users/salbeke/Documents/Courses/R_Workshops/AFS_COWY2018")

# ///////////////////////////////////////////////////////////
# ---- SRC 2013 Data ----
# Get some data
dat1<- read.table("./FishData/SnakeData2013.csv", header = TRUE, sep = ",")

# Length is in inches and weight is in pounds. 
# The estimates both started at this UTM (NAD83): Zone 12 517146E 4826267N  
# The 2013 estimate ended at this UTM (NAD 83): Zone 12 515039E 4820597N 
# The 2016 estimate ended at this UTM (NAD 83): Zone 12 514521E 4819868N 
# NAD83 Zone 12 = epsg:26912; Zone 13 = epsg:26913

# CaptureHistory
# M1 : Marked on the first pass
# M2 : Marked on the second pass (first time captured)
# M3 : Marked on the third pass (first time captured)
# R2-1: Recaptured on the second pass, marked on the first pass
# R3-1: Recaptured on the third pass, marked on the first pass
# R3-2: Recaptured on the third pass, marked on the second pass
# R3-12: Recaptured on the third pass, marked on both the first pass and second pass

# Create new column describing the capture history and pass
dat1<- mutate(.data = dat1, CapType = substr(Capture.History, 1, 1), Pass = substr(Capture.History, 2, 2))

# Schnabel method; requires us to massage the input data into summarized values for the capture history
sum2013<- summarise(group_by(.data = dat1, Species, CapType, Pass), Count = length(na.omit(Capture.History)))

# Let's filter for only SRC and Capture History != NULL
src2013<- filter(.data = sum2013, Species == "SRC" & CapType != "")

# Pivot the table. We need 3 columns to meet the expectations of the method; Catch, Recaps, NewMarks
schab2013<- spread(data = src2013, key = CapType, value = Count)

# Update the Recaps for pass 1
schab2013$R[1]<- 0

# Calculate the new Marks column
schab2013<- mutate(.data = schab2013, tM = M + R)

# Fit the Schnabel Model
modFit2013<- schnabel(catch = schab2013$tM, recaps = schab2013$R, newmarks = schab2013$M, alpha=0.05)

# /////////////////////////////////////////////


# /////////////////////////////////////////////
# ---- SRC 2016 Data ----
dat2<- read.table("./Data/SnakeData2016.csv", header = TRUE, sep = ",")

# Create new column describing the capture history and pass


# Schnabel method; requires us to massage the input data into summarized values for the capture history


# Let's filter for only SRC and Capture History != NULL


# Pivot the table. We need 3 columns to meet the expectations of the method; Catch, Recaps, NewMarks


# Update the Recaps for pass 1


# Calculate the new Marks column


# Fit the Schnabel Model


# ////////////////////////////////////////////////


# ---- Automate the Process ----
# Why would we want to write the same code over and over again if we can just write it once?
# Let's automate this process by creating a loop the perform the same estimation method across many samples

# Step 1: Get list of files with the same format, etc., so find all .csv files
# Let's drop into the directory that has all of the data
setwd("./Data")
# Look in the current directory
files<- dir(pattern = ".csv$")

# Create a blank output
outFit<- data.frame()
# Loop through each file and conduct the analysis
for(i in 1:length(files)){
  fish<- read.table(files[i], header = TRUE, sep = ",")
  
  # Create new column describing the capture history and pass
  fish<- mutate(.data = fish, CapType = substr(Capture.History, 1, 1), Pass = substr(Capture.History, 2, 2))
  
  # Schnabel method; requires us to massage the input data into summarized values for the capture history
  fish<- summarise(group_by(.data = fish, Species, CapType, Pass), Count = length(na.omit(Capture.History)))
  
  # Let's filter for only SRC and Capture History != NULL
  fish<- filter(.data = fish, Species == "SRC" & CapType != "")
  
  # Pivot the table. We need 3 columns to meet the expectations of the method; Catch, Recaps, NewMarks
  fish<- spread(data = fish, key = CapType, value = Count)
  
  # Update the Recaps for pass 1
  fish$R[1]<- 0
  
  # Calculate the new Marks column
  fish<- mutate(.data = fish, tM = M + R)
  
  # Fit the Schnabel Model
  mFit<- schnabel(catch = fish$tM, recaps = fish$R, newmarks = fish$M, alpha=0.05)
  
  # Store the results of the Schnable  to an output data.frame. Thus use only the first row
  outFit<- rbind(outFit, data.frame(File = files[i], mFit[1,]))
}

# Now plot the population estimates by file for the Schnabel method
ggplot(data = outFit, aes(x = File, y = N)) +
  geom_bar(stat = "identity", fill = "lightgrey") +
  geom_errorbar(aes(ymin = LCI, ymax = UCI, width = 0.1)) +
  theme_bw() +
  theme(panel.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())


