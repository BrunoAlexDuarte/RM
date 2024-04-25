function [VR, VL] = invkinDDxy(X,Y,L,t,Xn,Yn)

% X - target position in x (meters)
% Y - target position in y (meters)
% L - wheel separation (meters)
% t - time to accomplish the tragectory (seconds)
% Xn - next target position in x (meters)
% Yn - netxt target position in y (meters)

if X==0 && Y == 0
    % R = 'RODA'
    theta = atan2(Yn, Xn);
    if theta > 180
        theta = theta - 180;
    end
    if theta < -180
        theta = theta + 180;
    end     
    ANGROT = rad2deg(theta)
    w = theta / t;
    VR = w * L / 2;
    VL = -VR;
else
    % R = 'ANDA'
    VR = sqrt(X*X+Y*Y)/t
    VL = VR;
end 

end

