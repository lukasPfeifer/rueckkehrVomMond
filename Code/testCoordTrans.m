R = [2,3];%raketenposition bezogen auf mond
N = [4,4];%end punkt von R+F, also kraftvektor bezogen auf mond
F = [2,1];%Kraft bezogen auf rakete
[phi,r] = coordinateTransform(2,1,2,3)%berechne N in polar über F und R
%[phi1,r1] = cart2pol(2,1)
%[phi2,r2] = cart2pol(2,3)
[phi3,r3] = cart2pol(4,4)%N in polar

