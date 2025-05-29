library(tidyverse)
library(readxl)

# load most recent cpi data downloaded from BLS
# https://www.bls.gov/cpi/data.htm
cpi <- read_xlsx("data/cpi/cpi.xlsx", skip=10)

#remove unneccessary columns
cpi <- cpi |> select(-c(HALF1, HALF2))

#get annual average
months <- select(cpi, -Year)

cpi <- cpi |>
  mutate(annual_avg_cpi = rowMeans(months, na.rm=TRUE)) |>
  select(Year, annual_avg_cpi)

#get regional pricing data from BEA
#https://www.bea.gov/data/prices-inflation/regional-price-parities-state-and-metro-area
rpp <- read.csv("data/cpi/rpp.csv", skip=3)

#get relevant columns
rpp <- rpp[2:52, 2:12]

#clean column names
rpp <- rpp |>
  rename(state = "GeoName")

names(rpp) <- sub('X', "", names(rpp))

#impute 2024 values
rpp$`2024` <- rpp$`2023`
rpp$`2025` <- rpp$`2023`

#pivot rpp longer
rpp_long <- rpp |>
  pivot_longer(
    cols=-state,
    names_to = "Year",
    values_to = "rpp"
  ) |>
  mutate(Year = as.integer(Year))

#adjust annual cpi by state's rpp
cpi_adjusted <- cpi |>
  inner_join(rpp_long, by = c("Year")) |>
  mutate(
    adjusted_cpi = annual_avg_cpi * (rpp/100)
  ) |>
  select(state, Year, adjusted_cpi) |>
  rename(year = "Year")

write.csv(cpi_adjusted, "data/cpi/annual_cpi_adjusted.csv")
