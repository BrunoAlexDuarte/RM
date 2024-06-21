function [VL,VR] = exec_action(X,Y,theta,L,t)

if theta == 0
    % R = 'ANDA'
    VR = sqrt(X^2+Y^2)/(t);
    VL = VR;
    return
end

if theta > pi
    theta = theta - pi;
end
if theta < -pi
    theta = theta + pi;
end
w = theta / t;
VR = w * L / 2;
VL = -VR;

end

