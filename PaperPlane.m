%	Example 1.3-1 Paper Airplane Flight Path
%	Copyright 2005 by Robert Stengel
%	August 23, 2005

close all; clear; clc;


% Define all needed variables and equations (using SI units)

global CL CD S m g rho	

S =	0.017; % Reference area (m^2)
AR = 0.86; % Aspect ratio
e =	0.9; % Oswald efficiency factor
m =	0.003; % Mass (kg)
g =	9.81; % Gravity (m/s^2)
rho	= 1.225; % Density at sea level (kg/m^3)

k =	1/(pi * e * AR); % Induced drag factor
CD0 = 0.02;	% Zero-lift drag coefficient
CLa	= pi * AR/(1 + sqrt(1 + (AR / 2)^2)); % Lift-Coefficient Slope, per rad	
CL = sqrt(CD0/k);	% CL max 
CD = CD0 + k * CL^2; % Drag polar
LD_max = CL/CD; % L/D max
Alpha =	CL/CLa; % Corresponding Angle of Attack, rad


%	d) Effect of Further Increase in Initial Velocity
	%xo		=	[3*V;0;H;R];
	%[td,xd]	=	ode23('EqMotion',tspan,xo);
	
	%figure
	%plot(xa(:,4),xa(:,3),xb(:,4),xb(:,3),xc(:,4),xc(:,3),xd(:,4),xd(:,3))
	%xlabel('Range, m'), ylabel('Height, m'), grid

	%figure
	%subplot(2,2,1)
	%plot(ta,xa(:,1),tb,xb(:,1),tc,xc(:,1),td,xd(:,1))
	%xlabel('Time, s'), ylabel('Velocity, m/s'), grid
	%subplot(2,2,2)
	%plot(ta,xa(:,2),tb,xb(:,2),tc,xc(:,2),td,xd(:,2))
	%xlabel('Time, s'), ylabel('Flight Path Angle, rad'), grid
	%subplot(2,2,3)
	%plot(ta,xa(:,3),tb,xb(:,3),tc,xc(:,3),td,xd(:,3))
	%xlabel('Time, s'), ylabel('Altitude, m'), grid
	%subplot(2,2,4)
	%plot(ta,xa(:,4),tb,xb(:,4),tc,xc(:,4),td,xd(:,4))
	%xlabel('Time, s'), ylabel('Range, m'), grid







% Define nominal values and expected variations
nominal_velocity = 3.55; % m/s
nominal_angle = -0.18; % rad
velocity_variation = [2, 7.5]; % [lower, higher]
angle_variation = [-0.5, 0.4]; % [lower, higher]

% Case A: Plot trajectories for varying initial conditions
figure;
subplot(2, 1, 1); % Height vs Range subplot
hold on;
for condition = 1:3
    switch condition
        case 1 % Nominal condition
            color = 'k';
            velocity = nominal_velocity;
            angle = nominal_angle;
        case 2 % Higher condition
            color = 'g';
            velocity = velocity_variation(2);
            angle = nominal_angle;
        case 3 % Lower condition
            color = 'r';
            velocity = velocity_variation(1);
            angle = nominal_angle;
    end
    % Simulate and plot trajectory
    [time, range, height] = simulatePaperPlane(velocity, angle);
    plot(range, height, color); 
end
xlabel('Range (m)');
ylabel('Height (m)');
title('Trajectories for Varying Initial Conditions');
legend('Nominal Condition', 'Higher condition', 'Lower condition');

% Perform 100 random simulations and plot trajectories
subplot(2, 1, 2); % Height vs Range subplot
hold on;
for run = 1:100
    % Generate random initial conditions
    velocity = velocity_variation(1) + (velocity_variation(2) - velocity_variation(1)) * rand(1);
    angle = angle_variation(1) + (angle_variation(2) - angle_variation(1)) * rand(1);
    % Simulate and plot trajectory
    [time, range, height] = simulatePaperPlane(velocity, angle);
    plot(range, height, 'Color', rand(1,3)); % Random color
end
xlabel('Range (m)');
ylabel('Height (m)');
title('Random Trajectories');

% Compute and plot average trajectories and derivatives
num_trajectories = 100;
avg_range = zeros(size(time)); % Initialize arrays for average trajectory
avg_height = zeros(size(time));
for run = 1:num_trajectories
    % Simulate random trajectory
    velocity = velocity_variation(1) + (velocity_variation(2) - velocity_variation(1)) * rand(1);
    angle = angle_variation(1) + (angle_variation(2) - angle_variation(1)) * rand(1);
    [time, range, height] = simulatePaperPlane(velocity, angle);
    % Add to average trajectory
    avg_range = avg_range + range;
    avg_height = avg_height + height;
end
avg_range = avg_range / num_trajectories; % Calculate average
avg_height = avg_height / num_trajectories;

% Fit polynomial curves to average trajectory data
degree = 3; % Choose degree for polynomial fitting
range_poly = polyfit(time, avg_range, degree);
height_poly = polyfit(time, avg_height, degree);

% Plot average trajectories
figure;
subplot(2, 1, 1);
plot(time, polyval(range_poly, time), 'b', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Range (m)');
title('Average Range Trajectory');
subplot(2, 1, 2);
plot(time, polyval(height_poly, time), 'r', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Height (m)');
title('Average Height Trajectory');

% Compute and plot first-time derivatives
range_derivative = polyder(range_poly);
height_derivative = polyder(height_poly);

figure;
subplot(2, 1, 1);
plot(time, polyval(range_derivative, time), 'b', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('dR/dt (m/s)');
title('First Time Derivative of Range');
subplot(2, 1, 2);
plot(time, polyval(height_derivative, time), 'r', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('dh/dt (m/s)');
title('First Time Derivative of Height');


