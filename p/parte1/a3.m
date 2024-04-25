%%

close all; clear

addpath('lib')

%To do inverse kinematics
L = 0.5;
t = 5;
X = 2;
Y = NaN;
th = pi/6;

%Initial state
th0 = 0;
PI = [0,0]';

%Type of robot and wheel radius
r = 1;
tr = 1;

%Nummber of steps and time between steps
Dt = 0.1;
ST = t / Dt;

%Solve inverse kinematics
[VR, VL] = invkinDD(X, Y, th, L, t);


%Create arrays to save position and orientation of direct kinematics
allP = zeros(2, ST);
allP(:,1) = PI;
allTh = zeros(1,ST);
allTh(1) = th0;

%Put the initial position and orientation in the variable to be used
P = PI;
th = th0;

%Do the same for the wheel speed
w1 = VR;
aw2 = VL; 
w3 = 10;

for n=1:ST

    [Vx, Vy, w] = localvels(tr, r, L, w1, aw2, w3);
    R = orm(th);
    Nv = R\[Vx; Vy; w];

    P(1) = P(1) + Nv(1) * Dt;
    P(2) = P(2) + Nv(2) * Dt;
    th = th + Nv(3) * Dt;

    allP(:,n) = P;
    allTh(n) = th;

end

grid on; hold on; axis([-1 6 -1 3])
plot(allP(1,:), allP(2,:))

% R = [0 0 0.5
%      0.25 -0.25 0
%      ];
% 
% Robh=R; Robh(3,:)=1;
% 
% h = fill(Robh(1,:), Robh(2,:), 'y');


[Rob,h] = DrawRobot(tr);
Robh = [Rob; ones(1, size(Rob,2))];

Robh = rotat(-pi/2) * Robh;
h.XData=Robh(1,:);
h.YData=Robh(2,:);

T = eye(3);

for i=1:size(allP,2)-1
    dr = allP(:,i+1)-allP(:,i);
    thr = allTh(i);
    T = transl(dr)*T;
    nRob = T * rotat(thr) * Robh ;

    % dr = allP(:,i);
    % thr = allTh(i);   
    % T = transl(dr)*rotat(thr);
    % nRob = T * Robh;

    h.XData=nRob(1,:);
    h.YData=nRob(2,:);
    pause(1/ST/Dt);

end

%% Ex3,4

close all; clear; 

%Positions and timestamps beetwen them
P0 = [ 0, 0]';
P1 = [ 3, 2]';
P2 = [ 5, 1]';
P3 = [ 2,-2]';

t0 = 3;
t1 = 4;
t2 = 5;
t3 = 4;

PP = [P0,P1,P2,P3,P0,P1];
t = [t0,t1,t2,t3];
% PP = [P0, P1,P2];
% t= [t0];

%Type of robot and wheel radius
th = 0;
P = [0,0]';

L = 0.5;
r = 1;
tr = 1;

%Nummber of steps and time between steps
Dt = 0.1;
STT = (sum(t)+size(t,2))/Dt;
sum_t = 0;

%Create arrays to save position and orientation of direct kinematics
allP = zeros(2, STT);
allP(:,1) = P;
allTh = zeros(1,STT);
allTh(1) = th;

previous = P;
R = eye(3);

for i = 1:size(PP,2)-2
    target1 = PP(:,i+1)
    target = target1-previous
    next_target = PP(:,i+2);
    previous = target1;
    time = t(i);
    target2 = inv(R)*[target(1), target(2), 1]'
    target = [target2(2) target2(1)]';
    %Primeiro roda, depois vai em frente para a proxima posiçao
    % [VR, VL] = invkinDDxy(0,0, L, 1, next_target(1), next_target(2));
    [VR, VL] = invkinDDxy(0,0, L, 1, target(1), target(2));
    ST = 1/Dt;
    for n=1:ST
        [Vx, Vy, w] = localvels(tr, r, L, VR, VL, 0);
        R = orm(th);
        Nv = R\[Vx; Vy; w];

        P(1) = P(1) + Nv(1) * Dt;
        P(2) = P(2) + Nv(2) * Dt;
        th = th + Nv(3) * Dt;

        allP(:,sum_t+n) = P;
        allTh(sum_t + n) = th;
    end
    sum_t = sum_t + ST;

    [VR, VL] = invkinDDxy(target(1), target(2), L, time, 0, 0);
    ST = time/Dt;
    for n=1:ST
        [Vx, Vy, w] = localvels(tr, r, L, VR, VL, 0);
        R = orm(th);
        Nv = R\[Vx; Vy; w];

        P(1) = P(1) + Nv(1) * Dt;
        P(2) = P(2) + Nv(2) * Dt;
        th = th + Nv(3) * Dt;

        allP(:,sum_t + n) = P;
        allTh(sum_t + n) = th;
    end
    sum_t = sum_t + ST;

end

grid on; hold on; axis equal
plot(allP(1,:), allP(2,:))

[Rob,h] = DrawRobot(tr);
Robh = [Rob; ones(1, size(Rob,2))];

Robh = rotat(-pi/2) * Robh;
h.XData=Robh(1,:);
h.YData=Robh(2,:);

T = eye(3);
R = size(allP);
for i=1:size(allP,2)-1
    dr = allP(:,i+1)-allP(:,i);
    thr = allTh(i);
    T = transl(dr)*T;
    nRob = T * rotat(thr) * Robh ;

    h.XData=nRob(1,:);
    h.YData=nRob(2,:);
    pause(Dt);

end


