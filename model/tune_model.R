library(tidyverse)
library(randomForest)
library(pROC)


# load and prep data
data <- read.csv("data/model_panel.csv")


data <- data |>
  mutate(
    action_occurred = as.factor(action_occurred),
    state = as.factor(state),
    sector = as.factor(sector)
  )

# specify predictors
predictors <- c(
  "state",
  "sector",
  "all_employees",
  "adjusted_cpi",
  "state_unempl_rate",
  "state_labor_part",
  "state_labor_force"
)

#split data
train_data <- data |> 
  filter(year != 2025) |>
  filter(if_all(all_of(predictors), ~ !is.na(.)))

test_data <- data |>
  filter(year == 2025) |>
  filter(if_all(all_of(predictors), ~ !is.na(.)))

# create tuning grid
tune_grid <- expand.grid(
  mtry = c(2, 4, 6),
  nodesize = c(1, 5, 10),
  ntree = c(100, 250, 500, 750)
)

tuning_results <- data.frame()

for (i in 1:nrow(tune_grid)) {
  m <- tune_grid$mtry[i]
  n <- tune_grid$nodesize[i]
  t <- tune_grid$ntree[i]
  
  set.seed(42)
  
  rf_model <- randomForest(
    formula = reformulate(predictors, "action_occurred"),
    data = train_data, 
    mtry = m, 
    nodesize = n, 
    ntree = t
  )
  
  preds <- predict(rf_model, newdata = test_data[, predictors], type = "prob")[, 2]
  actuals <- as.numeric(as.character(test_data$action_occurred))
  auc <- roc(actuals, preds)$auc
  
  tuning_results <- rbind(tuning_results, data.frame(mtry = m, nodesize = n, ntree = t, AUC = auc))
}

#visualizing paramater combos influence on AUC
ggplot(tuning_results, aes(x = factor(mtry), y = AUC, color = factor(nodesize))) +
  geom_point() +
  facet_wrap(~ ntree) +
  labs(title = "AUC by mtry and nodesize", x = "mtry", color = "nodesize")

#get best parameters based on AUC
best_params <- tuning_results[which.max(tuning_results$AUC), ]

#fit model with the best parameters
rf_best <- randomForest(
  formula = reformulate(predictors, "action_occurred"),
  data = train_data,
  mtry = best_params$mtry,
  nodesize = best_params$nodesize,
  ntree = best_params$ntree,
  importance = TRUE
)

#predict 2025 data with the new model
test_pred <- predict(rf_best, newdata = test_data[, predictors], type = "prob")[, 2]
  
# plot ROC
roc_obj <- roc(test_data$action_occurred, test_pred)
plot(roc_obj, col = "#2c7fb8", lwd = 2, main = "ROC Curve")

#factor importance plot
varImpPlot(rf_best)

#save model
saveRDS(rf_best, "model/final_model.rds")
