tic
% find earth parameters
earth
% chose altitude, velocity, eccentricity and incline
altitude0 = 400e3;
e = 0;
v0 = sqrt(G*M*(1+e)/(altitude0+R));
incline = 51.64*pi/180; % first number in degrees tilted from the equator
% Example initial conditions
state.x0 = R + altitude0; % initial x position (m)
state.y0 = 0; % initial y position (m)
state.z0 = 0; % initial z position (m)
state.vx0 = 0; % initial x velocity (m/s)
state.vy0 = v0*cos(incline);  % initial y velocity (m/s)
state.vz0 = -v0*sin(incline); % initial z veloctiy (m/s)




% calculate time window
semi_major = norm([state.x0,state.y0])/(1-e); % assuming starting point is the periapsis
tend = 2*pi/sqrt(G*M)*semi_major^(3/2); % (s) can change formula or arbitary
no_orbits = 1;
tspan = [0, tend*no_orbits];

global drag_forces velocities; % Declare the global variable
drag_forces = [];  
velocities = [];

%calculate trajectory using ode45 (a 4,5 runge-kutta, Dormand-Prince
%numerical integrator)

opts = odeset('Events',@reached_surface,RelTol=1e-7);
[t,orbit_state] = ode45(@odefunc,tspan,[state.x0;state.y0;state.z0;state.vx0;state.vy0;state.vz0],opts);

% Extract drag force and velocity data
drag_time = drag_forces(:, 1);       % Time values for drag force
drag_magnitude = drag_forces(:, 2); % Drag force magnitudes

velocity_time = velocities(:, 1);       % Time values for velocity
velocity_magnitude = velocities(:, 2); % Velocity magnitudes

% Plot drag force over time
figure;
plot(drag_time, drag_magnitude, 'r');
xlabel('Time (s)');
ylabel('Drag Force (N)');
title('Drag Force Over Time');
grid on;

% Plot velocity over time
figure;
plot(velocity_time, velocity_magnitude, 'b');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
title('Velocity Over Time');
grid on;

toc