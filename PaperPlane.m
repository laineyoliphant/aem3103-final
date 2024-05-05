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
