function [VR,VL] = invkinDD(X,Y,th,L,t)

% X - target position in x (meters)
% Y - target position in y (meters)
% th - target orientation in th (radians)
% L - wheel separation (meters)
% t - time to accomplish the tragectory (seconds)

%contamos que x0, y0 e th0 sao todos 0

w = th / t;

if th == 0
    V = X/t;
    VL = V; VR = V;
    return
end

if isnan(Y)
    V = X * w / sin(w*t);
else
    V = Y * w / (1 - cos(w*t));
end

VR = V+w*L/2;
VL = VR - w * L;

end

