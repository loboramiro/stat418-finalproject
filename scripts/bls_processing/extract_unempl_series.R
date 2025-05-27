library(tidyverse)
library(janitor)

#table of available BLS data on employment statistics
unempl_series <- read.delim("data/bls_series/la.series")

unempl_series <- unempl_series |>
  filter(area_type_code == 'A') |> #state-level
  #select unemployment rate, total labor force, and labor participation rate
  filter(measure_code %in% c(3, 6, 8)) |>
  filter(seasonal == "U") #seasonally unadjusted

#create state and metric columns
unempl_series <- unempl_series |>
  mutate(metric = str_extract(series_title, "^[^:]+"),
         state = str_extract(series_title, "(?<=: ).+?(?= \\()"))

#create file with api series ids and metadata to download from api
unempl_series <- unempl_series |>
  clean_names() |>
  mutate(series_id = trimws(series_id)) |>
  select(series_id, state, metric) |>
  clean_names()

write.csv(unempl_series, "data/bls_series/unempl_series_ids.csv")
