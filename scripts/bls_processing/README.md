This folder contains R scripts for retrieving, filtering, and preparing labor market data from the Bureau of Labor Statistics (BLS) API. These scripts are used to construct the economic indicators necessary for modeling labor unrest at the state and industry level.

These scripts should be run in the order below to obtain economic data for modeling.

### `extract_labor_series.R`
Identifies valid BLS series IDs for employment and wage indicators by filtering the `sm.series` metadata file using custom sector and state codes.

### `extract_unempl_series.R`
Filters the `la.series` metadata to get valid series IDs for state-level unemployment metrics, such as unemployment rate and labor force participation.

### `scrape_bls.R`
Fetches BLS time series data using the API based on valid series IDs and stores them as JSON files in `data/bls_raw/`. Includes logic for batching requests and logging download completion. 

### `parse_bls_files.R`
Parses and reshapes downloaded BLS time series data files into a consistent format. Handles date parsing, value casting, and metadata joins.

### `build_bls_panel.R`
Combines parsed BLS data into a clean dataset by state, sector, and year. This is merged with labor action data for modeling.

## Inputs
- `sm.series` and `la.series` files
- BLS API key (stored in environment variable or config)

## Output
- Cleaned and merged BLS panel data (by state-sector-year): `data/annual_bls_panel.csv`
- Intermediate files saved locally for tracking and debugging



