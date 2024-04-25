function [Vx, Vy, w] = localvels(t,r,L,w1,aw2,w3)


if nargin < 6
    w3 = 0;
end

switch t
    case 1 % DD
        M = [r/2 r/2
             0   0
            -r/L r/L];
        V =  M * [aw2; w1];
        Vx = V(1);
        Vy = V(2);
        w = V(3);
    case 2 % TRI
        Vs = w1 * r;
        Vx = Vs * cos(aw2);
        Vy = 0;
        w = Vs / L * sin(aw2);
    case 3 % omni
        sr3 = r / sqrt(3);
        r3 = r/3;
        rL = r/(3*L);
        M = [ 0    sr3 -sr3
             -2*r3 r3   r3
              rL   rL   rL
              ];
        V = M * [w1; aw2; w3];
        Vx = V(1);
        Vy = V(2);
        w = V(3);
end

