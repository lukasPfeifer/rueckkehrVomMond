% Constants
mu = 4.9048695e12; % gravitational parameter of the moon
Ve = 3.15e3; % effective exhaust velocity of the rocket
Mo = 100; % initial mass of the rocket (kg)
Mf = 90; % final mass of the rocket (kg)

% Rocket equation
dv = Ve*log(Mo/Mf);

% Initial velocity
vo = sqrt(mu/moon_distance); % moon_distance is the distance from the point mass to the center of the gravitational field

% Final velocity
vf = vo + dv;

% Orbit equation
r = (mu/vf^2);

% Plotting the rocket's flight before orbit
time = linspace(0, dv/Ve); % time of flight before orbit
x = 0*time; % rocket starts at the origin
y = vo*time; % rocket moves upward
z = 0*time; % rocket moves only in the XY plane
plot3(x,y,z,'r');
hold on

% Plotting the orbit
theta = linspace(0, 2*pi);
x = r*cos(theta);
y = r*sin(theta);
z = 0*theta; % orbit is in the XY plane
plot3(x, y, z);
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
title('Rocket flight and lunar orbit in 3D');
legend('Rocket flight','Lunar orbit')
