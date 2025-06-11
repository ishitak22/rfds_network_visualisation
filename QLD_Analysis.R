library(tidyverse)
library(readr)
library(lubridate)
library(ggplot2)
library(shiny)

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

location_summary <- read_csv("data/finaldataset.csv")

# Filter to QLD bases

d3 <- location_summary %>% filter(Destination %in% c(
  "Brisbane (BNE / YBBN)", "Bundaberg (BDB / YBUD)", "Cairns (CNS / YBCS)", 
  "Charleville (CTL / YBCV)", "Longreach (YLRE)", "Mount Isa (ISA / YBMA)",
  "Rockhampton (ROK / YBRK)", "Roma (RMA / YROM)", "Townsville (TSV / YBTL)"
))

# Creating day and night labels

new <- d3 %>%
  group_by(Destination, AircraftId, ArrivalAEST) %>%
  count()

new$Timeoftheday <- ifelse(new$ArrivalAEST >= hms("06:00:00") & new$ArrivalAEST < hms("18:00:00"), "Day", "Night")

#Bar Chart

VIZ1 <- ggplot(new, aes(x = Destination, fill = Timeoftheday)) +
  geom_bar() +
  scale_fill_discrete(labels = c("Day Time (6am–6pm)", "Night Time (6pm–6am)")) +
  theme_minimal(base_size = 13) +
  labs(
    title = "RFDS Flight Arrivals by Time of Day",
    x = "Destination",
    y = "Number of Flights",
    fill = "Time of the day"
  ) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    legend.title = element_text(face = "bold")
  )

print(VIZ1)

ggsave("outputs/rfds_arrivals_by_daytime.png", VIZ1, width = 11, height = 6.5)
