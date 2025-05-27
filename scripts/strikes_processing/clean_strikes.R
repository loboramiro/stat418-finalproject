library(tidyverse)
library(lubridate)

strikes_df <- read.csv("data/strikes_raw.csv")

#clean repeated state names
strikes_df <- strikes_df |>
  mutate(
    state = case_match(state,
                       "Washington DC" ~ "District of Columbia",
                       "NY" ~ "New York",
                       .default =  state
  ))

#add month and date columns
strikes_df <- strikes_df |> 
  mutate(year = year(start_date), 
         month = month(start_date),
         start_date = as.Date(start_date),
         end_date = as.Date(end_date))


#map industries to BLS sectors
industry_map <- tribble(
  ~industry, ~sector,
  "Manufacturing", "Manufacturing",
  "Construction", "Construction",
  "Wholesale Trade", "Trade, Transportation, and Utilities",
  "Retail Trade", "Trade, Transportation, and Utilities",
  "Transportation and Warehousing", "Trade, Transportation, and Utilities",
  "Utilities", "Trade, Transportation, and Utilities",
  "Accommodation and Food Services", "Leisure and Hospitality",
  "Arts, Entertainment and Recreation", "Leisure and Hospitality",
  "Information", "Information",
  "Educational Services", "Education and Health Services",
  "Health Care and Social Assistance", "Education and Health Services",
  "Professional, Scientific and Technical Services", 
  "Professional and Business Services",
  "Administrative and Support and Waste Management", 
  "Professional and Business Services",
  "Finance and Insurance", "Financial Activities",
  "Real Estate and Rental and Leasing", "Financial Activities",
  "Public Administration", "Government",
  "Mining", "Mining and Logging",
  "Agriculture, Forestry, Fishing & Hunting", "Other Services",
  "Other Services (except Public Administration)", "Other Services"
)

#add sector to strike dataframe
strikes_df <- strikes_df |>
  inner_join(industry_map, by= "industry")

#select
strikes_clean <- strikes_df |>
  select(state, sector, industry, start_date, month, year, action_type)

write.csv(strikes_clean, "data/strikes_clean.csv")

