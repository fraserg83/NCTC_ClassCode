# If you are interested in a versatile, open source database for use in your project, SQLite might be a good solution for you to use. There are a couple of steps that we need to do so that you can create and edit a SQLite DB. What we need is the RSQLite R package (which requires RTools to be installed first) and the SQLite Studio Software.

# It is just good practice to have RTools on any Windows machine that you plan to run R on. So go here to get the installer: https://cran.r-project.org/bin/windows/Rtools/

# Install RSQLite Package. This should bring along with it the needed tools to create and edit SQLite DBs

# Install SQLite Studio by going here: https://github.com/pawelsalawa/sqlitestudio/releases  This is a nice GUI that you can use to manage your data (e.g. create new tables, add/edit rows of data, query information, etc...of course R can do a lot of that as well.)


require(RSQLite)
require(odbc)
require(DBI)
require(readxl)
require(tidyverse)

setwd("C:/CSP1004/CSP1004_Albeke/SQLite_Example")
# Let's build a new SQLite database from scratch. I couldn't figure out how to do this with command line SQLite, so I invoked R for the task.
mydb <- dbConnect(RSQLite::SQLite(), "SQLiteExample.sqlite")

# Read in some temporary data
dat<- read_excel("../Exercise1_RIntro/TidyExampleData.xlsx", sheet = "Animals")

# Write our table to the db
dbWriteTable(mydb, name = "Animals", value = dat)

# Get some data from the database

animal<- dbSendQuery(mydb, "SELECT * FROM Animals ") %>% # WHERE Site = 'Sage 1'
  dbFetch() %>% 
  pivot_longer(cols = Species_1:Species_2, names_to = "SpeciesCode", values_to = "Count")


# Create a new table for species using SQLite Studio

# Now read in the new table
species<- dbSendQuery(mydb, "SELECT * FROM luSpecies") %>% 
  dbFetch()

# Join the data
animal<- animal %>% 
  left_join(species, by = "SpeciesCode")

# Write the long version of animals to db
dbWriteTable(mydb, name = "tblAnimals", value = animal)
