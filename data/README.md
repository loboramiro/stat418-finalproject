## Subfolders

### `bls_raw/`
Raw BLS JSON responses downloaded using the BLS API.

### `bls_series/`
Contains metadata files from the BLS, including:
- `sm.series` – State and industry-level employment/wage metadata
- `la.series` – Labor force and unemployment series metadata

### `cpi/`
Contains national Consumer Price Index (CPI) data from the Bureau of Labor Statistics and Regional Price Parity (RPP) data from the Bureau of Economic Activity for adjusting real wages by state.

### `strikes/`
Includes raw and cleaned data from the Cornell ILR Labor Action Tracker.

## 🔄 CSV Files

### `annual_actions_panel.csv`
Annual aggregation of labor actions (strikes and protests) by state and sector. Contains binary indicators for action occurrence.

### `annual_bls_panel.csv`
Processed economic indicators from BLS data aggregated by state, sector, and year. Includes employment, and labor force metrics. 

### `model_panel.csv`
Final merged dataset combining `annual_actions_panel` and `annual_bls_panel` with engineered features, used as the input for modeling.