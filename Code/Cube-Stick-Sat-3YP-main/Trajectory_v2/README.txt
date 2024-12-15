IMPORTANT: The current state of the code does not account for the spin of the earth, either through using an Earth-Centred Inertial (ECI)
reference frame and accounting for the rotation of the atmosphere OR by using an Earth-Centred, Earth-Fixed (ECEF) frame and introducing
ficticious forces (coriolis, centrifugal). Intend to discuss this on Tuesday (12/11).

ALSO: I'm aware the plots all mention the ISS - its a general simulation, it works for the cubesat also with the correct parameters.


Run test.m to run the code.
    test.m parameters to change:
        altitude0 - the initial height above the surface
        e - the eccentricity of the orbit (this will change over time when affected by drag)
        incline - the inclination of orbit (first number is degrees above the equator)
        no_of_orbits - the number of orbits the simulation should run for (this assumes no drag effects and sets a relevant time period. 
                        The simulation will stop if altitude reaches 0.)
        linewidth in line 42 - can make this 3/4 for a thicker orbit plot line, or 1 to see the detail.

use earth.m to vary the parameters of the earth
    earth.m parameters to change:
        R - radius of the planet in metres
        M - mass of planet in kg

use cubesat.m to vary the satellite parameters (ie. to simulate the ISS or our sat)
    cubesat.m parmeters to change:
        A - relevant drag area (ie nose cross-section)
        Cd - drag coefficient
        m - satellite mass in kg
    All of these can be changing via functions if necessary.

get_air_data currently is only used to obtain density measurements
    it makes use of the International Standard Atmosphere (ISA) from 0km to 80km
    and mean values from the MSISE-90 (mean as solar activity causes massive variation) above 80km and up to 900km
    LIKELY use another model in the end from thermo.

odefunc.m - this sets up the ODE for the numerical integrator to solve
    it includes the forces and the state and d(state)/dt
    not recommended to modify this other than to add additionaly forces

reached_surface.m - this is an event function that ends the simulation if the satellite reaches the surface
    do not modify.