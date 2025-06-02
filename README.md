# Predicting Labor Actions in the United States

**Author**: Ramiro Lobo  
**Course**: UCLA STAT 418 – Tools in Data Science  
**Term**: Spring 2025

Access the Shiny app: [Link](https://ramirolobo.shinyapps.io/stat418-finalproject/)

API Endpoint: [Link](https://labor-actions-api-691844217421.us-west2.run.app/)

## Overview

This project aims to predict labor unrest in the United States by modeling the probability of strike and protest activity at the industry and state level. Using data from the Cornell ILR Labor Action Tracker and economic indicators from the U.S. Bureau of Labor Statistics (BLS) and Bureau of Economic Analysis (BEA), the project deploys a predictive model via a Shiny web application.

## Data Sources

- **Cornell ILR Labor Action Tracker**: Detailed records of strike and protest actions across the U.S.
- **Bureau of Labor Statistics (BLS)**: Employment, labor force, and consumer price index data. 
- **Bureau of Economic Activity (BEA)**: Regional price parities by state. 

## Methodology

Each record in the final model dataset represents a unique combination of:

- `state`  
- `sector`  
- `year`

Key variables include:

- `action_occurred`: Binary target variable (1 if a strike or protest occurred).
- Economic features: Statewide sector employment levels, unemployment rate, labor force participation rate, total labor force size, and state-adjusted consumer price index (CPI).

A random forest model is trained on strike and economic data from 2021–2024 to predict the probability of a labor action (strike or protest) in 2025. Hyperparameter tuning was conducted
using a grid search over `mtry`, `nodesize`, and `ntree` and evaluated using AUC on the 2025 data. The best-performing combination was selected based on highest AUC, and the final model 
achieved an AUC of 0.83. 

## Deployment

- The prediction model is hosted via an API using the `plumber` R package, containerized with Docker, and deployed to Google Cloud Run.
- The Shiny app serves as the front end, sending prediction requests to the API and displaying the results.

## Shiny App

Users can select an industry and state to see the predicted probability of a labor action in 2025. Users can choose how economic features are generated:

- By default, the model uses preliminary 2025 BLS data and lagged 2023 BEA RPPs.
- Users can override default values using interactive sliders.

The app returns:

- Predicted probability of a labor action in the selected state and sector
- Recent labor actions in the selected state and sector (2021–2025)
- Plot of historical labor action trends in the selected state

## Accessing the API

To check the health of the API [visit this link](https://labor-actions-api-691844217421.us-west2.run.app/). If the API is running you should see `"status": "Labor Action API is running!"`

To send a request to the API, use a `curl` command in your terminal.

Example: 
`curl -X POST https://labor-actions-api-691844217421.us-west2.run.app/predict \
  -H "Content-Type: application/json" \
  -d '{
    "state": "California",
    "sector": "Construction",
    "all_employees": 500,
    "state_unempl_rate": 5,
    "state_labor_part": 60,
    "state_labor_force": 2450,
    "adjusted_cpi": 290
  }'` 

  The response should be something like `{"probability":[0.78]}`
