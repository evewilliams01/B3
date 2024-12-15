function [value, isterminal, direction] = reached_surface(t, state)
% this function is terminates the ode45 calculation when the satellite
% reaches the surface.

earth % call earth.m to get the radius
value = norm(state(1:3))-R; % terminate when altitude = 0
isterminal = 1;
direction = 0;