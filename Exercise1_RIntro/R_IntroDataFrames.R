#//////////////////////////////////////////////
#This code was developmed by:
#Shannon E. Albeke, Ph.D.
#University of Wyoming
#Wyoming Geographic Information Science Center
#Laramie, WY 82071
#salbeke@uwyo.edu / 307-766-6207
#/////////////////////////////////////////////

# To data wrangle, we need to load a package
require(tidyverse)
require(readxl)

#////////////////////////////////////////////////////
#Begin Analyses section

#set the working directory
setwd("C:/Users/salbeke/Documents/Courses/R_Workshops/AFS_COWY2018/Data")

#Read in the NDVI data from Ramesh ndvi...yes we can read from an Excel file!


#plot the data as lines


# ok reformat the data and run an anova to test for significant differences
# this means adding a Normal/Dry category and moving the data from columns to rows...use dplyr::gather


# Change the data type for Season, make it a factor


#make the same plot as before, just filter but now it's easier


#Run the ANOVA


#Now filter the data.frame to be summer time (DOY between 140 and 260)


#Re-run a ANOVA

