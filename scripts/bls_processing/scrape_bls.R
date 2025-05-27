library(blsAPI)
library(glue)
library(jsonlite)
library(glue)
library(tidyverse)

#load series ids for labor and unemployment stats
labor_series_ids <- read.csv("data/bls_series/labor_series_ids.csv")
unempl_series_ids <- read.csv("data/bls_series/unempl_series_ids.csv")

#combine all series ids
all_series <- bind_rows(labor_series_ids, unempl_series_ids)

#ignore sparse metrics
metrics <- c("all_employees", 
             "Unemployment Rate",
             "Labor Force", 
             "Labor Force Participation Rate")

all_series <- all_series |>
  filter(metric %in% metrics)

#create log to check downloaded series
log_path <- "data/bls_series/log.csv"
completed <- if (file.exists(log_path)) read_csv(log_path, 
                                                 show_col_types = FALSE)$series_id else character(0)

#find remaining series
remaining_series <- all_series %>% filter(!series_id %in% completed)

#API limit of 500 per day
batch_size = 489
batch <- head(remaining_series, batch_size)

#set API key
bls_api_key <- Sys.getenv("BLS_API_KEY")

#function to get bls data and store as JSON
get_bls_data <- function(series_id, api_key,
                         path_dir = "data/bls_raw") {
  file_path <- file.path(path_dir, glue("{series_id}.json"))
  print(file_path)
  
  if (!file.exists(file_path)) {
    payload <- list('seriesid' = series_id,
                    'startyear' = "2015",
                    'endyear' = "2025",
                    'registrationKey' = bls_api_key)
    res <- blsAPI(payload, 2)
    write(res, file_path)
  }
  
  return(file_path)
}

#function to check if series is empty
is_series_empty <- function(json_path) {
  parsed <- fromJSON(paste(readLines(json_path, warn = FALSE), collapse = ""))
  length(parsed$Results$series[[1]]$data) == 0
}

#try to download data, share error if API failed
#if successful check if data is empty due to a series not existing
log_updates <- lapply(batch$series_id, function(series) {
  file_path <- tryCatch(
    get_bls_data(series, api_key = bls_api_key),
    error = function(e) {
      message(glue("Failed for {series}: {e$message}"))
      return(NA)
    }
  )
  
  # Ensure the output is a tibble
  tibble(
    series_id = series,
    path = file_path,
    #empty = if (!is.na(file_path)) is_series_empty(file_path) else NA
  )
})

#create dataframe for logging downloads
existing_log <- if (file.exists(log_path)) {
  read_csv(log_path, show_col_types = FALSE)
} else {
  tibble(series_id = character(), empty = logical())
}

log_df <- bind_rows(existing_log, bind_rows(log_updates))

#write log of downloads
write_csv(log_df, log_path)
