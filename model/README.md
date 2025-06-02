- **`tune_model.R`**  
  This script performs tuning of the random forest model using a grid search across `mtry`, `nodesize`, and `ntree`. It evaluates models based on AUC using 2025 labor action data as the test data.
  The best model is saved as `final_model.rds`.

- **`model.R`**  
  This script is sourced by the Shiny app to load the trained model. 

- **`final_model.rds`**  
  This is the saved, tuned random forest model, trained on pre-2025 data using the best parameters found in `tune_model.R`.
