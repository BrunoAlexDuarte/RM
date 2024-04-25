function [VX,W] = calculate_velocities(traj,Dt,Vn,Wn)

prev_pos = [0,0];
prev_ang = 0;

VX = [];
W = [];


for i = 2:size(traj,1)
    pose = traj(i,:);
    pos = pose(1:2);
    ang = pose(3);

    target_ang = ang - prev_ang;
    prev_ang = ang;

    NW = target_ang/Dt;
    noise = -Wn+(Wn+Wn)*rand();
    W = [W, NW+noise];

    target_pos = pos - prev_pos;
    prev_pos = pos;

    NVX = sqrt(target_pos(1)^2+target_pos(2)^2)/(Dt);
    noise = -Vn+(Vn+Vn)*rand();
    VX = [VX, NVX+noise];

end




end

