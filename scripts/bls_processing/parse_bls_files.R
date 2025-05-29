library(purrr)

#function to parse JSON files downloaded from BLS API
parse_bls_files <- function(path){
  json <- fromJSON(path, simplifyVector = FALSE)
  
  series <- json$Results$series[[1]]
  series_id <- series$seriesID
  dat <- series$data
  
  df <- map_dfr(dat, function(x) {
    tibble(
      year = as.integer(x$year),
      month = as.integer(str_remove(x$period, "M")),
      value = as.numeric(x$value)
    )
  })
  
  df <- df %>%
    mutate(series_id = series_id)
  
  return(df)
}

# create dataframe with contents of all of the BLS data
json_files <- list.files("data/bls_raw", full.names = TRUE)
bls_long <- map_dfr(json_files, parse_bls_files)

write.csv(bls_long, "data/bls_series/bls_parsed.csv")
