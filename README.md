
# EV & V2G Monte Carlo Simulation

## 1. Introduction
This repository contains MATLAB-based Monte Carlo simulations to model uncontrolled EV charging and bidirectional Vehicle-to-Grid (V2G) behaviour in a residential network. These profiles were developed to support impact analysis using OpenDSS.

## 2. File Structure
- `EV_MonteCarlo.m`: Generates 567 uncontrolled EV charging profiles based on UK commuting habits.
- `V2G_MonteCarlo.m`: Extends the EV model to include random discharging (V2G) and subsequent recharging logic.
- `/results/`: Contains exported CSV profiles used in OpenDSS simulations.
- `/figures/`: Stores visualization plots from each run.

## 3. Requirements
- MATLAB R2021a or newer (older versions may still work)
- No additional toolboxes are required.

## 4. How to Run

### 🔌 EV Charging Simulation
1. Open `EV_MonteCarlo.m`.
2. Run the script.
3. The script will generate and plot random EV charging profiles for 567 households.

### 🔋 V2G Charging/Discharging Simulation
1. Open `V2G_MonteCarlo.m`.
2. Run the script.
3. The script will simulate:
   - Evening discharge between 6–8 PM (if selected),
   - Followed by overnight charging.
4. Output profiles reflect real-world constraints:
   - Minimum SoC: 20%
   - Max charge: until 8 AM next day

## 5. Output
Both scripts generate:
- A 567x288 matrix (`EVprofiles`) representing 24-hour profiles in 5-minute intervals.
- Optional: Export to CSV for OpenDSS use.

## 6. Technical Notes
- Load shape and behaviour align with ENWL Network 2 LV data.
- Charging power: 3.6 kW @ 90% efficiency
- V2G discharging: -3.6 kW @ 90.4% efficiency
- Monte Carlo randomization includes:
  - SOC (initial), duration, and start times
  - Randomised V2G participation
- Time-based logic wraps around using `mod()` for continuity past midnight.

## 7. Known Issues / Future Improvements
- Add export script to automate saving CSV files.
- Include SoC tracking for analysis.
- Visualize aggregated demand from all 567 EVs.
- Consider adding smart charging/V2G scheduling in future versions.
