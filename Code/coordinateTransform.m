%F = (xR,yR) Kraft bezogen auf rakete; R = (xM,yM) raketenposition bezogen
%auf mond, könnte auch direkt in polar eingeben werden, dann müsste man es hier
%nicht mehr umwandeln
function [phi, r] = coordinateTransform(xR,yR,xM,yM)
[phiTemp, rR] = cart2pol(xR,yR);
[phiM, rM] = cart2pol(xM,yM);
phiR = phiM - phiTemp;
%disp("alpha: "+phiR+" beta: "+phiM+" gamma: "+phiTemp);
r = sqrt(rM^2+rR^2-2*rM*rR*cos(pi-phiR));
tempAngle = asin(rR/r*sin(phiR));
phi = phiM - tempAngle;
end