% Reentry Simulation of a Spherical Object - addition of heat flux
%Hemisphere approximation, trajectory simplified - get data from Cam, air density modeled
%using exponential, Cd constant

% Constants
R_earth = 6371e3;           % Radius of the Earth (m)
g0 = 9.81;                  % Surface gravitational acceleration (m/s^2)
H = 8500;                   % Scale height of the atmosphere (m)
rho0 = 1.225;               % Atmospheric density at sea level (kg/m^3)
Cd = 0.5;                   % Drag coefficient (dimensionless, spherical assumption)
r = 0.1;                    % Radius of the sphere (m)
A = pi * r^2;               % Cross-sectional area (m^2)
m = 8;                      % Mass of the object (kg)
K = 1.7415e-4;              % Heat transfer coefficient
emi = 0.8;                  % Emissivity - only a guess
sigma = 5.67e-8;            % Boltzman constant

% IC
altitude = 400e3;           % Initial altitude (m)
velocity = -7800;           % Initial velocity (m/s) 
time_step = 0.1;            % Time step (s)
end_time = 500;              % Simulation duration (s)

% Initialise Variables
t = 0:time_step:end_time;   % Time vector
h = zeros(size(t));         % Altitude (m)
v = zeros(size(t));         % Velocity (m/s)
a = zeros(size(t));         % Acceleration (m/s^2)
drag_force = zeros(size(t));% Drag force (N)
density = zeros(size(t));   % Atmospheric density (kg/m^3)
qw = zeros(size(t));        % Heat flux due to convection
temperature = zeros(size(t)); %temperature in kelvin

h(1) = altitude;
v(1) = velocity;

% Simulation 
for i = 1:length(t)-1
    % Atmospheric density at current altitude
    rho = rho0 * exp(-h(i)/H);
    density(i) = rho;  

    %Convective heat flux - Graves Sutton
    qw(i) = K*(rho/r)^0.5*abs(v(i))^3;

    %Temperature based on heat flux balence - Stefan Boltzman
    temperature(i) = (qw(i)/(emi*sigma))^0.25;
    
    % Gravitational acceleration at current altitude
    g = g0 * (R_earth / (R_earth + h(i)))^2;
    
    % Drag force
    Fd = 0.5 * rho * v(i)^2 * Cd * A * sign(v(i)); 
    drag_force(i) = Fd;
    
    % Net acceleration
    a(i) = -Fd/m - g;
    
    % Update velocity
    v(i+1) = v(i) + a(i) * time_step;
    
    % Update altitude
    h(i+1) = h(i) + v(i) * time_step; 

    % Stop 
    if h(i+1) <= 0
        h(i+1:end) = 0;
        v(i+1:end) = 0;
        density(i+1:end) = 0;
        break;
    end
end


t = t(1:i);
h = h(1:i);
v = v(1:i);
a = a(1:i);
drag_force = drag_force(1:i);
density = density(1:i);
temperature = temperature(1:i);


figure;

subplot(5,1,1);
plot(t, h/1e3);
xlabel('Time (s)');
ylabel('Altitude (km)');
title('Altitude vs Time');

subplot(5,1,2);
plot(t, v);
xlabel('Time (s)');
ylabel('Velocity (m/s)');
title('Velocity vs Time');

subplot(5,1,3);
plot(t, drag_force);
xlabel('Time (s)');
ylabel('Drag Force (N)');
title('Drag Force vs Time');

subplot(5,1,4);
plot(t, density);
xlabel('Time (s)');
ylabel('Density (kg/m^3)');
title('Atmospheric Density vs Time');

subplot(5,1,5);
plot(t, temperature);
xlabel('Time (s)');
ylabel('Temperature (K)');
title('Temperature on outside of heat shield vs Time');