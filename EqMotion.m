function xdot = EqMotion(t,x)
%	Fourth-Order Equations of Aircraft Motion

	global C_L C_D s mass grav rho
	
	V 	=	x(1);
	Gam	=	x(2);
	q	=	0.5 * rho * V^2;	% Dynamic Pressure, N/m^2
	
	xdot	=	[(-C_D * q * s - mass * grav * sin(Gam)) / mass
				 (C_L * q * s - mass * grav * cos(Gam)) / (mass * V)
				 V * sin(Gam)
				 V * cos(Gam)];
end