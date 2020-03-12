require(tidyverse)
require(readxl)
require(data.table)
require(plotly)
require(sf)
require(mapview)

setwd("./DataWrangling/Exercise6_7_BeerStyles")

# Get styles
bjcp<- read_excel("BJCP_2015.xlsx", sheet = "Styles")

# Investigate the data
View(bjcp)
str(bjcp)

# What do we notice about the data? Let's look at the ABV and SRM columns...

# What should we do? We should coerce column types to numeric where appropriate
bjcp<- mutate(.data = bjcp, 
              `ABV min` = as.numeric(`ABV min`),
              `ABV max` = as.numeric(`ABV max`),
              `SRM min` = as.numeric(`SRM min`),
              `SRM max` = as.numeric(`SRM max`))

# Same as 
bjcp$`ABV min`<- as.numeric(bjcp$`ABV min`)
bjcp$`ABV max`<- as.numeric(bjcp$`ABV max`)
bjcp$`SRM min`<- as.numeric(bjcp$`SRM min`)
bjcp$`SRM max`<- as.numeric(bjcp$`SRM max`)

# Get the breweries
brew<- read.table("breweries.txt", header = TRUE, sep = "\t", stringsAsFactors = FALSE)

#############
# For those interested, I used the following code to attribute the 
# table with address and lon/lat
# require(ggmap)
# brew$lon<- NA
# brew$lat<- NA
# brew$address<- NA
# for(i in 1:nrow(brew)){
#   # Test if the location has been found
#   if(is.na(brew$lon[i])){
#     result<- geocode(paste(brew$name[i], brew$city[i], brew$state[i]), output = "latlona", source = "google")
#     # if the brewery was found
#     if(ncol(result) == 3){
#       brew$lon[i]<- result$lon[1]
#       brew$lat[i]<- result$lat[1]
#       brew$address[i]<- result$address[1]
#     }
#   }
# }
#####################

# Get existing beers, this is the most common function to read in files
beer<- read.table("beers.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)

# Not sure why read.table fails, but fear not, we have other options!
# fread is fantastic, it can read in data 10x FASTER! Wonderful for larger datasets
beer<- fread("beers.csv", header = TRUE, sep = ",")

# Investigate the data
View(beer)

# Notice anything funny about ABV? Change from proportion to percent
beer$abv<- beer$abv * 100

# I want to view the frequency of BJCP beer styles that have been produced

# What should we do?


# ---- Step 1: Compare Styles  ---- 
# Unique beer styles
style<- 

# Put them in order
style<- 
  
# Take a look at some of the styles
style

# Now check out the BJCP styles
bjcpStyle<- unique(bjcp$Styles)
# Put them in order
bjcpStyle<- bjcpStyle[order(bjcpStyle)]
# Take a look
bjcpStyle

# Looking manually is lame, use functions to help you determine non-matches
style %in% unique(bjcp$Styles) # Where ever you see a FALSE, no BJCP match

# Which beer styles do not match the BJCP style?


# The easiest way to connect the two tables AND guarantee that it is correct 
# is to export the list of unique beer styles, and then type in the BJCP category.
# To do this, coerce style into a data.frame and save to disk
style<- data.frame(Style = style)

# Save to disk, knowing that you are writing to the same directory that you previously set.
# write.table(style, file = "BeerToCategory.txt", row.names = FALSE, sep = "\t")

# ---- Step 2: Organize Data ----

# I have already performed the above task of editing the table, so let's read in the Excel file
xref<- 

# You will notice that the category is two digits, and one alpha. 
# Let's create a new column of just the 'base style', so the two digit side
xref$BaseCat<- substr(xref$CatNumber, start = 1, stop = 2)

# Given the xref table, let's simply attribute beers with the bjcp category
beer<- left_join(x = beer, y = xref, by = c("style" = "Style"))

# now we can talk between the beer and bjcp tables as well as summarize by category
# SO we are standardizing our data, the goal of all data scientists!!

# ---- Step 3: Summarize & Visualize ----

# I think we should assess the central tendency and variability of ABV for each category
beerSum<- summarize(group_by(.data = beer, BaseCat), 
                    meanABV = mean(abv, na.rm = TRUE),
                    sdABV = sd(abv, na.rm = TRUE),
                    CI95 = (sd(abv, na.rm = TRUE) / length(na.omit(abv))) * 1.96,
                    NumBeers = length(na.omit(abv)))

# You can get the same result using functional programming
beerSum2<- beer %>% 
  group_by(BaseCat) %>% 
  summarize(meanABV = mean(abv, na.rm = TRUE),
            sdABV = sd(abv, na.rm = TRUE),
            CI95 = (sd(abv, na.rm = TRUE) / length(na.omit(abv))) * 1.96,
            NumBeers = length(na.omit(abv)))

# ---- Bar Plot of Style Frequency ----
# What is the most common beer style? Quickest way
table(beer$CatNumber)
table(beer$style)

ggplot(data = beer, mapping = aes(x = CatNumber)) +
  geom_bar() +
  theme(panel.background = element_rect(fill = "white", colour = "black")) + # Get rid of grey background
  theme(axis.text.x = element_text(size = 9, angle = 90) ) +
  labs(x = "BJCP Style")

# Where are the beers being produced within the country?
# First make the breweries spatially aware
brew<- st_as_sf(brew, coords = c("lon", "lat"), crs = "+init=epsg:4326")
# Plot the points
mapview(brew)

# Create data.frame in which ABV and IBU are present
met<- filter(.data = beer, !is.na(abv) & !is.na(ibu))

# Now creat a scatter plot to see if a pattern exists between booze and bitter
p<- ggplot(data = met, mapping = aes(x = abv, y = ibu, color = BaseCat)) +
  geom_point()

# Since we stored the plot in a variable, we have to view it
p 

# Let's use a nifty little function to make the plot interactive/reactive
ggplotly(p)

# Add a regression line
ggplot(data = met, mapping = aes(x = abv, y = ibu)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE)

# We can fit a linear regression to quantify the relationship
mod<- lm(ibu ~ abv, data = beer)

# Look at the results
summary(mod)

# Does the model meet assumptions? This works well with OLS regression
plot(mod)


# ---- Join Expected to Observed Style ----
# Only join the data that match
beerExp<- inner_join(x = beer, y = bjcp, by = "CatNumber")

# Create a new column of whether the beer falls within the ABV style guideline
beerExp$FitABV<- ifelse(beerExp$abv >= beerExp$`ABV min` & beerExp$abv <= beerExp$`ABV max`, 1, 0)

# This does the same, but uses Tidyverse methods
beerExp<- mutate(.data = beerExp, FitABV = ifelse(abv >= `ABV min` & abv <= `ABV max`, 1, 0))

# Which beers are outside of BJCP guidelines
bad<- 

# Are there paricular breweries that are more prevalent?
table(bad$brewery_id)

# What proportion of a brewery is out of style?
allbeer<- data.frame(table(beer$brewery_id))
badbeer<- data.frame(table(bad$brewery_id))

# Join the tables
allbeer<- left_join(x = allbeer, y = badbeer, by = "Var1")

# Change the NA values to 0
allbeer<- mutate(.data = allbeer, Freq.y = ifelse(is.na(Freq.y), 0, Freq.y))

# Calculate the percentage
allbeer$PctOutStyle<- (allbeer$Freq.y / allbeer$Freq.x) * 100

# OK, There are 558 breweries, some have too small of a sample size, filter out
# The ones have less than 5
allbeer<- 

  
# ---- GGPLOT CHALLENGE ----
  
# Create a point plot of where on the abv style guideline a beer is. To do 
# this you will need to create a blank ggplot, then create 3 separate geom_point
# in which you specify the data and aes(). You will want to use the filter function
# for each data argument (See Example plot)
# Please use style 01A and id = 1436


  
  
  














# ggplot() + 
#   geom_point(data = filter(.data = bjcp, CatNumber == "01A"), 
#              aes(x = `ABV min`, y = 0), size = 5) +
#   geom_point(data = filter(.data = bjcp, CatNumber == "01A"), 
#              aes(x = `ABV max`, y = 0), size = 5) +
#   geom_point(data = filter(.data = beer, id == 1436), 
#                           aes(x = abv, y = 0, color = CatNumber), pch = 3, size = 5) +
#   xlim(0, 13) +
#   ylim(-0.1, 0.1)


# Make a pie chart of beers by category
ggplot(data = beer, mapping = aes(x = factor(1), fill = factor(BaseCat))) +
  geom_bar() +
  coord_polar(theta = "y") +
  theme(panel.background = element_rect(fill = "white", colour = "black")) + # Get rid of grey background
  theme(axis.text.x = element_text(size = 9, angle = 90) ) +
  labs(x = "BJCP Style")



