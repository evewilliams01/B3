function cD = finddrag(air_data, characteristic_length, panels, dimensions)
    % Calculate Knudsen number
    kn = MFP/characteristic_length;
    R_air = 287; % Specific gas constant for air (J/kg*K)
    velocity = air_data.velocity;
    T_air = air_data.temperature;
    magnitude_v = norm(velocity);
    T_wall = air_data.wall_temperature;
    % Calculate freestream molecular speed ratio
    s = magnitude_v/sqrt(2*R_air*T_air);
    
    
    % Classify flow regime
    if kn > 10
        regime = "Free Molecular";
    elseif kn > 0.01 && kn <= 10
        regime = "Transition";
    else
        regime = "Continuum";
    end
    
    % Initialize drag coefficient with a default value
    cD = 0;

    % Calculate drag coefficient based on regime
    switch regime
        case "Free Molecular"
            cD = drag_coefficient_free_molecular(velocity,T_air, T_wall, 0.9, 0.9, panels,dimensions,s);
        case "Transition"
            cD_fm = drag_coefficient_free_molecular(s, T_air, T_wall);
            cD_continuum = drag_coefficient_continuum(velocity, altitude, panels,W,H);
            cD = drag_coefficient_transition(cD_continuum, cD_fm, kn);
        case "Continuum"
            cD = drag_coefficient_continuum(velocity, altitude, panels);
    end

end

function cD_fm = drag_coefficient_free_molecular(velocity, T_air,T_wall, sigma_N, sigma_T, panels,dimensions,s)
    % Calculate drag coefficient contribution from free molecular regime

    
    % Freestream velocity   
    V_hat = velocity / norm(velocity); % Normalize freestream velocity in inertial frame
    
    W = dimensions(2); % Width (m)
    H = dimensions(3); % Height (m)
    cD_fm = 0; % Initialize drag coefficient contribution from free molecular regime
    ref_area = W * H; % Assuming the front face is the reference area

   % Calculate contributions from each panel
   for i = 1:length(panels)
    n_hat = panels(i).n_hat; % Normal vector for the panel
    S_i = panels(i).S;       % Area of the panel
    
    % Tangent vector for the panel
    t_hat = cross(n_hat, cross(V_hat, n_hat));
    t_hat = t_hat / norm(t_hat);
    
    % Inclination angle (theta_i)
    theta_i = arccos(dot(n_hat, V_hat))-pi/2;
   
    if theta_i > 0
    
        % Pressure coefficient (Cp)
        cp_i = (1/s^2)*(((s-simga_N)/sqrt2+sigma_N/2*sqrt(T_wall/T_air))*exp(-s^2*sin(theta_i)^2)+...
            ((2-simga_N)*((1.2+s^2*sin(theta_i)^2)+sigma_N/2*sqrt(T_wall*pi/T_air)*s*sin(theta_i)*(1+erf(s*sin(theta_i))))));
    
        % Shear stress coefficient (Ct)
        ct_i = (sigma_T * cos(theta_i)) / (s * sqrt(pi)) * ...
               (exp(-s^2 * sin(theta_i)^2) + sqrt(pi) * s * sin(theta_i) * ...
               (1 + erf(s * sin(theta_i))));
    else
        cp_i = 0;
        ct_i = 0;
    
     % Drag coefficient contribution from the panel
    cD_fm = cD_fm + (1 / ref_area) * ...
        (-cp_i * dot(n_hat, V_hat) + ct_i * dot(t_hat, V_hat)) * S_i;
    end
                                           
    end
 
end



 % Get atmospheric properties at the given altitude
 [~, ~, ~, rho, T_inf] = atmosisa(altitude);
air_data.rho = rho;
air_data.T_inf = T_inf;
