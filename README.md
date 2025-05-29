# Predicting Labor Actions in the United States

**Author**: Ramiro Lobo  
**Course**: UCLA STAT 418 – Tools in Data Science  
**Term**: Spring 2025

Access the Shiny app: [Link](https://ramirolobo.shinyapps.io/stat418-finalproject/)

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

A random forest model is trained on strike and economic data from 2021–2024 to predict the probability of a labor action (strike or protest) in 2025.


## Shiny App

Users can select an industry and state to see the predicted probability of a labor action in 2025. Users can choose how economic features are generated:

- By default, the model uses preliminary 2025 BLS data and lagged 2023 BEA RPPs.
- Users can override default values using interactive sliders.

The app returns:

- Predicted probability of a labor action in the selected state and sector
- Recent labor actions (2021–2025)
- Interactive plot of historical labor action trends