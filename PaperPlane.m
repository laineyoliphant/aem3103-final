%	Example 1.3-1 Paper Airplane Flight Path
%	Copyright 2005 by Robert Stengel
%	August 23, 2005


global C_L C_D s mass grav rho	

% Define all needed variables and equations (using SI units)

% Aerodynamic properties and assumptions
mass =	0.003; %(kg)
AR = 0.86; 
s =	0.017; % (m^2)
e =	0.9; 
k =	1/(pi * e * AR); 
CD_0 = 0.02; 

% Derived aerodynamic qualities
C_L = sqrt(CD_0/k);	
C_D = CD_0 + k * ((C_L)^2); 


% Atmospheric conditions
rho	= 1.225; %(kg/m^3)
grav = 9.81; %(m/s^2)


% Range conditions
initial_range =	0; %(m)
max_range = 25; %(m)

% Height conditions
initial_height = 2; %(m)

% Time conditions
initial_time = 0; %(s)
final_time = 6;	%(s)
time_span = [initial_time final_time]; %range of time (s)



% Variation in simulated parameters (three conditions)

% Define flight path angles conditions 
min_gamma = -0.5;
nominal_gamma = -0.18; 
max_gamma = 0.4;

% Define initial velocity conditions
min_velocity = 2;
nominal_velocity = 3.55;
max_velocity = 7.5; 

% Baseline with no variations
nominal_condition = [nominal_velocity; nominal_gamma; initial_height; initial_range];
[ta, xa] = ode23('EqMotion', time_span, nominal_condition); %Calls EqMotion file


% Velocity varies
% Min velocity
vary_min_velocity = [min_velocity; nominal_gamma; initial_height; initial_range];
[ta2, xa2] = ode23('EqMotion', time_span, vary_min_velocity);

% Max velocity
vary_max_velocity = [max_velocity; nominal_gamma; initial_height; initial_range];
[tb2, xb2] = ode23('EqMotion', time_span, vary_max_velocity);


% Gamma varies
% Min flight path angle
vary_min_gamma = [nominal_velocity; min_gamma; initial_height; initial_range];
[tb, xb] = ode23('EqMotion', time_span, vary_min_gamma);

% Max flight path angle
vary_max_gamma = [nominal_velocity; max_gamma; initial_height; initial_range];
[tc, xc] = ode23('EqMotion', time_span, vary_max_gamma);



% Visualize the different conditions and plot

% Figure 1
% first subplot
figure; 
subplot(2,1,1);
hold on;

% Plots Height vs Range for three different initial velocity condition
plot(xa(:,4),xa(:,3),'k',xa2(:,4),xa2(:,3),'r',xb2(:,4),xb2(:,3),'g'); 

% Title and labels
title('Height vs Range for Various Velocities');
xlabel('Range (m)'); 
ylabel('Height (m)');

% Adds grid to first subplot
grid;

% Adds legend to first subplot and differentiates the three different
% velocities
legend(sprintf("Nominal Velocity = %g", nominal_velocity), sprintf("Minimum Velocity = %g", min_velocity), sprintf("Maximum Velocity = %g", max_velocity));


% Second subplot
subplot(2,1,2);
hold on;

% Plots Height vs Range for three different flight path angles
plot(xa(:,4), xa(:,3),'k', xb(:,4), xb(:,3),'r', xc(:,4), xc(:,3),'g'); 

% Title and axis labels
title('Height vs Range for Various Flight Path Angles');
xlabel('Range (m)'); 
ylabel('Height (m)'); 

% second subplot grid
grid;

% Legend for second subplot
legend(sprintf("Nominal Gamma = %g", nominal_gamma), sprintf("Minimum Gamma = %g", min_gamma), sprintf("Maximum Gamma = %g", max_gamma)); 



% Conduct randomized trials for simultaneous variations
figure; 
hold on;

% Creates vector for time range
range_time = linspace(0, 6, 100);

% Initialize position and time sum
time_sum = 0;
position_sum = 0;


% Uses for loop to iterate 100 times
for i = 1:100 

    % Calculates randomized velocity and flight path angle
    random_velocity = min_velocity + (max_velocity - min_velocity) * rand(1);
    random_gamma = min_gamma + (max_gamma - min_gamma) * rand(1);


    % Defines initial position based off of random parameters
    initial_position = [random_velocity; random_gamma; initial_height; initial_range];

    % Calculates random time and position
    [random_time, random_position] = ode23('EqMotion', range_time, initial_position);
    
    % Updates sum of time and position with calculated random time and position
    time_sum = time_sum + random_time;
    position_sum = position_sum + random_position;



    % Plots randomized variables (to be repeated each iteration and cause
    % multiple lines)
    plot(random_position(:,4), random_position(:,3)); % Figure 2

    % Title and labels
    title('Trajectory Across One-Hundred Trials with Randomized Values');
    xlabel('Range (m)'); 
    ylabel('Height (m)'); 

    % adds grid to subplot
    grid;


end


% Calculates average time and position using updated time and position sum
% values
average_time = 1/100*(time_sum);
average_position = 1/100*(position_sum);



% Calculates curve fitting properites for average time and position from
% Monte Carlo
% Fitted for range
polyfit_1 = polyfit(average_time, average_position(:,4), 5);
polyval_1 = polyval(polyfit_1, average_time);

% Fitted for height
polyfit_2 = polyfit(average_time, average_position(:,3), 5);
polyval_2 = polyval(polyfit_2, average_time);


% first subplot
figure; % Figure 2
hold on;
subplot(2, 1, 1); 

% Plots Curve-fitted Range vs Time
plot(average_time, polyval_1);

% Title and label
title('Curve-Fitted Range vs Time');
xlabel('Time (s)'); 
ylabel('Range (m)'); 

% Adds grid to first subplot
grid;


% second subplot
subplot(2, 1, 2); 
hold on;

% Plots curve-fitted Height vs Time
plot(average_time, polyval_2);

% Title and labels
title('Curve-Fitted Height vs Time');
xlabel('Time (s)'); 
ylabel('Height (m)'); 

% Adds grid to second subplot
grid;



% Calculating and plotting range and height time derivatives
height_derivative = (diff(polyval_2))./(diff(average_time));
range_derivative = (diff(polyval_1))./(diff(average_time));


% Plots time derivative of height for fitted trajectory
figure; % Figure 3
subplot(2,1,1); 
hold on;

% Plots dh/dt vs average time from Monte Carlo trial
plot(average_time(2:end), height_derivative);

% Title and labels
title('Time Derivative of Height for Fitted Trajectories');
xlabel('Time (s)'); 
ylabel('Height (m)'); 

% Add grid to first subplot
grid;   

% Plots time derivative of range for fitted trajectory
subplot(2,1,2); 
hold on; 

% plots dr/dt vs average time from Monte Carlo trial
plot(average_time(2:end), range_derivative);

% Title and labels
title('Time Derivative of Range for Fitted Trajectories');
xlabel('Time (s)'); 
ylabel('Range (m)'); 

% Adds gridlines to second subplot
grid;