# Intro to R: Object Types
# author: Shannon E. Albeke
# date: September, 2019

#### REMARKS ####

# Everything in R is an object.

# The assignment operator '<-' is traditionally used to store objects as variables; however "=" will also work.

# R is case sensitive.

# In R, variable names may NOT start with a number.

# Take care not to use c, t, cat, F, T, or D as variable names.  Those are reserved by R.

# Vectors and Data Frames are the most common object types we will use in R to start.


#### BASIC OBJECT TYPES ####

# VECTORS - The basic data object in R.
# A vector is a one-dimensional array of arbitrary length.

# VECTOR TYPES - all elements in a vector must be of the same type.
# Strangely, you can think of a vector as being similar to a column of data in a table

# Numbers (integers, float, double). We can do math with numbers!
num <- 4 # Vector is of length 1 (i.e. 1 value inside this vector)
num

# ***Note that R is case sensitive:
num <- 4
# is NOT the same as....so be sure to create your own style of naming variables, it will help you with debugging when an error inevitably occurs
Num <- 10

# **Also, note that variable names may NOT start with a number:
# NOT OK
1num <- 5
# This works
num1 <- 5

# Can do mathematical operations to numbers
# multiply, divide, add, subtract, exponents
num * 5
num / 2
num + 8
num - 1
num^8

# Character, string, text
string <- "hello world" 

# What is the length of this character vector?
length(string)

# How many characters?
nchar(string)

# Numbers represented as character
Num <- "10"

# You can't perform math with a character
Num * 5

# However, you can convert from one data type to another
as.integer(Num) * 5

# Logical - Notice it is all caps for TRUE and the text color is different
logic <- TRUE
logic

#  logical test - boolean. Here we are using operators. This is the crux of how we find information with data.frames (R version of tables) or vectors or just testing if we have the right type of object
# == means equal to
# != not equal to
# >= greater than or equal to
# <= leass than or equal to
# x %in% y within comparator (super useful for queries of your data)
# !x %in% y not within comparator

logic == FALSE
logic != F # Please don't use the abbreviation of TRUE/FALSE, it works but is harder to debug when your code gets more complex
logic == T

# Vectors can be lists of like values (numbers, characters, logical, etc.)
# The ":" creates sequences that increment/decrement by 1, so an integer data type (whole numbers).
x <- 1:10
# How many values?
length(x)

# You can go backwards!
x <- 1:-10
length(x)

# Use "c" to "combine" or "concatenate" values. What is the data type? Why? R will default to the simplest form so no data will be lost
x <- c(2, 4, 6, 8)

# Instead of manually typing, you can use "seq" to create a sequence.
x <- seq(from = 2, to = 8, by = 2)

# What is the object type for this vector? Recall R will default to the simplest form
y <- c("R", "stats", "for", "the", "win", 12, 15)

# Can do mathematical operations on vectors. This is key for efficiency!
x * 10

# Factors - this is a necessary data type for fitting models when you have categorical values.
days <- c("sunday", "monday", "wednesday", "friday", "saturday","tuesday", "sunday","wednesday", "thursday", "friday", "saturday")
# Coerce character to a factor
days1<- as.factor(days)
days1

# But what is really being stored are integers representing each category, you can see this by coercing to an integer
as.integer(days1)

# Note that the days are not in order. The table function is great for getting counts of unique values within a vector
table(days1)

# But we know days happen in a certain order, and we can enforce that order.
oDays <- ordered(days, levels=c("sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"))
table(oDays)


# DATA FRAMES - Most data will be stored in data frames, rectangular arrays that are usually formed by combining vectors (columns). Data frames, as opposed to matrices, can contain vectors of different types. Data frames are LIKE your typical spreadsheet or database table.

# Constructing data frames from scratch, just as an example. However, the vast majority of the time you will be getting data frames from existing data in a text file, spreadsheet or database
x <- seq(from = 1, to = 10, length = 20)
length(x)

y <- rep(c("a", "b", "c", "d"), times = 5) 
length(y)

# Construct the data frame from the two vectors (i.e. columns). Because they are the same length, you will not have any unforeseen repetitions of data within a row. Each value within a vector is a row. You can also name your columns for each vector
myDF<- data.frame(numbers = x, letters = y, stringsAsFactors = FALSE)

# Nice thing here is we can visually investigate this data.frame. You can do this in two different methods, either click on the object within the environment OR use the following function:
View(myDF)

# Data frames are in the following structure df[rows, cols]. Grab data by index:

# First column is returned as a vector! Vectors are columns, columns can be created from vectors
myDF[, 1]

# First row of the data frame
myDF[1, ]
myDF[9, ]

# Get a particular value
myDF[3, 2]

# Indexes are great! However, they can sometimes be harder to interpret for folks, so use column names instead!
myDF$numbers
myDF$letters

# Get a specific row and column. Use column name and row number
myDF$numbers[5]

# Often times we need to add new columns, this is simple to do in base R
myDF$newCol <- log(myDF$numbers)
myDF$mathCol<- myDF$numbers / myDF$newCol

# Simple statistics of a data frame
summary(myDF)

# If you don't want a column any longer, you can remove it
myDF$mathCol<- NULL


# LISTS - Lists are generic vectors.  Lists contain elements, each of which can contain any type of R object (i.e. the elements) of a list do not have to be of the same type. Data frames are the most common list object, where all of the elements have the same length but can be of different data types

# Here is an example of a list that contains 3 different classes: numbers, matrix, and even a function.
myList <- list(a = 1:4, b = 1:3, c = matrix(1:4, nrow = 2), d = sd)
myList

# What class is object myList?
class(myList)

# We can access pieces of a list in multiple ways, index and name (if names exist)
myList[[1]]
myList$a
myList$c

# What classes are the individual elements in complicated.list? The "apply" group of functions operates nicely on lists (and other objects) to apply a function to each element in the list. 
lapply(myList, class)

