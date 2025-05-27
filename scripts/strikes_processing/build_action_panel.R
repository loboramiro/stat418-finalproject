library(tidyverse)
library(lubridate)

strikes_df <- read.csv("data/strikes/strikes_clean.csv")

#add indicator columns for labor actions
strikes_df <- strikes_df |>
  mutate(
    start_date = as.Date(start_date),
    
    strike_occurred = if_else(str_detect(action_type, "Strike"), 1, 0),
    protest_occurred = if_else(str_detect(action_type, "Protest"), 1, 0)
  )

actions <- strikes_df |>
  group_by(sector, state, year, month) |>
  summarise(
    strike_count = sum(strike_occurred),
    protest_count = sum(protest_occurred),
    action_occurred = 1,
    strike_occurred = max(strike_occurred),
    protest_occurred = max(protest_occurred),
    .groups= "drop"
  )

#sequence of dates for modeling dataset
start_date <- as.Date("2021-01-01")
end_date <- as.Date("2026-05-31")

month_sequence <- seq(from = floor_date(start_date, "month"),
                      to = floor_date(end_date, "month"),
                      by = "month")


#unique sectors and states
sectors <- unique(strikes_df$sector)
states <- unique(strikes_df$state)

#create dataframe with all sector, state, month combinations for modeling
strike_panel <- crossing(
  sector = sectors,
  state = states, 
  month_year = month_sequence
)

strike_panel <- strike_panel |>
  mutate(month = month(month_year),
         year = year(month_year))

#merge action with dates
#fill in with zeros where labor actions did not occur

#strikes broken down by month
monthly_strikes <- strike_panel |>
  left_join(actions, by = c("sector", "state", "year", "month")) |>
  mutate(
    strike_count = replace_na(strike_count, 0),
    protest_count = replace_na(protest_count, 0),
    action_occurred = replace_na(action_occurred, 0),
    strike_occurred = replace_na(strike_occurred, 0),
    protest_occurred = replace_na(protest_occurred, 0)
  )

#strikes broken by sector, state, and year
annual_strikes <- monthly_strikes |>
  group_by(sector, state, year) |>
  summarise(
    action_occurred = as.integer(any(action_occurred == 1)),
    protest_occurred = as.integer(any(protest_occurred == 1)),
    strike_occurred = as.integer(any(strike_occurred == 1)),
    total_strikes = sum(strike_count, na.rm = TRUE),
    total_protests = sum(protest_count, na.rm = TRUE),
    total_actions = total_strikes + total_protests,
    .groups = "drop"
  )

write.csv(annual_strikes, "data/annual_actions_panel.csv")
