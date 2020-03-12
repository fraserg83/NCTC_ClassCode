# Intro to R: Tidyverse
# author: Shannon E. Albeke
# date: September, 2019

# Below I demonstrate some common data wrangling tasks on a simple dataset

require(tidyverse)
require(plotly)
require(lubridate)



# Let's create a simple set of strings for us to test string matching/splitting
vals<- c("Site_1", "Site_2", "Site_30")

# Split the string given a character, a list object is returned
str_split(vals, pattern = "_")

# By adding an argument, you can change how this is returned, now a matrix
str_split(vals, pattern = "_", simplify = TRUE)

# So it is easier to grab the value you want
str_split(vals, pattern = "_", simplify = TRUE)[,2]

# Look for a specific value within a vector of characters
str_detect(vals, pattern = "2")

# You can grab a set number of characters
str_sub(vals, start = 1, end = 4)

# You can find positions within a string
str_locate(vals, pattern = "Site")

# Often times you want to make numbers the same length of characters
str_pad(c(1, 2, 30), width = 3, pad = "0")

# Replace strings
str_replace(vals, pattern = "_", replacement = "-")

# Get rid of whitespace
str_squish("  white space  ")

str_replace_all("  white space  ", pattern = " ", replacement = "")




# Let's read in a tab-delimited file. I'm starting to like the readr package, it's smarter than base R and saves us some time with column data types
# "/t" means tab
met<- read_delim("WRIR_WeatherStation.txt", delim = "\t")

# Investigate the data
# How many sites do we have
unique(met$SiteID)

# What are the range of dates
range(met$Samp_Date)

# Are the Temperature values all within an expected range
range(met$AirTemperature_C)


# Reduce the data to only be for 2017, "&" means and
m2017<- met %>% 
  filter(Samp_Date >= as.Date("2017-01-01") & Samp_Date < as.Date("2018-01-01"))

range(m2017$Samp_Date)

# Now reduce to only be one of the sites
m2017<- m2017 %>% 
  filter(SiteID == "ASWW4")




