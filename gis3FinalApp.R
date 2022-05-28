# set wd, load libraries, load data
setwd("~/Desktop/gisFinal")
library(sf)
library(shiny)
library(rgdal)
library(rgeos)
library(tmap)
library(leaflet)
library(plotly)
chiZips <- read_sf("/Users/zackwoods01/Desktop/gisFinal/finalZips/chiZipsFinal.shp")
chiPinkZips <- read_sf("/Users/zackwoods01/Desktop/gisFinal/finalZips/chiZipsPink.shp")
chiPinkLine <- read_sf("/Users/zackwoods01/Desktop/gisFinal/rails/pinkRail.shp")

# Define UI for random distribution app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Chicago TOD Gentrification Explorer - Pink Line"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      h3("Select variable"),
      helpText("Create an interactive map of Chicago"),
      selectInput("Census_var", 
                  label = "Choose a variable to display",
                  choices = list("Percent change in total home ownership", 
                                 "Percent change in total white home ownership", 
                                 "Percent change in total black home ownerhsip",
                                 "Percent change in total home rentership",
                                 "Percent change in total white home rentership",
                                 "Percent change in total black home rentership"),
                  selected = "Percent change in total home ownership"),
      h4("About"),
      p("The purpose of this data explorer is to explore the displacement of black renters and homeowners by an influx of new, white residents following the opening of the Pink Line in 2006.")),
    
    # Main panel for displaying outputs ----
    mainPanel(
      textOutput("selected_var"),
      # Output: Tabset w/ plots, about, data ----
      tabsetPanel(type = "tabs",
                  tabPanel("Chicago", leafletOutput("working_map")),
                  tabPanel("Pink Line Serviced Zips", leafletOutput("working_map_1")),
                  tabPanel("About", includeMarkdown("about.Rmd")),
                  tabPanel("Data", includeMarkdown("data.Rmd"))
      )
    )
  )
)


# Define server logic for random distribution app ----
server <- function(input, output) {
  
  
  output$working_map <- renderLeaflet({
    data <- switch(input$Census_var, 
                   "Percent change in total home ownership" = "pcPO", 
                   "Percent change in total white home ownership" = "pcPOW", 
                   "Percent change in total black home ownerhsip" = "pcPOB",
                   "Percent change in total home rentership" = "pcPR",
                   "Percent change in total white home rentership" = "pcPRW",
                   "Percent change in total black home rentership" = "pcPRB")
    working_map <- tm_shape(chiZips) + tm_fill(data, title=input$Census_var, style="jenks", palette = "BuPu") + tmap_options(max.categories = 10) +
      tm_legend(title = "Chicago - Home Ownership/Rentership Change")
    tmap_leaflet(working_map)
  })
  
  output$working_map_1 <- renderLeaflet({
    data <- switch(input$Census_var, 
                   "Percent change in total home ownership" = "pcPO", 
                   "Percent change in total white home ownership" = "pcPOW", 
                   "Percent change in total black home ownerhsip" = "pcPOB",
                   "Percent change in total home rentership" = "pcPR",
                   "Percent change in total white home rentership" = "pcPRW",
                   "Percent change in total black home rentership" = "pcPRB")
    working_map_1 <- (tm_shape(chiPinkZips) + tm_fill(data, title=input$Census_var, style="jenks", palette = "BuPu") + tmap_options(max.categories = 10) +
      tm_shape(chiPinkLine) + tm_lines(col = 'violet', lwd = 5))
    tmap_leaflet(working_map_1)
  })
}

# Create Shiny app ----
shinyApp(ui, server)
