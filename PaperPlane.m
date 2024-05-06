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

CL_alpha = pi * AR/(1 + sqrt(1 + (AR/2)^2)); 
k =	1/(pi * e * AR); % Induced drag factor
CD0 = 0.02;	% Zero-lift drag coefficient
CL = sqrt(CD0/k);	% CL max 
CD = CD0 + k * CL^2; % Drag polar
LD_max = CL/CD; % L/D max
aoa =	CL/CL_alpha; % Angle of attack

H =	2; % Initial height (m)
R =	0;	% Initial range (m)
R_max = 25; % Max range (m)
to = 0;	% Initial time (s)
tf = 6;	% Final time (s)
tspan = [to tf]; % Range of time (s)

% Variation in simulated parameters (three conditions)

gamma_1 = -atan(1/LD_max); % Corresponding Flight Path Angle, rad
gamma_2 = -0.5;
gamma_3 = 0.4;
v1 = sqrt(2 * m * g /(rho * S * (CL * cos(gamma_1) - CD * sin(gamma_1))));
v2 = 2;
v3 = 7.5; % Corresponding Velocity, m/s

x0 = [v1; gamma_1; H; R];
[ta, xa] = ode23('EqMotion', tspan, x0); %Calls EqMotion file

x1 = [v1; gamma_2; H; R];
[tb, xb] = ode23('EqMotion', tspan, x1);

x2 = [v1; gamma_3; H; R];
[tc, xc] = ode23('EqMotion', tspan, x2);	

y1 = [v2; gamma_1; H; R];
[ta2, xa2] = ode23('EqMotion', tspan, y1);

y2 = [v3; gamma_1; H; R];
[tb2, xb2] = ode23('EqMotion', tspan, y2);

% Visualize the different conditions and plot
figure; % Figure 1
subplot(2,1,1);
hold on;
plot(xa(:,4),xa(:,3),'k',xa2(:,4),xa2(:,3),'r',xb2(:,4),xb2(:,3),'g'); %varies v0 condition
title('Height vs Range for Various Velocities');
xlabel('Range (m)'); 
ylabel('Height (m)');
grid;
legend(sprintf("Velocity 1 = %g", v1), sprintf("Velocity 2 = %g", v2), sprintf("Velocity 3 = %g", v3));

subplot(2,1,2);
hold on;
plot(xa(:,4), xa(:,3),'k', xb(:,4), xb(:,3),'r', xc(:,4), xc(:,3),'g'); % varies FPA condition
title('Height vs Range for Various Flight Path Angles');
xlabel('Range (m)'); 
ylabel('Height (m)'); 
grid;
legend(sprintf("Gamma 1 = %g", gamma_1), sprintf("Gamma 2 = %g", gamma_2), sprintf("Gamma 3 = %g", gamma_3)); 

% Conduct randomized trials for simultaneous variations
figure; 
hold on;
t_range = linspace(0, 6, 100);
t_sum = 0;
x_sum = 0;

for i = 1:100 
    randomV = v2 + (v3 - v2) * rand(1);
    randomGamma = gamma_2 + (gamma_3 - gamma_2) * rand(1);
    xo = [randomV; randomGamma; H; R];
    [t_rand, x_rand] = ode23('EqMotion', t_range, xo);
    t_sum = t_sum + t_rand;
    x_sum = x_sum + x_rand;
    plot(x_rand(:,4), x_rand(:,3)); % Figure 2
    title('Trajectory Across One-Hundred Trials with Randomized Values');
    xlabel('Range (m)'); 
    ylabel('Height (m)'); 
    grid;

end

t_avg = t_sum/100;
x_avg = x_sum/100;

% Curve-fitting data and plotting average trajectories
fit1 = polyfit(t_avg, x_avg(:,4), 5);
val1 = polyval(fit1, t_avg);
fit2 = polyfit(t_avg, x_avg(:,3), 5);
val2 = polyval(fit2, t_avg);

figure; % Figure 2
hold on;
subplot(2, 1, 1); 
plot(t_avg, val1);
title('Curve-Fitted Range vs Time');
xlabel('Time (s)'); 
ylabel('Range (m)'); 
grid;

subplot(2, 1, 2); 
hold on;
plot(t_avg, val2);
title('Curve-Fitted Height vs Time');
xlabel('Time (s)'); 
ylabel('Height (m)'); 
grid;

% Calculating and plotting range and height time derivatives
dhdt = diff(val2)./diff(t_avg);
drdt = diff(val1)./diff(t_avg);

figure; % Figure 3
subplot(2,1,1); 
hold on;
plot(t_avg(2:end), dhdt);
title('Time Derivative of Height for Fitted Trajectories');
xlabel('Time (s)'); 
ylabel('Height (m)'); 
grid;   

subplot(2,1,2); 
hold on; 
plot(t_avg(2:end), drdt);
title('Time Derivative of Range for Fitted Trajectories');
xlabel('Time (s)'); 
ylabel('Range (m)'); 
grid;