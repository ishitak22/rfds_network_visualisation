library(tidyverse)
library(shiny)
library(leaflet)

location_summary <- read.csv("data/finaldataset.csv")

ui <- fluidPage(
  titlePanel("RFDS Bases across Australia - July 2022"),
  
  sidebarPanel(
    sidebarLayout(
      selectInput("aircraft", "Select Aircraft Type:",
                  choices = c("All", unique(location_summary$AircraftId))),
      width = 3
    ),
  
 mainPanel(      
  leafletOutput("map", width = "100%", height = "700px"),

  p("This map shows Royal Flying Doctor Service (RFDS) bases where flights occurred in July 2022"),
  p("Select an aircraft type from the dropdown to explore related RFDS base locations."),
  width = 9
)
)
)

server <- function(input, output, session) {
  
  filtered_data <- reactive({
    if (input$aircraft == "All") {
      location_summary
    } else {
      location_summary %>% filter(AircraftId == input$aircraft)
    }
  })
  
  output$map <- renderLeaflet({
    leaflet(data = filtered_data()) %>%
      addTiles() %>%
      addMarkers(
        lng = ~Longitude,
        lat = ~Latitude,
        label = ~as.character(Location),
        popup = ~paste("Base Location:", Location,
                       "<br>Aircraft:", AircratId,
                       "<br>Destination:", Destination)
      ) %>%
      setView(lng = 134, lat = -25, zoom = 4)
  })
}

shinyApp(ui = ui, server = server)