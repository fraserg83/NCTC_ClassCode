require(tidyverse)
require(readxl)
require(data.table)
require(plotly)
require(shiny)
require(shinythemes)
require(sf)
require(mapview)

# ---- Get the data ----
#setwd("C:/Users/salbeke/Dropbox/shannon/Work_Temp/NCTC_DataWrangling/DataWrangling/EricData")
#setwd("./BeerExercise")

# Get styles
bjcp<- data.frame(read_excel("BJCP_2015.xlsx", sheet = "Styles"))
bjcp<- mutate(.data = bjcp, 
              ABV.min = as.numeric(ABV.min),
              ABV.max = as.numeric(ABV.max),
              SRM.min = as.numeric(SRM.min),
              SRM.max = as.numeric(SRM.max))

# Get the breweries
brew<- fread("breweries.txt", header = TRUE, sep = "\t", stringsAsFactors = FALSE)

# fread is fantastic, it can read in data 10x FASTER! Wonderful for larger datasets
beer<- fread("beers.csv", header = TRUE, sep = ",")
# Notice anything funny about ABV? Change from proportion to percent
beer$abv<- beer$abv * 100
# Add new new column that pastes beer name and ID together
beer$Combo<- paste(beer$name, beer$id, sep = " - ")

# I have already performed the above task of editing the table, so let's read it in
xref<- read_excel("BeerToCategory.xlsx", sheet = "Sheet1")
# You will notice that the category is two digits, and one alpha. 
# Let's create a new column of just the 'base style', so the two digit side
xref$BaseCat<- substr(xref$CatNumber, start = 1, stop = 2)

# Given the xref table, let's simply attribute beers with the bjcp category
beer<- left_join(x = beer, y = xref, by = c("style" = "Style"))
# Now attach the brewery name to each row
beer<- left_join(x = beer, y = brew[, c("brewery_id", "brewery_name")], by = "brewery_id")

# make Breweries spatial
brew<- st_as_sf(brew, coords = c("lon", "lat"), crs = "+init=epsg:4326")

# ---- User Interface ----
# 1) Create a drop down of the Commercial beers
# 2) Create a plot of where the beer falls within BJCP guidelines
# 3) Create a plot of the proportion of beers the brewery makes by style
ui <- fluidPage(theme = shinytheme("lumen"),
                titlePanel("The Beers of American Breweries"),
                # In the side bar, we have a smaller side bar and a main panel
                sidebarLayout(
                  sidebarPanel(
                  # Create dropdown for selecting a commercial brewery
                  selectInput(inputId = "brewery", label = strong("Select a Brewery!"),
                              choices = unique(beer$brewery_name),
                              selected = 1),  #Close select brewery
                  # Create a second dropdown to select the beer from the selected brewery
                  uiOutput(outputId = "beerid")
                              ), # Close sidebarPanel
                
                # Output: Point plot, pie chart, bjcp metrics
                              mainPanel(htmlOutput("selected_beer"),
                                        plotlyOutput(outputId = "abvpt", height = "200px"),
                                        #leafletOutput("mapplot"),
                                        #mapview:::plainViewOutput("test"),
                                        plotOutput(outputId = "beerpie")
                                        ) # close mainPanel
                              ) # Close sidebarLayout
                
                ) # Close fluidPage

# ---- Server Functions ----
server<- function(input, output){
  
  
  # Get the beers brewed by the brewery
  allbeer<- reactive({
    filter(.data = beer, brewery_name == input$brewery)
  })
  output$beerid <- renderUI({
    # Create and populate the list of beers brewed by the brewery
    selectInput(inputId = "beeridvalue", label = strong("Beers Offered"),
                choices = select(allbeer(), Combo)) # Close select species
    
  }) # Close renderUI
  
  # Get the selected beer
  thebeer <- reactive(input$beeridvalue)
  
  #Subset data
  mybeer <- reactive({
    # Use structural programming to filter our dataset by the two dropdown box values
    beer %>%
      filter(id == strsplit(thebeer(), " - ")[[1]][2])
  }) # Close selected_beer
  
  
  selected_style <- reactive({
    bjcp %>% filter(CatNumber == mybeer()$CatNumber)
  }) # Close selected_style

  # Create the pie chart of beer by category
  output$beerpie<- renderPlot({ggplot(data = allbeer(), mapping = aes(x = factor(1), fill = factor(CatNumber))) +
    geom_bar() +
    coord_polar(theta = "y") +
    theme(panel.background = element_rect(fill = "white", colour = "black")) + # Get rid of grey background
    theme(axis.text.x = element_text(size = 9, angle = 90) ) +
    labs(x = "BJCP Style")
  })
  
  # Create the beer abv style plot
  output$abvpt<- renderPlotly({
    ggplot() +
    geom_point(data = selected_style(),
               aes(x = ABV.min, y = 0), size = 5) +
    geom_point(data = selected_style(),
               aes(x = ABV.max, y = 0), size = 5) +
    geom_point(data = mybeer(),
               aes(x = abv, y = 0, color = CatNumber), pch = 3, size = 5) +
    xlim(0, 13) +
    ylim(-0.1, 0.1)
  })
  
  # Paste together the beer data
  output$selected_beer <- renderText(paste(
                                        tags$b("Beer Name:"), mybeer()$name, tags$br(),
                                        tags$b("Brewery Style:"), mybeer()$style, tags$br(),
                                        tags$b("BJCP Style:"), paste(selected_style()$Styles, selected_style()$CatNumber, sep = " - "), tags$br(),
                                        tags$b("BJCP Overall Impression:"), selected_style()$Overall.Impression, tags$br(),
                                        tags$b("BJCP Aroma:"), selected_style()$Aroma, tags$br(),
                                        tags$b("BJCP Appearance:"), selected_style()$Appearance, tags$br(),
                                        tags$b("BJCP Flavor:"), selected_style()$Flavor, tags$br(),
                                        tags$b("BJCP Mouthfeel:"), selected_style()$Mouthfeel, tags$br()
                                        )
                                     )
  
#   # Create the map
#   selected_brewery <- reactive({
#     brew %>% filter(brewery_name == input$brewery)
#   }) # Close selected_brewery
# 
#   m<- reactive({mapview(selected_brewery())})
# 
#   output$mapplot <- renderLeaflet({
#     m@map
#   })
#   
} # Close sever function

# ---- Create the Application ----
shinyApp(ui = ui, server = server) 

