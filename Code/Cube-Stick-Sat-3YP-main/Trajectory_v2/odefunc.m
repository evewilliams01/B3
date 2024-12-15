function dstatedt = odefunc(t, state)
    % Import Earth and CubeSat parameters
    earth; cubesat; % Load Earth and satellite parameters
    
    % Constants
    global drag_forces velocities; % Declare global variables
    
    % Extract satellite state
    position = state(1:3);    % Current position (x, y, z)
    velocity = state(4:6);    % Current velocity (vx, vy, vz)
    magnitude_r = norm(position); % Distance from Earth's center
    magnitude_v = norm(velocity); % Magnitude of velocity
    
    % Check if the satellite has reached the Earth's surface
    if magnitude_r <= R
        error('Satellite has reached the surface of the Earth.');
    end
    
    % Unit direction vectors
    direction_r = position / magnitude_r;
    direction_v = velocity / magnitude_v;

    % Gravitational force
    Fg = -(G * M * m / magnitude_r^2) * direction_r;

    % Atmospheric density
    air_data = get_air_data(magnitude_r); % Function to get air density
    density = air_data.density;

    % Drag force
    Fd = -(0.5 * Cd * density * magnitude_v^2) * A * direction_v;
    v = (velocity(1)^2+velocity(2)^2+velocity(3)^2)^(1/2);
    
    %Convective heat flux - Graves Sutton
    qw = K*(rho0/r)^0.5*abs(v)^3;

    %Temperature based on heat flux balence - Stefan Boltzman
    temperature = (qw/(emi*sigma))^0.25;

    % Save drag force and velocity
    drag_forces = [drag_forces; t, norm(Fd)];
    velocities = [velocities; t, magnitude_v];

    % Total force and acceleration
    F = Fg + Fd;             % Net force
    acceleration = F / m;    % Acceleration (Newton's second law)

    % Return state derivatives
    dstatedt = [velocity; acceleration;temperature];
end
