clc; clear; close all;

%% Parameters
numEV = 567; % Number of EVs
timestep = 288; % 5-minute intervals for a 24-hour period
batteryCap = 40; % kWh, Nissan Leaf battery capacity
chargingPower = 3.6; % kW, single-phase charger
dischargingPower = -3.2544; % kW, V2G discharge
chargingEfficiency = 0.90; % 90% charging efficiency
dischargingEfficiency = 0.904; % 90.4% discharging efficiency
soC_init = rand(numEV, 1) * 0.5 + 0.2; % Initial SOC between 20% and 70%

% Define possible charging and discharging durations
chargeDurations = 2:4; % Hours converted into time steps later
dischargeDurations = 2:4; % Same as charge durations
ChargingStartRange = 192:288; % Possible charging start times
DischargingStartRange = 216:240; % Possible discharging start times

% Initialize EV load profile (each row is an EV, each column is a timestep)
EVprofiles = zeros(numEV, timestep);

%% Monte Carlo Simulation
for i = 1:numEV
    % Randomly decide whether the EV charges (0) or discharges (1)
    userChoice = randi([0, 1]);

    % Calculate available energy for charging/discharging
    chargeLeft = batteryCap * (1 - soC_init(i));

        chargeStart = randsample(ChargingStartRange, 1);
        chargeDuration = randsample(chargeDurations, 1) * 12; % Convert hours to 5-min steps
        
        % Apply charge profile
        for t = 0:chargeDuration-1
            currentIndex = mod(chargeStart + t - 1, timestep) + 1;
            EVprofiles(i, currentIndex) = chargingPower;
        end
    % end
end

%% Plot Individual EV Profiles
figure;
hold on;
for i = 1:10 % Plot only 10 random EVs for visualization
    plot(linspace(0, 24, timestep), EVprofiles(i, :), 'LineWidth', 1);
end
xlabel('Time (Hours)');
ylabel('Power (kW)');
title('Uncontrolled EV Charging and Discharging Profiles (Sample of 10 EVs)');
grid on;
xlim([0 24]);
