library(tidyverse)
library(shiny)
library(leaflet)

location_summary <- read.csv("data/finaldataset.csv")

ui <- fluidPage(
  titlePanel("RFDS Bases across Australia - July 2022"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("aircraft", "Select Aircraft Type:",
                  choices = c("All", unique(location_summary$AircraftId))),
      width = 3
    ),
  
 mainPanel(      
  leafletOutput("map", width = "100%", height = "700px"),

  p("This map shows Royal Flying Doctor Service (RFDS) bases where flights occurred in July 2022"),
  p("Select an aircraft type from the dropdown to explore related RFDS base locations."),
  DT::dataTableOutput("flight_table"),
  width = 9
)
)
)

server <- function(input, output, session) {
  
  filtered_data <- reactive({
    if (input$aircraft == "All") {
      df <- location_summary
    } else {
      df <- location_summary %>% filter(AircraftId == input$aircraft)
    }
    
    base_counts <- df %>%
      group_by(Location, Longitude, Latitude) %>%
      summarise(flight_count = n(), .groups = "drop")
    
    df <- left_join(df, base_counts, by = c("Location", "Longitude", "Latitude"))
    df
  })
  
  output$map <- renderLeaflet({
    leaflet(data = filtered_data()) %>%
      addTiles() %>%
      addCircleMarkers(
        lng = ~Longitude,
        lat = ~Latitude,
        radius = ~log1p(flight_count) * 4,
        stroke = FALSE,
        fillColor = "steelblue",
        fillOpacity = 0.7,
        label = ~as.character(Location),
        popup = ~paste("Base Location:", Location,
                       "<br>Flights:", flight_count,
                       "<br>Aircraft:", AircraftId,
                       "<br>Destination:", Destination)
      ) %>%
      setView(lng = 134, lat = -25, zoom = 4)
  })
  
  output$flight_table <- DT::renderDataTable({
    filtered_data() %>%
      group_by(AircraftId, Location) %>%
      summarise(Flights = n(), .groups = "drop")
  })
 
}

shinyApp(ui = ui, server = server)