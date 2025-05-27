
labor_actions <- read.csv("data/annual_actions_panel.csv")
bls <- read.csv("data/annual_bls_panel.csv")
cpi <- read.csv("data/cpi/annual_cpi_adjusted.csv")

model_panel <- labor_actions |>
  left_join(bls, by = c("sector", "state", "year")) |>
  left_join(cpi, by = c("state", "year"))

write.csv(model_panel, "data/model_panel.csv")
