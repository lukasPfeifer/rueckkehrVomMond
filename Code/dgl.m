global m0 dm v_gas G M  brennschluss deltaPhi m0_min deltaTBrennschluss crashed radiusMoon startAngle
dm      = 20;   %Gewichtsabnahme pro Zeitschritt
m0 = 3500;%3700; %Anfangsgewicht um auf 3,5k m/s zu kommen ca. 800-900 
m0_min  = 1000;  %Endgewicht
v0=0;           %Anfangsgeschwindigkeit
v_gas   = 2000;             %Austrittsgeschwindigkeit des Gases
G       = 6.67430*10^-11;   %Gravitationskonstante
M       = 7.3483*10^22;     %Mondmasse
h       = 1737.4*10^3;      %Starthöhe, entspricht Radius des Mondes, cant be global or it will not work anymore
radiusMoon = 1737.4*10^3;
startAngle = pi/4;


orbitHeight = 400000;%400km height of orbit
vOrbit = sqrt(G*M/orbitHeight);%velocity to stay in orbit

brennschluss = ceil((m0-m0_min) / dm);
tspan= 0:0.1:(brennschluss+40000);
startPosX = 0;
startPosY = h;
startVX = 0;
startVY = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%for loop for tessting and plotting different scenarios

for i=18:2:22
    deltaTBrennschluss = i;
    endAngle = -pi/4-0.1;
    figure
    hold on
    th = 0:pi/50:2*pi;
    xunit = radiusMoon * cos(th);
    %xUnit2 = (orbitHeight + radiusMoon) * cos(th);
    yunit = radiusMoon * sin(th);
    %yUnit2 = (orbitHeight + radiusMoon)* sin(th);
    plot(xunit, yunit);
   % plot(xUnit2,yUnit2);
%     plot(sX2,sY2);
%     plot(sX3,sY3);
    %axis([-4*10^6 4*10^6 -5*10^6 5*10^6])
    for j=(startAngle - endAngle)/(brennschluss-deltaTBrennschluss)*0.9:(startAngle - endAngle)/(brennschluss-deltaTBrennschluss)*0.1:(startAngle - endAngle)/(brennschluss-deltaTBrennschluss)*1.1
        crashed = false;
        deltaPhi = j;
        [tspan,pos1]=ode45(@bdgl, tspan, [startPosX;startVX;startPosY;startVY]);
        disp(crashed+", "+deltaPhi+", "+deltaTBrennschluss);
        %     crashed = false;
        %     endAngle = -pi/4-0.1;
        %     deltaPhi = (startAngle - endAngle)/(brennschluss-deltaTBrennschluss);
        %     [tspan,pos2]=ode45(@bdgl, tspan, [startPosX;startVX;startPosY;startVY]);
        %     disp(crashed+", "+deltaPhi+", "+deltaTBrennschluss);
        %     crashed = false;
        %     endAngle = -pi/4+0.1;
        %     deltaPhi = (startAngle - endAngle)/(brennschluss-deltaTBrennschluss);
        %     [tspan,pos3]=ode45(@bdgl, tspan, [startPosX;startVX;startPosY;startVY]);
        %     disp(crashed+", "+deltaPhi+", "+deltaTBrennschluss);
        sX1 = pos1(:,1);
        sY1 = pos1(:,3);
        vX1 = pos1(:,2);
        vY1 = pos1(:,4);
        plot(sX1,sY1);
    end
    axis([-5.5*10^6 5.5*10^6 -5.5*10^6 5.5*10^6])
    title('moon, destinated orbit and rocket trajectory');
    hold off
    legend('moon','rocket trajectory1','rocket trajectory2','rocket trajectory3');
%     sX2 = pos2(:,1);
%     sY2 = pos2(:,3);
%     vX2 = pos2(:,2);
%     vY2 = pos2(:,4);
%     sX3 = pos3(:,1);
%     sY3 = pos3(:,3);
%     vX3 = pos3(:,2);
%     vY3 = pos3(:,4);

    %plot v
%     figure
%     hold on
%     plot(tspan,sqrt(vX1.^2+vY1.^2));
%     plot(tspan,sqrt(vX2.^2+vY2.^2));
%     plot(tspan,sqrt(vX3.^2+vY3.^2));
%     title('v');
%     hold off
%     legend('v1','v2','v3');

    %plot moon, orbit and trajectory
%     figure
%     hold on
%     th = 0:pi/50:2*pi;
%     xunit = h * cos(th);
%     xUnit2 = (orbitHeight + h) * cos(th);
%     yunit = h * sin(th);
%     yUnit2 = (orbitHeight +h)* sin(th);
%     plot(xunit, yunit);
%     plot(xUnit2,yUnit2);
%     plot(sX1,sY1);
%     plot(sX2,sY2);
%     plot(sX3,sY3);
%     %axis([-4*10^6 4*10^6 -5*10^6 5*10^6])
%     title('moon, destinated orbit and rocket trajectory');
%     hold off
%     legend('moon','destinated orbit','rocket trajectory1','rocket trajectory2','rocket trajectory3');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%y(1):sX  y(2):vX  y(3):sY  y(4):vY
function [fx] = bdgl(t,y)
global m0 dm v_gas G M  brennschluss deltaPhi m0_min deltaTBrennschluss crashed radiusMoon startAngle
%h       = 1737.4*10^3;      %start height, radius of moon
%h = h+sqrt(y(2)^2+y(4)^2)*t;%calculate height, only for start because not vektorial at the moment
h = sqrt(y(1)^2+y(3)^2);
if(h < radiusMoon)
    crashed = true;
    %disp(h);
end
if(t < brennschluss)
    m = m0 - dm*t;                  %calculate the rocket mass over time
else
    m = m0_min; %if brennschlusss then no more loss of mass
end

%if(t < deltaTBrennschluss || ((t > deltaTBrennschluss + 5) && (t < brennschluss + 5)))
if(t < brennschluss)
    if(t < deltaTBrennschluss)%until deltaTBrennschluss just start without turning
        aRakete = (dm*v_gas)/(m0-dm*t)*[0;1]; %acceleration of rocket vektorial for start
    else
        %angle before deltaPhi defines the starting angle at which rocket
        %will turn, pi/2 is in y direction, pi/4 is middle between y and x
        %axis so 45 degree
        aRakete = (dm*v_gas)/(m0-dm*t)*[cos(startAngle-deltaPhi*(t-deltaTBrennschluss));sin(startAngle-deltaPhi*(t-deltaTBrennschluss))]; %acceleration of rocket vektorial for curve
        %disp(pi/2-deltaPhi*t);
    end
else
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
