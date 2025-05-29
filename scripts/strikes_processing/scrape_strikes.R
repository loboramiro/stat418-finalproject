library(httr)
library(jsonlite)
library(tidyverse)

# Cornell strike tracker site
strike_json_url <- "https://striketracker.ilr.cornell.edu/labor_actions.json"


request <- GET(strike_json_url)

raw_strike_data <- fromJSON(content(request, as= "text", encoding = "UTF-8"))

#map relevant columns into dataframe
strikes_df <- map_df(raw_strike_data, function(x) {
  x[sapply(x, is.null)] <- NA #map NULL fields
  
  tibble(
    id = x$id,
    employer = x$Employer, 
    start_date = x$Start_date, 
    end_date = x$End_date, 
    duration = as.numeric(x$Duration),
    labor_org = x$Labor_Organization,
    authorized = x$Authorized, 
    action_type = x$Action_type,
    n_participants = x$Approximate_Number_of_Participants,
    industry = if (!is.null(x$Industry) && length(x$Industry) > 0) x$Industry[[1]] else NA,
    demands = if (!is.null(x$Worker_demands)) str_c(x$Worker_demands, 
                                                    collapse = "; ") else NA,
    city = if (!is.null(x$locations) && is.data.frame(x$locations) && nrow(x$locations) > 0) x$locations$City[1] else NA_character_,
    state = if (!is.null(x$locations) && is.data.frame(x$locations) && nrow(x$locations) > 0) x$locations$State[1] else NA_character_
  )
})

#save strike data
write.csv(strikes_df, "data/strikes/strikes_raw.csv")
