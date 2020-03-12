# Intro to R: Common Commands
# author: Shannon E. Albeke
# date: September, 2019

# Examples of common, useful commands in R.

# Commands are usually issued in the form of FUNCTIONS in R.
# Functions are called by entering the name of the function, 
# followed by parentheses.  Some functions have arguments, 
# which are specified within the parentheses.

# Getting help
# A web-based set of help pages
help.start()

# Show details of a function
# We will go over what a function is and how to
# know what the arguments are.
help(mean)

# A short cut to do the same thing
?mean

# OR, my favorite, hit F1 while your cursor is within the function name, try it!
mean

# Gives a list of functions involving the word "mean"
help.search("mean")

# A short cut to do the same thing. The ?? utility can handle misspelled words.
??mean

# Run the examples from the help page
example(mean)

# To see current working directory
getwd()

# To change or set your working directory
setwd("J:/salbeke")
getwd()

# To list user-defined objects and functions 
ls()
# or
objects()

# To remove a variable from the workspace
x <- "hello world"
x
rm(x)
x

# or to remove ALL variables from the workspace. You can also do this by clicking the "broom" button
rm(list=ls())

# Exploring data
x <- data.frame(seq(1,50, by=1.5), seq(1, 185, by=5.6))

# Change the names of the columns
names(x) <- c("speed", "distance")

# change just the second column name
names(x)[2]<- "Distance"

# Determining the class/type of an object
class(x)
class(x$speed)

# Finding the structure of an object
str(x)

# Quick view of the data (without printing thousands of lines)
head(x)
head(x, 3)
tail(x)

# Finding the dimensions of an object (rows,columns). Works for multi-dimensional objects. 
dim(x)
 
# For vectors, use length().
length(x$speed)

# These come in handy if needing to parse through each row or column in its entirety
ncol(x)
nrow(x)

# Sorting
y <- sample(100:250, size = 20, replace = FALSE)
y
# Orders the values in ascending order. This is great for a single vector, but if part of a data.frame, this may cause problems becasue it does not deal with position (i.e. row number)
sort(y)
sort(y , decreasing = TRUE)

# This function simply reverses the order of the values in the vector
rev(y)

# Order is different, in this case order provide the indices. Using this we could reorder an entire data.frame, not just one column
order(y)
y[order(y)]

# Or you can reverse it
order(y, decreasing = TRUE)
y[order(y, decreasing = TRUE)]


# Matching
# Find position of maximum/minimum value in a vector. which always returns a position/index via TRUE/FALSE
which.max(y)
which(y == max(y))

which.min(y)

# Find positions of values in y that are also in x$speed (logical vector)
y %in% x$speed

# Some math
mean(x$speed)
max(x$speed)
min(x$distance)
range(x$distance)

# you can apply the math across all columns, probably better in a matrix for this stuff
x / 10

# Quick summary
summary(x)


# Subsetting
# Let's create a different data.frame to gain experience in filtering rows of data
df<- data.frame(BeerStyle = c("American Lager", "IPA", "Saison", "Trappist Single", "Stout", "Specialty"),
                ABV = c(4.5, 7.2, 6.4, 5.9, 6.8, NA),
                SRM = c(3, 15, 12, 8, 190, NA),
                Flavor = c(NA, "Great", "Happy", "Favorite", "Roasty", "WTF"))

# We can select specific rows given column values. We can use a function
subset(df, df$ABV >= 6)

# Or we can perform this in a more traditional base R method..we will learn tidyverse method later
df[which(df$ABV >= 6),]

df$SRM < 15

# Sometimes it's important for find rows that have NA's
is.na(df$ABV)
which(is.na(df$ABV))

# Are there any NA
any(is.na(df$ABV))

# Are all values NA
all(is.na(df$ABV))

# Remove any rows that have an NA
na.omit(df)



