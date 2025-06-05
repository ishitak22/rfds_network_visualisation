library(tidyverse)
library(readr)


# Load raw data
flight_summary <- read_csv("data/RFDS_flightdata_July2022.csv")
bases <- read_csv("data/RFDS_bases.csv")

# Looking at dataset
glimpse(flight_summary)
glimpse(bases)
