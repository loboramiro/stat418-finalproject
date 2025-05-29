library(randomForest)

# load and prep data
data <- read.csv("data/model_panel.csv")

data <- data |>
  mutate(
    action_occurred = as.factor(action_occurred),
    state = as.factor(state),
    sector = as.factor(sector)
  )

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


train_data <- data |> 
  filter(year != 2025) |>
  filter(if_all(all_of(predictors), ~ !is.na(.)))

# fit random forest model
set.seed(42)

rf_action <- randomForest(
  formula = reformulate(predictors, "action_occurred"),
  data = train_data,
  ntree = 500,
  importance = TRUE
)

# prediction function
predict_action <- function(newdata) {
  newdata <- newdata[, predictors, drop = FALSE]
  
  newdata$state <- factor(newdata$state, levels = levels(train_data$state))
  newdata$sector <- factor(newdata$sector, levels = levels(train_data$sector))
  
  #return probability of a labor action
  predict(rf_action, newdata, type = "prob")[, 2]
}


