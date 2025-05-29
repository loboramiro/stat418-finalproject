## Scripts

### `app_plot.R`
Generates the plots shown in the Shiny application. It displays labor action patterns by state and sector.

### `build_adjusted_cpi.R`
Processes Consumer Price Index (CPI) and Regional Price Parities (RPP) data to create an adjusted CPI metric by state. This helps account for cost-of-living differences across regions.

### `merge_clean_model_panel.R`
Merges cleaned BLS and labor action datasets to build the final dataset used for modeling.

### `model.R`
Trains the predictive model (Random Forest) on the final dataset. Outputs predicted probabilities for 2025.

## Subfolders

### `bls_processing/`
Contains scripts to generate valid series IDs, download employment metrics via the BLS API, and clean BLS data. 

### `strikes_processing/`
Contains scripts for cleaning and transformation of raw Labor Action Tracker data.