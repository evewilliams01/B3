function air_data = get_air_data(air_altitude)
% find air density, pressure, temperature, viscosity?, etc based on altitude

MSISE_data = [0     1.17e+00
20    9.49e-02
40    4.07e-03
60    3.31e-04
80    1.68e-05
100   5.08e-07
120   1.80e-08
140   3.26e-09
160   1.18e-09
180   5.51e-10
200   2.91e-10
220   1.66e-10
240   9.91e-11
260   6.16e-11
280   3.94e-11
300   2.58e-11
320   1.72e-11
340   1.16e-11
360   7.99e-12
380   5.55e-12
400   3.89e-12
420   2.75e-12
440   1.96e-12
460   1.40e-12
480   1.01e-12
500   7.30e-13
520   5.31e-13
540   3.88e-13
560   2.85e-13
580   2.11e-13
600   1.56e-13
620   1.17e-13
640   8.79e-14
660   6.65e-14
680   5.08e-14
700   3.91e-14
720   3.04e-14
740   2.39e-14
760   1.90e-14
780   1.53e-14
800   1.25e-14
820   1.03e-14
840   8.64e-15
860   7.32e-15
880   6.28e-15
900   5.46e-15];

alt = MSISE_data(:,1);
rho = MSISE_data(:,2);

isa_data = [
    0,    15.0,  101325,  1.225;
    1000,  8.5,   89875,  1.112;
    2000,  2.0,   79495,  1.0065;
    3000,  -4.5,  70109,  0.9091;
    4000,  -11.0, 61640,  0.8191;
    5000,  -17.5, 54020,  0.7361;
    6000,  -24.0, 47181,  0.6597;
    7000,  -30.5, 41061,  0.5895;
    8000,  -37.0, 35600,  0.5252;
    9000,  -43.5, 30742,  0.4664;
    10000, -50.0, 26436,  0.4127;
    11000, -56.5, 22632,  0.3639;
    12000, -56.5, 19330,  0.3108;
    13000, -56.5, 16510,  0.2655;
    14000, -56.5, 14102,  0.2268;
    15000, -56.5, 12045,  0.1937;
    16000, -56.5, 10287,  0.1654;
    17000, -56.5, 8787,   0.1413;
    18000, -56.5, 7505,   0.1207;
    19000, -56.5, 6410,   0.1031;
    20000, -56.5, 5475,   0.0880;
    25000, -51.5, 2511,   0.0395;
    30000, -46.5, 1172,   0.0180;
    35000, -36.1, 559,    0.0082;
    40000, -22.1, 278,    0.0039;
    45000, -8.1,  143,    0.0019;
    50000, -2.5,  76,     0.00098;
    55000, -13.7, 40,     0.00054;
    60000, -27.7, 20,     0.00029;
    65000, -41.7, 10,     0.00015;
    70000, -55.7, 5,      0.00007;
    75000, -66.5, 2,      0.00003;
    80000, -76.5, 1,      0.00002
    ];

% data from International Standard Atmosphere (ISA)
altitudes = isa_data(:,1); % metres
temperatures = isa_data(:,2); % celsius
pressures = isa_data(:,3); % Pa
densities = isa_data(:,4); % kg/m^3


% use isa for 80km and below, MSISE-90 between 80km and 900km
real_rho = [densities;rho(6:end)];
real_alt = [altitudes;1e3*alt(6:end)];

input_altitude = air_altitude - 6.371e6;
if input_altitude <= 900e3 % model has values for up to 900km
    % Interpolate temperature, pressure, and density for the random altitude
    % air_data.temperature = interp1(altitudes, temperatures, input_altitude, 'linear', 'extrap');
    % air_data.pressure = interp1(altitudes, pressures, input_altitude, 'linear', 'extrap');
    air_data.density = interp1(real_alt, real_rho, input_altitude, 'linear', 'extrap');

else
    air_data.temperature = 0;
    air_data.pressure = 0;
    air_data.density = 0;
end