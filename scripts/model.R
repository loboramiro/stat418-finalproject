library(randomForest)

# -------------------------------
# Load and prepare training data
# -------------------------------
data <- read.csv("data/model_panel.csv")

# Specify the predictors to use (edit as needed)
predictors <- c(
  "all_employees", 
  "unemployment_rate",
  "labor_force_participation_rate",
  "adjusted_cpi", 
  "months_since_last_action"  # Optional feature
)

# Ensure complete cases
train_data <- train_data[complete.cases(train_data[, predictors]), ]

# -------------------------------
# Fit Random Forest Models
# -------------------------------
set.seed(42)

rf_strike <- randomForest(
  formula = reformulate(predictors, "strike_occurred"),
  data = train_data,
  ntree = 500,
  importance = TRUE
)

rf_protest <- randomForest(
  formula = reformulate(predictors, "protest_occurred"),
  data = train_data,
  ntree = 500,
  importance = TRUE
)

rf_action <- randomForest(
  formula = reformulate(predictors, "action_occurred"),
  data = train_data,
  ntree = 500,
  importance = TRUE
)

# -------------------------------
# Prediction Function
# -------------------------------
predict_action <- function(newdata, type = c("strike", "protest", "either")) {
  type <- match.arg(type)
  
  model <- switch(
    type,
    strike = rf_strike,
    protest = rf_protest,
    either = rf_action
  )
  
  # Ensure newdata has the required predictors and no missing values
  newdata <- newdata[, predictors, drop = FALSE]
  if (anyNA(newdata)) stop("Missing values found in predictors")
  
  predict(model, newdata, type = "prob")[, 2]  # Return probability of '1'
}