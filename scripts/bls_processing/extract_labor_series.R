library(tidyverse)

#table of available BLS data on labor statistics
labor_series <- read.delim("data/bls_series/sm.series")

#state fips codes
state_codes <- tibble(
  state = c("Alabama", "Alaska", "Arizona", "Arkansas", "California",
            "Colorado", "Connecticut", "Delaware", "District of Columbia",
            "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana",
            "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland",
            "Massachusetts", "Michigan", "Minnesota", "Mississippi",
            "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
            "New Jersey", "New Mexico", "New York", "North Carolina",
            "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania",
            "Rhode Island", "South Carolina", "South Dakota", "Tennessee",
            "Texas", "Utah", "Vermont", "Virginia", "Washington",
            "West Virginia", "Wisconsin", "Wyoming", "Puerto Rico", "Guam",
            "U.S. Virgin Islands"),
  state_code = as.integer(c("01", "02", "04", "05", "06", "08", "09", "10", "11", "12", "13",
           "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25",
           "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36",
           "37", "38", "39", "40", "41", "42", "44", "45", "46", "47", "48",
           "49", "50", "51", "53", "54", "55", "56", "72", "66", "78"))
)

#BLS industry codes
sector_codes <- tibble(
  sector = c("Manufacturing", "Construction",
             "Trade, Transportation, and Utilities",
             "Leisure and Hospitality", "Information",
             "Education and Health Services",
             "Professional and Business Services",
             "Government", "Mining and Logging",
             "Financial Activities", "Other Services"),
  
  #selecting data across entire sector ignoring sub industries
  industry_code = as.integer(c("30000000", "20000000", "42000000", "70000000", "50000000",
                    "65000000", "60000000", "90000000", "10000000",
                    "55000000", "80000000")),
  
  supersector_code = as.integer(c("30", "20", "42", "70", "50", "65", "60", "90", 
                       "10", "55", "80"))
)

#relevant metrics
metric_codes <- tibble(
  metric = c("all_employees",
             "avg_weekly_hours_all",
             "avg_hourly_earnings_all",
             "production_nonsupervisory_employees",
             "avg_weekly_hours_production",
             "avg_hourly_earnings_production",
             "avg_weekly_earnings_all",
             "avg_weekly_earnings_production"),
  
  metric_code = as.integer(c("01",  
             "02",  
             "03",  
             "06",  
             "07",  
             "08",  
             "11",  
             "30")), 
  source = "SMU"
)

#get statewide seasonally unadjusted data
#seasonally adjusted only contains total employment levels
labor_series <- labor_series |>
  filter(area_code == 0 & seasonal == "U")

#get relevant series
labor_series <- labor_series |>
  inner_join(state_codes, by = "state_code") |>
  inner_join(sector_codes, by = "industry_code") |>
  inner_join(metric_codes, by = c("data_type_code" = "metric_code"))

#create file with api series ids and metadata to download from api
labor_series <- labor_series |>
  select(series_id, state, sector, metric) |>
  mutate(series_id = trimws(series_id))

write.csv(labor_series, "data/bls_series/labor_series_ids.csv")
