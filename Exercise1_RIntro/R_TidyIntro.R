# Intro to R: Tidyverse
# author: Shannon E. Albeke
# date: September, 2019

# Below I demonstrate some common data wrangling tasks on a simple dataset

#directs R to use data currently saved to the clipboard via cntl c 
dat<- clipr::read_clip_tbl()

#require and library both load packages, synonyms 
require(tidyverse)
require(readxl)
require(lubridate)

setwd("C:/CSP1004/CSP1004_Albeke/Exercise1_RIntro")
# Get data from an excel file
dat<- read_excel("TidyExampleData.xlsx", sheet = "Animals")

# Check on the structure of the data
str(dat)
glimpse(dat)

#### Piping Workflow ####

# Where ever you have the first argument that is expecting a data.frame, you can use piping. Some folks love it, others despise. I personally feel that once you get used to the syntax, it truly speeds up a workflow. So here is a quick introduction to piping...

# Base R to add new column
dat$Temp_F<- (dat$Temp_C * 9 / 5) + 32
# Remove the column
dat$Temp_F<- NULL

# Tidy / piping way...this may seem longer for a simple task, but when you potentially string many functions together, you can get your workflow to be more efficient. You will notice that we don't have to provide column names as "column", and by assigning dat1, we are writing to a new object with the new result 
?mutate

dat1<- dat %>% 
  mutate(Temp_F = (Temp_C * 9 / 5) + 32)

# But we can string several functions together, so let's go back to our original dataset by creating a new column, but then deciding we don't want the celcius column anymore
dat1<- dat %>% # take data.frame, pass to mutate function
  mutate(Temp_F = (Temp_C * 9 / 5) + 32) %>% # Take result of previous, pass to select
  select(Site, SampDate, Temp_F, Species_1, Species_2) # only store the final result to object


#### Data Transformations ####

# Adjust a column type to POSIXct
dat<- dat %>% 
  mutate(SampDate = as.POSIXct(SampDate, format = "%m/%d/%Y", tz = "UTC"))

# Split values into new columns
dat<- dat %>% 
  separate(Site, into = c("First", "Second"), sep = " ", remove = FALSE)

# Pad our numbers to be 2 characters long
str_pad(dat$Second, width = 2, side = "left", pad = 0)

dat <- dat %>% 
  mutate(Second = str_pad(Second, width = 2, side = "left", pad = 0))

# Paste columns together
dat<- dat %>% 
  unite(NewSite, First, Second, sep = "_", remove = FALSE)

# Reduce variables via select what columns you want OR using - to remove unwanted columns
dat<- dat %>% 
  select(-c(Site, First, Second))

# Rename a column
dat<- dat %>% 
  rename(Site = NewSite)

# Often times, we want to summarize information. Tidyverse is VERY good at assisting with this.

# Calcuate the mean number if individuals for each site
sumDat<- dat %>% 
  group_by(Site) %>% 
  summarise(MeanSpec1 = mean(Species_1),
            MeanSpec2 = mean(Species_2))

# But what happens when you have 50 columns of species??? 

# This is where tidyverse and data science methods and help you immensely. Let's make the table vertical, so make columns into rows...
vert<- dat %>% 
  pivot_longer(Species_1:Species_2, names_to = "Species", values_to = "Count")

# We can put the data back into the same wide shape if we want
wide<- vert %>% 
  pivot_wider(names_from = Species, values_from = Count)

# Ok, now that we have seen what gather and spread can do, let's string the whole thing together to create the same summary stats as before
tsumDat<- dat %>% 
  pivot_longer(Species_1:Species_2, names_to = "Species", values_to = "Count") %>% 
  group_by(Site, Species) %>% 
  summarise(MeanSpecies = mean(Count)) %>% 
  pivot_wider(names_from = Species, values_from = MeanSpecies)

# Let's get another dataset into RAM for us to play with
veg<- read_excel("TidyExampleData.xlsx", sheet = "Veg")

# check out the dataset
glimpse(veg)

# Coerce to POSIXct
veg<- veg %>% 
  mutate(SampDate = as.POSIXct(SampDate, format = "%m/%d/%Y", tz = "UTC"))

# Notice that we have some NA's for tree. We know that we really want these to be 0% because they are not missing data, there just weren't any trees!
veg<- veg %>% 
  mutate(Tree = replace_na(Tree, 0))

# OK, what is different about the veg vs dat data.frame....fix it so veg matches dat

# Split values into new columns
veg<- veg %>% 
  separate(Site, into = c("First", "Second"), sep = " ", remove = FALSE) %>% 
  mutate(Second = str_pad(Second, width = 2, side = "left", pad = 0)) %>%
  unite(NewSite, First, Second, sep = "_", remove = FALSE) %>%
  select(-c(Site, First, Second)) %>% 
  rename(Site = NewSite)

# Join the 2 data.frames together
myDat<- dat %>% 
  left_join(veg, by = c("Site", "SampDate"))

# Now that all of the data are together, let's do some visualization! 

# First, summarize all of the measured values for each site and measurement across time
# Steps = data to long, group, summarize (mean, sd, count, CI95)
allSum<- myDat %>% 
  pivot_longer(Temp_C:Tree, names_to = "Param", values_to = "Measure") 
  group_by(Site, Param) %>% 
  

# Let's create a boxplot just to look at the information, best if in long format
allVert<- myDat %>% 
  pivot_longer(Temp_C:Tree, names_to = "Param", values_to = "Meas")

ggplot(data = allVert, aes(x = Param, y = Meas, fill = as.factor(Site))) +
  geom_boxplot()

# Is there a relationship between species Total count and vegetation?





