%%
% Robotica movel aula 2 23-02-2024

close all; clear
addpath('lib')
ST = 600;
% ST = 400;
% ST = 200;
r = 1;
L = 4;
P0 = [0; 0];
th0 = 0;
Dt = 0.1;
t = 1;

% w1 = 1; aw2 = 1; w3 = 1;
w1 = 1; aw2 = 1; w3 = 1;
PI = [0;0];


allP = zeros(2, ST);
allP(:,1) = PI;
allTh = zeros(1,ST);
allTh(1) = th0;

P = PI;
th = th0;

for n=1:ST
    % w1 = 2*exp(-n/ST);
    % aw2 = 2*exp(-5*n/ST);

    % w1 = 2;
    % aw2 = sin(10*n*pi/ST);

    % w1 = 2 * sin(n*pi/ST);
    % aw2 = 0.25*sin(2*n*pi/ST);
    % w3 = sin(n*pi/ST);

    [Vx, Vy, w] = localvels(t, r, L, w1, aw2, w3);
    R = orm(th);
    Nv = R\[Vx; Vy; w];

    P(1) = P(1) + Nv(1) * Dt;
    P(2) = P(2) + Nv(2) * Dt;
    th = th + Nv(3) * Dt;

    allP(:,n) = P;
    allTh(n) = th;

end

grid on; hold on; axis equal
plot(allP(1,:), allP(2,:))

[Rob,h] = DrawRobot(t);
Robh = [Rob; ones(1, size(Rob,2))];
% 
% nRob = rotat(-pi/2) * Robh;
% h.XData=nRob(1,:);
% h.YData=nRob(2,:);


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

%
