library(dplyr)

#load labor action information, BLS, and adjusted CPI data
labor_actions <- read.csv("data/annual_actions_panel.csv")
bls <- read.csv("data/annual_bls_panel.csv")
cpi <- read.csv("data/cpi/annual_cpi_adjusted.csv")


model_panel <- labor_actions |>
  left_join(bls, by = c("sector", "state", "year")) |>
  left_join(cpi, by = c("state", "year"))

model_panel <- model_panel |>
  select(
    action_occurred,
    state, sector, year,
    all_employees, state_unempl_rate, state_labor_force, state_labor_part, 
    adjusted_cpi)

#check NAs
colSums(is.na(model_panel))
panel_NAs <- model_panel |> filter(is.na(all_employees) | 
                                     is.na(state_unempl_rate) |
                                     is.na(state_labor_force) | 
                                     is.na(state_labor_part))

# missing data for Construction and Mining/Logging Delaware, DC, and Hawaii

write.csv(model_panel, "data/model_panel.csv")
