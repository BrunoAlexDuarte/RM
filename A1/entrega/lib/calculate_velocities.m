function [VX,W] = calculate_velocities(orig, dest,Dt)

prev_pos = orig(1:2);
prev_ang = orig(3);

VX = [];
W = [];

% pose = traj(i,:);
pos = dest(1:2);
ang = dest(3);

target_ang = ang - prev_ang;

NW = target_ang/Dt;
W = [W, NW];


target_pos = pos - prev_pos;

NVX = sqrt(target_pos(1)^2+target_pos(2)^2)/(Dt);
VX = [VX, NVX];


end

