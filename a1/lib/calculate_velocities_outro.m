function [V,W] = calculate_velocities_outro(traj, L, Dt)

prev_pos = [0,0];
prev_ang = 0;
P = [0,0];
th = 0;

V = [];
W = [];

for i = 2:size(traj,1)
    pose = traj(i,:);
    pos = pose(1:2);
    ang = pose(3);

    target_ang = ang - prev_ang;
    prev_ang = ang;

    [VL, VR] = exec_action(0, 0, target_ang, L, Dt);

    delta_l = VL;
    delta_r = VR;

    delta_theta = (delta_r-delta_l) / L;
    delta_linear = (delta_r + delta_l) / 2;

    % V = [V, delta_linear];
    W = [W, delta_theta];

    th = th + delta_theta;

    %Calcular novo P(x,y)
    P = P + [delta_linear*cos(th), delta_linear*sin(th)];

    target_pos = pos - prev_pos;
    prev_pos = pos;

    [VL, VR] =  exec_action(target_pos(1), target_pos(2), 0, L, Dt);

    delta_l = VL;
    delta_r = VR;

    delta_theta = (delta_r-delta_l) / L;
    delta_linear = (delta_r + delta_l) / 2;

    V = [V, delta_linear];
    % W = [W, delta_theta];

    th = th + delta_theta;

    %Calcular novo P(x,y)
    P = P +  [delta_linear*cos(th), delta_linear*sin(th)];

    % pose
    % Final = [P, th]

end

V = V';
W = W';


end

