This folder contains R scripts for scraping, cleaning, and transforming labor action data from the Cornell ILR Labor Action Tracker. These scripts are used to construct the strike and protest indicator used in the modeling dataset.

Scripts should be run in the following order to obtain the cleaned labor action dataset:

`scrape_strikes.R`
Downloads raw strike and protest data from the Labor Action Tracker source and saves it to local storage. (Run once if data is cached.)

`clean_strikes.R`
Cleans the raw data by parsing dates, classifying action types (e.g., strike vs. protest), and standardizing state and sector names.

`build_action_panel.R`
Aggregates cleaned strike data by state, sector, and year. Adds binary indicators for the occurrence of a labor action. This serves as the target variable used for modeling.

Optional: `strikes_eda.R`
Performs exploratory data analysis on the cleaned dataset to understand trends in labor actions over time and across states and sectors. Generates summary tables and visualizations.
