library(tidyverse)
library(readr)
library(lubridate)


# Load raw data
flight_summary <- read_csv("data/RFDS_flightdata_July2022.csv")
bases <- read_csv("data/RFDS_bases.csv")

# Looking at dataset
glimpse(flight_summary)
glimpse(bases)

# Splitting origin and joining it with base dataset

df <- strsplit(flight_summary$Origin, " ")
a <- lapply(df, function(x) x[1])
flight_split <- mutate(flight_summary, location = a)
location_summary <- merge(x = bases, y = flight_split, by.x = c("Location"), by.y = c("location"))

write_csv(location_summary, "data/finaldataset.csv")

# Filter to QLD bases

d3 <- location_summary %>% filter(Destination %in% c(
  "Brisbane (BNE / YBBN)", "Bundaberg (BDB / YBUD)", "Cairns (CNS / YBCS)", 
  "Charleville (CTL / YBCV)", "Longreach (YLRE)", "Mount Isa (ISA / YBMA)",
  "Rockhampton (ROK / YBRK)", "Roma (RMA / YROM)", "Townsville (TSV / YBTL)"
))