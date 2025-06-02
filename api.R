library(plumber)
library(randomForest)

source("model/model.R")

#* @get /
#* @serializer unboxedJSON
function() {
  list(status = "Labor Action API is running!")
}

#* @post /predict
function(state, sector, all_employees, adjusted_cpi, state_unempl_rate, 
         state_labor_part, state_labor_force) {
  new_obs <- data.frame(
    state = state,
    sector = sector,
    all_employees = as.numeric(all_employees),
    adjusted_cpi = as.numeric(adjusted_cpi),
    state_unempl_rate = as.numeric(state_unempl_rate),
    state_labor_part = as.numeric(state_labor_part),
    state_labor_force = as.numeric(state_labor_force)
  )
  prob <- predict_action(new_obs)
  list(probability = prob)
}