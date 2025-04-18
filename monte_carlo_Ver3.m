clc; clear; close all;

%% Parameters
numEV = 567; % Number of EVs
timestep = 288; % 5-minute intervals for a 24-hour period
batteryCap = 40; % kWh, Nissan Leaf battery capacity
chargingPower = 3.6; % kW, single-phase charger
dischargingPower = -3.6; % kW, V2H discharge
chargingEfficiency = 0.90; % 90% charging efficiency
dischargingEfficiency = 0.904; % 90.4% discharging efficiency
soC_init = rand(numEV, 1) * 0.5 + 0.2; % Initial SOC between 20% and 70%

% Define possible charging and discharging durations
chargeDurations = 3:6; % Hours converted into time steps later
dischargeMinSOC = 0.2; % Minimum SOC threshold
ChargingStartRange = 192:288; % Possible charging start times (after discharge till morning)
DischargingStartRange = 216:240; % 6 PM to 8 PM range

% Initialize EV load profile (each row is an EV, each column is a timestep)
EVprofiles = zeros(numEV, timestep);

%% Monte Carlo Simulation
for i = 1:numEV
    % Randomly decide whether the EV charges (0) or discharges (1)
    userChoice = randi([0, 1]);
    
    % Calculate available energy for charging/discharging
    chargeLeft = batteryCap * (soC_init(i) - dischargeMinSOC);
    
    if userChoice == 1 % Discharge first, then charge
        % Select random discharge start time and duration
        dischargeStart = randsample(DischargingStartRange, 1);
        Dischargetime = chargeLeft / (abs(dischargingPower) * dischargingEfficiency);
        dischargeFinalDuration = min(floor(Dischargetime * 12), timestep - dischargeStart);
        dischargeEnd = dischargeStart + dischargeFinalDuration;
        
        for t = 0:dischargeFinalDuration-1
    currentIndex = mod(dischargeStart + t - 1, timestep) + 1;
    EVprofiles(i, currentIndex) = dischargingPower;
end

% Update SOC after discharge
newSOC = soC_init(i) - (dischargeFinalDuration / 12 * abs(dischargingPower) * dischargingEfficiency) / batteryCap;

% Calculate required charging time to reach full SOC
chargeNeeded = (batteryCap * (1 - newSOC)) / (chargingPower * chargingEfficiency);
chargeDuration = ceil(chargeNeeded * 12); % Convert hours to 5-min steps

% Charging starts right after discharging, allowing flexible start time
chargeStart = dischargeEnd + randsample(0:12:48, 1); % Random delay from 0 to 4 hours

% Apply charge profile with wrap-around
    for t = 0:chargeDuration-1
    currentIndex = mod(chargeStart + t - 1, timestep) + 1;
    EVprofiles(i, currentIndex) = chargingPower;
                if currentIndex == 96
                break;
                end;
    end
        
    else % Charge directly (no discharge)
        % Select random charge start time and duration
        chargeStart = randsample(192:264, 1); % Charging from 4 PM to 12 AM
        chargeDuration = randsample(chargeDurations, 1) * 12; % Convert hours to 5-min steps
        chargeEnd = chargeStart + chargeDuration;
        
       for t = 0:chargeDuration-1
    currentIndex = mod(chargeStart + t - 1, timestep) + 1;
    EVprofiles(i, currentIndex) = chargingPower;
            if currentIndex == 96
                break;
            end
    end
    end
end

%% Plot Individual EV Profiles
figure;
 hold on;
 for i = 1:1 % Plot only 10 random EVs for visualization
     plot(linspace(0, 24, timestep), EVprofiles(i, :), 'LineWidth', 1);
 end
 xlabel('Time (Hours)');
 ylabel('Power (kW)');
 title('Uncontrolled EV Charging and Discharging Profiles (Sample of 10 EVs)');
 grid on;
 xlim([0 24]);