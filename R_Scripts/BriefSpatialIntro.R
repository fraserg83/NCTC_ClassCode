# Let's do some spatial stuff
require(sf)

# Read in the species shapefile
spec<- st_read(dsn = "C:/CSP1004_Albeke/GIS_Data", layer = "Favorite_Species")

mapview(spec)

# Add new column just for kicks
spec<- spec %>%
  mutate(MyCol = "Test") %>%
  select(-MyCol) %>%
  filter(ALPHA == "AF") %>%
  group_by(ALPHA)

# Save changes as shapefile
st_write(spec, dsn = "C:/CSP1004_Albeke/GIS_Data", layer = "OurTest", driver = "ESRI Shapefile", delete_layer = TRUE, update = TRUE)

# Use the open source file geodatabase. It is called GeoPackage
st_write(spec, dsn = "C:/CSP1004_Albeke/GIS_Data/myTest.gpkg", layer = "OurTest", driver = "GPKG", delete_layer = TRUE, update = TRUE)

st_write(spec, dsn = "C:/CSP1004_Albeke/GIS_Data/myTest.gpkg", layer = "OurTest2", driver = "GPKG", delete_layer = TRUE, update = TRUE)

# Let's find out what is inside the geopackage
st_layers(dsn = "C:/CSP1004_Albeke/GIS_Data/myTest.gpkg")



# My first function, this will be easy
C * 9/5 + 32

### This function convert celsius to f
# celsius = numeric value representing temperatur in C
convertToFarenheit <- function(celsius){
  f<- celsius * 9/5 + 32
  return(f)
}


# Use our function
convertToFarenheit(celsius = 5)

# To grab a custom set of code, use source
source("C:/CSP1004_Albeke/R_Scripts/convertToFarenheit.R")


