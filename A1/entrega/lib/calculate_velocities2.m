function [VX,W] = calculate_velocities2(traj,Dt)

prev_pos = traj(1,1:2);
prev_ang = traj(1,3);

VX = [];
W = [];


for i = 2:size(traj,1)
    pose = traj(i,:);
    pos = pose(1:2);
    ang = pose(3);

    target_ang = ang - prev_ang;
    prev_ang = ang;

    NW = target_ang/Dt;
    W = [W, NW];

    target_pos = pos - prev_pos;
    prev_pos = pos;

    NVX = sqrt(target_pos(1)^2+target_pos(2)^2)/(Dt);
    VX = [VX, NVX];

end




end

