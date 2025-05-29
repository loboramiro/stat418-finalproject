library(tidyverse)
library(lubridate)

strikes_df <- read.csv("data/strikes/strikes_raw.csv")

#clean repeated state names
strikes_df <- strikes_df |>
  mutate(
    state = case_match(state,
                       "Washington DC" ~ "District of Columbia",
                       "NY" ~ "New York",
                       .default =  state
  ))

#drop US territories
strikes_df <- strikes_df |> 
  filter(!state %in% c("Puerto Rico", 
                       "Guam", 
                       "U.S. Virgin Islands"))


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

#clean labor action data for modeling
strikes_clean <- strikes_df |>
  select(state, sector, industry, start_date, month, year, action_type)

write.csv(strikes_clean, "data/strikes/strikes_clean.csv")

# more detailed labor action data to display in shiny app
strikes_detailed <- strikes_df |>
  select(city, state, sector, industry, start_date, duration, employer, 
         labor_org, action_type, demands) |>
  arrange(desc(start_date))

write.csv(strikes_detailed, "data/strikes/strikes_detailed.csv")


