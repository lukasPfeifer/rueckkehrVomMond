global m0 dm v_gas G M  brennschluss deltaPhi m0_min deltaTBrennschluss  startAngle heights flag svd_t extra_boost matlab_fix hohmann_const
dm      = 20;   % Weight loss per time step
m0 = 3500;      % Initial weight
m0_min  = 1000; % Final weight
v0=0;           % Initial speed
v_gas   = 2000;             %Outlet velocity of the gas
G       = 6.67430*10^-11;   %Gravitational constant
M       = 7.3483*10^22;     %Lunar mass
h       = 1737.4*10^3;      %Start altitude, corresponds to radius of the moon
radiusMoon = 1737.4*10^3;
startAngle = pi/4;          
flag = 1;                   % extremum already found
svd_t = 0;                  % saved time if extremum found
hohmann_const = 1;          % speed of the rocket at extremum
matlab_fix = 0;
extra_boost = 0;
heights=[h h;
         0 0;
         0 0];

brennschluss = ceil((m0-m0_min) / dm) - hohmann_const;
tspan= 0:0.1:(brennschluss+100000);
startPosX = 0;
startPosY = h;
startVX = 0;
startVY = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%for loop for tessting and plotting different scenarios

for i=18:2:18
    deltaTBrennschluss = i;
    endAngle = -pi/4-0.1;
    figure
    hold on
    th = 0:pi/50:2*pi;
    xunit = radiusMoon * cos(th);
    yunit = radiusMoon * sin(th);
    plot(xunit, yunit);
    deltaPhi=(startAngle - endAngle)/(brennschluss-deltaTBrennschluss)*0.9; % angle which acceleration changes over time
    flag = 1;
        svd_t = 0;
        extra_boost = 0;
        matlab_quickfix = 0;
        [tspan,pos1]=ode45(@bdgl, tspan, [startPosX;startVX;startPosY;startVY]);
        
        sX1 = pos1(:,1);
        sY1 = pos1(:,3);
        vX1 = pos1(:,2);
        vY1 = pos1(:,4);
        plot(sX1,sY1);
    axis([-5.5*10^6 5.5*10^6 -5.5*10^6 5.5*10^6])
    title('moon, destinated orbit and rocket trajectory');
    hold off
    legend('moon','rocket trajectory1');

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%y(1):sX  y(2):vX  y(3):sY  y(4):vY
function [fx] = bdgl(t,y)
global m0 dm v_gas G M  brennschluss deltaPhi m0_min deltaTBrennschluss startAngle heights flag svd_t extra_boost matlab_fix hohmann_const
h = sqrt(y(1)^2+y(3)^2); %calculate height, only for start because not vektorial at the moment

% start hohmann manover
if(heights(1,1) < heights(1,2)&&  heights(1,2) > h && flag && y(1)< -2*10e6 && y(3) < 0)
    flag = 0;
    extra_boost = 1;
    svd_t = t;
end

% log old positions and heights
heights(1,1) = heights(1,2);
heights(2,1) = heights(2,2);
heights(3,1) = heights(3,2);
heights(1,2) = h;
heights(2,2) = y(1);
heights(3,2) = y(3);

if(t < brennschluss)
    m = m0 - dm*t;                  %calculate the rocket mass over time
else
    if(svd_t == 0)
        m = m0 - dm*brennschluss; %if brennschlusss then no more loss of mass
    else
        if((svd_t+hohmann_const)<t) % time slot for hohmann manover
            m = m0 - dm*(brennschluss+t-svd_t);
        else
            m = m0_min;
        end
    end
end

if(t < brennschluss)
    if(t < deltaTBrennschluss)%until deltaTBrennschluss just start without turning
        aRakete = (dm*v_gas)/(m0-dm*t)*[0;1]; %acceleration of rocket vektorial for start
    else
        %angle before deltaPhi defines the starting angle at which rocket
        %will turn, pi/2 is in y direction, pi/4 is middle between y and x
        %axis so 45 degree
        aRakete = (dm*v_gas)/(m0-dm*t)*[cos(startAngle-deltaPhi*(t-deltaTBrennschluss));sin(startAngle-deltaPhi*(t-deltaTBrennschluss))]; %acceleration of rocket vektorial for curve
    end
else
    % only extra speed at extremum
    if(extra_boost == 1)
        % matlab jumps backwards with the time --> FIX MATLAB
        if(m == m0_min && t > matlab_fix)
            x_coord = heights(2,2)-heights(2,1); % calculate x
            y_coord = heights(3,2)-heights(3,1); % calcualte y
            coord_angle = angle(x_coord + 1i *y_coord); % calculated angle for hohman manover
            aRakete = (dm*v_gas)/(m0-dm*t)*[cos(coord_angle);sin(coord_angle)];
        else
            aRakete = [0;0];
        end
    else
        aRakete = [0;0];
    end
end
matlab_fix = t;
aG = G*(M+m)/h^2 * [-y(1)/h;-y(3)/h];%gravitation acceleration of moon vektorial
a = aRakete + aG ; %combined acceleration vektorial
dxdt = [y(2);a(1)];%vX,aX
dydt = [y(4);a(2)];%vY,aY
fx = [dxdt;dydt];
end
