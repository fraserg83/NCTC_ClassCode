## Eric Kelchlin
## March 2019
## Exercise 2 - Tidy Data

## Load the required packages ##
# You can use require() or library() to load a package

require(tidyverse)  # to wrangle data
require(readxl)     # to import excel sheets
require(here)       # to help with file managment


## Task 1.1 - Import and view the data ##

here()

Ibis <- read_excel("Ibis_Data.xlsx", sheet = "Ibis_Data")

# What if we had a spreadsheet with a couple lines that we wanted to skip or perhaps a specific range of cells that we only wanted to read-in?  Use the help on the `read_excel()` function to see if it's possible. Do this by simply clicking *F1* while your cursur is on the function name.

## View the Data ##

glimpse(Ibis) # cleaner than the structure function `str(Ibis)`

names(Ibis)   # my name is, my name is...

head(Ibis, n = 5)


## Task 1.2 - Convert the table from a wide to a long format ##

# gather() function template...

# new object <- data %>%
  # gather(key = , value = , columns to gather, other arguments)

new_object <- Ibis %>%  # Here's a start
  gather(key = , value = , ,convert = TRUE)


## Task 1.3 - There are two other ways to identify the the fields to gather in this example. Can you figure this out?  Tip: one way is to identify what not to gather and the other identifies the columns by location.


## Task 1.4 - The `spread()` function restructures the long format to a wide format.  Use this function to return our gathered dataset back into the orignal format.  This one is easier than the gather function.


# spread() template...

# newobject <- data %>%
  # spread(key = column to pivot, value = column with the values)


## Task 1.5 - Export the Data. Run the line below to easily export the data as a .csv file. Find the `write_?` function from the readr package to export the data as a comma delimited (" ") .txt file.

write_csv(Ibis2, here("IbisClean.csv"))


## Task 1.6 - Independent Exercise ###

# 1.  Use the `read_csv()` function to import the Sage Grouse Data.csv dataset.  Assign the data into a new object called Sage

# 2.  Examine the data.  How many Observations and variables do we have? What are the variable names?  What data type are the 4 date fields and what should they be?

# 3. We have multiple observational units combined in one table. How many do you think we have?

# 4.  Some variables are in wide format (i.e., observations), can you pick them out?


## Task 1.7 - Class Exercise ##

# Question: What is the maximum count of male and female sage grouse per lek?

# To answer this question, we'll need to use the `select()`, `group_by()` and `summarise()`functions from the dplyr package.  This is a great introduction of what we will be learning more of tomorrow.

## Steps:

# 1. Select only the variables you need using the `select()` function.

# 2. Gather the FieldResults fields into a long format using the `gather()` function.  Use the `na.rm = TRUE` argument to remove the cells with missing values.

# 3. Seperate the field with the data using the `seperate()` function

# 4. Use the `group_by()` and `summarise()`functions to calculate the maximum number of sage grouse per lek.  Note:  `summarise()` is finiky to missing values, that's why we need to filter them out first. Alternatively, you could just use add `na.rm = TRUE` at the end of the `summarise( )` as well.

