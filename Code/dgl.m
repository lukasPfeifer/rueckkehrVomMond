close all;
clear;
global m0 dm v_gas G M  brennschluss deltaPhi m0_min angle_deg
angle_deg = 0; %Aktueller Winkel im Vergleich zum normalen Vektor vom Mond
dm      = 20;   %Gewichtsabnahme pro Zeitschritt
m0 = 220;%3700; %Anfangsgewicht um auf 3,5k m/s zu kommen ca. 800-900 
m0_min  = 97;  %Endgewicht
v0=0;           %Anfangsgeschwindigkeit
v_gas   = 2500;             %Austrittsgeschwindigkeit des Gases
G       = 6.67430*10^-11;   %Gravitationskonstante
M       = 7.3483*10^22;     %Mondmasse
h       = 1737.4*10^3;      %Starthöhe, entspricht Radius des Mondes, cant be global or it will not work anymore
deltaPhi = 0.5;
orbitHeight = 400000;%400km height of orbit
vOrbit = sqrt(G*M/orbitHeight);%velocity to stay in orbit
disp(vOrbit)

brennschluss = ceil((m0-m0_min) / dm);
tspan= 0:0.1:(brennschluss+50000);
startPosX = 0;
startPosY = h;
startVX = 0;
startVY = 0;

[tspan,pos]=ode45(@bdgl, tspan, [startPosX;startVX;startPosY;startVY]);
sX = pos(:,1);
sY = pos(:,3);
vX = pos(:,2);
vY = pos(:,4);
figure
plot(tspan,sX);
title('sX');
figure
plot(tspan,sY);
title('sY');
figure
plot(tspan,vX);
title('vX');
figure
plot(tspan,vY);
title('vY');
figure
plot(sX,sY);
title('s');
figure
plot(tspan,sqrt(vX.^2+vY.^2));
title('v');

%plot circle
figure
hold on
th = 0:pi/50:2*pi;
xunit = h * cos(th);
xUnit2 = (orbitHeight + h) * cos(th);
yunit = h * sin(th);
yUnit2 = (orbitHeight +h)* sin(th);
plot(xunit, yunit);
plot(xUnit2,yUnit2);
plot(sX,sY);
title('moon, destinated orbit and rocket trajectory');
hold off

%y(1):sX  y(2):vX  y(3):sY  y(4):vY
function [fx] = bdgl(t,y)
global m0 dm v_gas G M  brennschluss deltaPhi m0_min angle_deg
%h       = 1737.4*10^3;      %start height, radius of moon
%h = h+sqrt(y(2)^2+y(4)^2)*t;%calculate height, only for start because not vektorial at the moment
h = sqrt(y(1)^2+y(3)^2);
if(t < brennschluss)
    m = m0 - dm*t;                  %calculate the rocket mass over time
else
    m = m0_min; %if brennschlusss then no more loss of mass
end
if(t < brennschluss)
    if(t < 2.5)
        aRakete = (dm*v_gas)/(m0-dm*t)*[0;1]; %acceleration of rocket vektorial for start
    elseif(angle_deg <= 90)
        %angle before deltaPhi defines the starting angle at which rocket
        %will turn, pi/2 is in y direction, pi/4 is middle between y and x
        %axis so 45 degree
        %aRakete = (dm*v_gas)/(m0-dm*t)*[cos(-deltaPhi*(t-2) + pi/2); sin(-deltaPhi*(t-2) + pi/2)];
        aRakete = (dm*v_gas)/(m0-dm*t)*[1;0];%acceleration of rocket vektorial for curve
        % Calculate the current total rotation
        currentAngle = subspace([y(1);y(3)], [y(2); y(4)]);
        angle_deg = rad2deg(currentAngle);
        %disp(angle_deg)
        %disp(pi/2-deltaPhi*t);
    %else 
        %aRakete = (dm*v_gas)/(m0-dm*t)*[cos(-deltaPhi*(2) + pi/2); sin(-deltaPhi*(2) + pi/2)];
    end
else
    %disp(sqrt(y(2)^2 + y(4)^2));
    aRakete = [0;0];
end
aG = G*(M+m)/h^2 * [-y(1)/h;-y(3)/h];%gravitation acceleration of moon vektorial
a = aRakete + aG ; %combined acceleration vektorial
% if(t < 5000)
%      fprintf('t: %2.4f and h: %4.4f\n',t,h);
% end
dxdt = [y(2);a(1)];%vX,aX
dydt = [y(4);a(2)];%vY,aY
fx = [dxdt;dydt];
end

