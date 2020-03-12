require(tidyverse)
require(readxl)

# Let's read in a tab-delimited file. I'm starting to like the readr package, it's smarter than base R and saves us some time with column data types
met<- read_delim("WRIR_WeatherStation.txt", delim = "\t")

# Using ggplot is pretty easy once you get down syntax and understand that once you have the data into the plot, it is just a matter of how you want to represent that data. ggplot also prefers vertical/long data over wide data, so keep that in mind.

# The components of ggplot are the 1) The Data (this is where you state what data.frame, which values are the x and y axis, and this may include grouping variables), 2) The Representation, (i.e. how do you want to represent the data, a boxplot, a line plot, a barchart), 3) The Facet (i.e. do you want multiple plots based on some grouping variable?)

# Let's start with something very simple. We can do this multiple ways, one way is to create new objects, a second way is to use piping....this choice always depends on what you wish to accomplish. There is no wrong/right way when making these choices, just what makes your workflow more simple or easy for you to use. This is fo ryou to learn and become comfortable with, so you do things that make sense to you, as you gain experience you will certainly become more efficient in how you write your code

# Filter the data to only have 1 site. 
site1<- met %>% 
  filter(SiteID == "ASWW4")

# Make a line plot, so set the data to use, the aes() is used to set x, y axes and grouping variables)
ggplot(data = site1, aes(x = Samp_Date, y = AirTemperature_C)) +
  # Now set how you want to represent this data, it will always begin with geom_  ....notice we use a + symbol to 'add' a layer of representation
  geom_line()

# Now let's plot both sites simultaneously, so we have to provide a grouping variable
met %>% 
  ggplot(aes(x = Samp_Date, y = AirTemperature_C, group = SiteID, color = SiteID)) +
  geom_line() +
  geom_point()

# How about we plot the same data for both sites, but each site get's its own plot. This is call facetting and we can adjust the way in which we group the data
met %>% 
  ggplot(aes(x = Samp_Date, y = AirTemperature_C)) +
  geom_line() + 
  facet_wrap(. ~ SiteID)

# Let't do the exact same plot, but change some of the properties of the plot to be more to our liking....every aspect of the plot is customizable, so if you don't like something, you just need to figure out what property to change. Each portion of the plot is linked to an 'element'. So we will have to set properties of elements...like this example where we get rid of the grey background and tick marks by adjust properties of the 'plot theme'
met %>% 
  ggplot(aes(x = Samp_Date, y = AirTemperature_C)) +
  geom_line() + 
  theme(panel.grid = element_blank(), panel.background = element_blank(), panel.border = element_rect(color = "black", fill = NA, size = 1)) +
  facet_wrap(. ~ SiteID)

met %>% 
  ggplot(aes(x = Samp_Date, y = AirTemperature_C)) +
  geom_line() + 
  theme(panel.grid = element_blank(), panel.background = element_blank(),) +
  facet_wrap(. ~ SiteID)

#So we need to save our plots to disk
ggsave(filename = "TestPlot.png", width = 4, height = 3, units = "in", dpi = 600, limitsize = FALSE)

# So we have options for how we want to present the data, but really it comes down to you deciding what you want to present, and that often is driven by what data you pass to the plot. Let's practice changing the data to tell a slightly different story.

# Challenge #1 ! I would like a line plot of both sites with daily mean values for each day within the year 2018. You will use mutate, lubridate, group_by, summarise and ggplot (with geom_line). Use the Google for help!! So imagine what the data.frame must have in it to produce this plot (e.g. SiteID, Day of year, Mean Temp)



# Challenge #2 Add error bars (95% CI = SE * 1.96) to the above plot (geom_errorbar and you ahve to have the confidence interval as part of your summarise)


# Challenge #3 Procduce a bar chart of monthly averages, with 95% CI for all of the data. This might take a little 'trickery' about the month/year combination so that you can have multiple years on the same plot