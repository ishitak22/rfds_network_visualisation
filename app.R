library(tidyverse)
library(shiny)
library(leaflet)

location_summary <- read.csv("data/finaldataset.csv")

ui <- fluidPage(
  titlePanel("RFDS Bases across Australia - July 2022"),
  
  leafletOutput("map", width = "100%", height = "700px"),
  
  p("This map shows Royal Flying Doctor Service (RFDS) bases where flights occurred in July 2022"),
  p("Click any marker to see the destination airport name")
)