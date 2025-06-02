library(randomForest)

# specify the predictors to use
predictors <- c(
  "state",
  "sector",
  "all_employees",
  "adjusted_cpi",
  "state_unempl_rate",
  "state_labor_part",
  "state_labor_force"
)

rf_action <- readRDS("model/final_model.rds")


predict_action <- function(newdata, model = rf_action) {
  newdata <- newdata[, predictors, drop = FALSE]
  
  newdata$state <- factor(newdata$state, levels = model$forest$xlevels$state)
  newdata$sector <- factor(newdata$sector, levels = model$forest$xlevels$sector)
  
  # Return predicted probability of labor action (class 1)
  predict(model, newdata, type = "prob")[, 2]
}


