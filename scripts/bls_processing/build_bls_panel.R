#get BLS data
bls_long <- read.csv("data/bls_series/bls_parsed.csv")

#get metadata
labor_series_meta <- read.csv("data/bls_series/labor_series_ids.csv")
unempl_series_meta <- read.csv("data/bls_series/unempl_series_ids.csv")

all_series_meta <- bind_rows(labor_series_meta, unempl_series_meta)

#monthly BLS data
bls_labeled <- bls_long |>
  left_join(all_series_meta, by = "series_id") |>
  select(sector, state, year, month, metric, value)

#separate unemployment and labor series
unempl_data <- bls_labeled |> 
  filter(metric %in% unempl_series_meta$metric)

labor_data <- bls_labeled |>
  filter(metric %in% labor_series_meta$metric)

#aggregate unemployment to annual averages and pivot wide
unempl_annual <- unempl_data |>
  group_by(state, year, metric) |>
  summarise(annual_average = mean(value), .groups="drop") |>
  pivot_wider(names_from = metric, values_from = annual_average)

#aggregate labor data (with sector) to annual averages and pivot wide
labor_annual <- labor_data |>
  group_by(sector, state, year, metric) |>
  summarise(annual_average = mean(value), .groups="drop") |>
  pivot_wider(names_from = metric, values_from = annual_average)

#join bls annual averages and clean column names
annual_bls_panel <- labor_annual |>
  left_join(unempl_annual, by = c("state", "year")) |>
  mutate(
    state_labor_force = `Labor Force`/1000,
    state_labor_part = `Labor Force Participation Rate`,
    state_unempl_rate = `Unemployment Rate`
  ) |>
  select(-`Labor Force`, -`Labor Force Participation Rate`, -`Unemployment Rate`)


write.csv(annual_bls_panel, "data/annual_bls_panel.csv")
