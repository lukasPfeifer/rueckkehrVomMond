format long;
dm      = 20;   %Gewichtsabnahme pro Zeitschritt
m0      = 3700; %Anfangsgewicht
m0_min  = 100;  %Endgewicht
v0=0;           %Anfangsgeschwindigkeit
v_gas   = 2500;             %Austrittsgeschwindigkeit des Gases
G       = 6.67430*10^-11;   %Gravitationskonstante
M       = 7.3483*10^22;     %Mondmasse
h       = 1737.4*10^3;      %Starthöhe, entspricht Radius des Mondes

brennschluss = ceil((m0-m0_min) / dm);
tspan= 0:0.001:10;
y0 = 0;
%posX = 0;
%posY = h;
%VX = 0;
%VY = 0;
pos= [0;h];
V = [0;0];
a = [0;0];
y = [pos;V]
%bdgl(0,pos,V)
[tspan,pos]=ode45(@bdgl, tspan, [0,h;0,0]);
sX = pos(:,1);
sY = pos(:,3);
vX = pos(:,2);
vY = pos(:,4);%macht als einzige sinn
% aX = pos(:,5);
% aY = pos(:,6);
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
%figure
% plot(t,aX);
% title('aX');
% figure
% plot(t,aY);
% title('aY');
%plot(pos(1),pos(2));

function [fx] = bdgl(t,y)
dm      = 20;   %Gewichtsabnahme pro Zeitschritt
m0      = 3700; %Anfangsgewicht
m0_min  = 100;  %Endgewicht
v0=0;           %Anfangsgeschwindigkeit
v_gas   = 2500;             %Austrittsgeschwindigkeit des Gases
G       = 6.67430*10^-11;   %Gravitationskonstante
M       = 7.3483*10^22;     %Mondmasse
h       = 1737.4*10^3;      %Starthöhe, entspricht Radius des Mondes


%v = -v_gas*log(1-(dm*t)/m0);    %Raketengleichung: Geschwindigkeit
%h = h+v*t;  %gilt nur solange wir senkrecht fliegen
%y(4) = -v_gas*log(1-(dm*t)/m0);
h = h+sqrt(y(2)^2+y(4)^2)*t;
m = m0 - dm*t;                  %Masse der Rakete über Zeit 
%fg = G*m*M/(h^2);%Gravitationskraft des Mondes
if(t < 5)
    aRakete = (dm*v_gas)/(m0-dm*t)*[0.000000;1.000000]; %Beschleunigung der Rakete
else
    aRakete = [0;0];
end
%fb = m*aRakete;                 %Beschleunigungskraft
%aG = G*(M+m)/h^2;               %Gravitationsbeschleunigung
aG = G*(M+m)/h^2 * [-y(1)/h;-y(3)/h];%gravitation vektoriell
%disp(aG);
a = aRakete + aG ;             %Gesamtbeschleunigung
fprintf('t: %2.4f and vX: %8.4f and h: %4.4f and m: %4.2f and aX: %4.4f and aY: %4.4f\n',t,y(3),h,m,a(1),a(2));
% if(t > 5 && t < 7)
%     disp('a: ');
%     disp(a);
%     disp('aR: ');
%     disp(aRakete);
%     disp(' aG: ');
%     disp(aG);
% end
%dxdt = [y(3);a(1)];
%dydt = [y(4);a(2)];
dxdt = [y(2);a(1)];
dydt = [y(4);a(2)];
fx = [dxdt;dydt];
if(t<0.001)
    disp(y);
    disp(fx);
end
end
