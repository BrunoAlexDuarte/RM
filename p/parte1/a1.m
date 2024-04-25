%%
% Robotica movel aula 1 16-02-2024


close all; clear
addpath('lib')

R = [0 0 2
     1 -1 0
     ];

Rh=R; Rh(3,:)=1;

hR = fill(Rh(1,:), Rh(2,:), 'y');
axis equal; grid on; hold on;

P1 = [-15 -8]';
P2 = [15 14]';
N = 50;

% % MM = traject(P1, P2, N);
% R = 30;
% MM = circtraj(P1,P2,R,N);
% 
% M = MM.xy;
% TT = MM.T;
% 
% plot(P1(1), P1(2), '*b', P2(1), P2(2), '*m');
% plot(M(1,:), M(2,:), '.r');
% axis([-20 20 -20 20])
% 
% for n=1:N
%     T = TT(:,:,n);
%     nR = T*Rh;
%     hR.XData=nR(1,:); hR.YData=nR(2,:);
%     pause(0.05)
% end

P1 = [-15 -8]';
P2 = [0 0 ]';
P3 = [30 -5]';
P4 = [20 10]';

P = [P1 P2 P3 P4];
RR = [Inf, 25, 10];
NN = [30 15 30];

allxy = []; allangle = []; allT = [];

for n=1:width(P)-1
    R = RR(n); N=NN(n);
    M = circtraj(P(:,n), P(:, n+1), R, N);
    plot(P(1,n), P(2,n), '*b', P(1, n+1), P(2, n+1), '*m');
    allxy = cat(2, allxy, M.xy);
    allangle = cat(2, allangle, M.angle);
    allT = cat(3, allT, M.T);
end

axis([min(allxy(1,:)) max(allxy(1,:)) ...
    min(allxy(2,:)) max(allxy(2,:))]);
daxl=2*ones(4,1);
axl=axis; daxl=[-daxl(1) daxl(2) -daxl(3) daxl(4)];
axis(axl+daxl)

plot(allxy(1,:), allxy(2,:), '.r')



for n=1:width(allxy)
    T=allT(:,:,n);
    nR = T*Rh;
    hR.XData = nR(1,:); hR.YData = nR(2,:);
    pause(0.05)
end

%% Ex7

addpath lib/
close all
clear


PI = [0 0]';
ai = pi/4;
ang = ai;


S = [10 5]';

k = 10; %sensitividade a fonte


Its = 100; % Iterations
dt = 1;
P = zeros(2,Its);
P(:,1) = PI;

v = zeros(1,Its);
allangle = zeros(1,Its);

for n=1:Its
    d = norm(P(:,n)-S);
    v(n) = k / d^2;
    P(:,n+1) = P(:,n) + v(n) * [cos(ang); sin(ang)] * dt;
    allangle(n) = ang;
end

R = [0 0 2
     1 -1 0
     ];

Rh=R; Rh(3,:)=1;

subplot(1,2,2)

plot(v)

subplot(1,2,1)

hold on;

plot(S(1), S(2), '*b')
plot(P(1, 1), P(2, 1), '*g')
plot(P(1, end), P(2, end), '*m')
plot(P(1,:), P(2,:), '.r')

hR = fill(Rh(1,:), Rh(2,:), 'y');
axis equal; grid on; hold on;


for n=1:width(P)-1
    T = transl(P(:,n))*rotat(allangle(n));
    nR = T*Rh; hR.XData = nR(1,:); hR.YData = nR(2,:);
    pause(0.05)
end

%% Ex8

addpath lib/
close all
clear


PI = [0 0]';
ai = pi/4;
ang = ai;


S = [10 5]';

k = 10; %sensitividade a fonte


Its = 60; % Iterations
dt = 1;
P = zeros(2,Its);
P(:,1) = PI;

av = zeros(1,Its);
allangle = zeros(1,Its);


for n=1:Its
    d = norm(P(:,n)-S);
    v = k / d^2;
    
    PS = S-P(:,n);
    sAng = atan2(PS(2), PS(1))-ang;
    v = v * cos(sAng);

    P(:,n+1) = P(:,n) + v * [cos(ang); sin(ang)] * dt;
    allangle(n) = ang;
    av(n) = v;
end

R = [0 0 2
     1 -1 0
     ];


Rh=R; Rh(3,:)=1;

subplot(1,2,2)

plot(av)

subplot(1,2,1)

hold on;

plot(S(1), S(2), '*b')
plot(P(1, 1), P(2, 1), '*g')
plot(P(1, end), P(2, end), '*m')
plot(P(1,:), P(2,:), '.r')

hR = fill(Rh(1,:), Rh(2,:), 'y');
axis equal; grid on; hold on;


for n=1:width(P)-1
    T = transl(P(:,n))*rotat(allangle(n));
    nR = T*Rh; hR.XData = nR(1,:); hR.YData = nR(2,:);
    pause(0.05)
end


%% Ex9

%8 e o 7 mas so com a distancia tangencial a fonte

addpath lib/
close all; clear

R = [0 0 2
     1 -1 0
     ];

Rh=R; Rh(3,:)=1;

vi = 0;
ki = 0.9;


PI = [0 0]';
ai = pi/4;
ang = ai;


S = [10 5]';

k = 10; %sensitividade a fonte


Its = 100; % Iterations
dt = 1;
P = zeros(2,Its);
P(:,1) = PI;

vp = vi;
av = zeros(1,Its);
allangle = zeros(1,Its);

for n=1:Its
    d = norm(P(:,n)-S);

    v = k / d^2;
    
    PS = S-P(:,n);
    sAng = atan2(PS(2), PS(1))-ang;
    v = v * cos(sAng)+ki*vp;
    
    P(:,n+1) = P(:,n) + v * [cos(ang); sin(ang)] * dt;
    allangle(n) = ang;
    vp = v
    av(n) = v;
end

subplot(1,2,2)

plot(av)

subplot(1,2,1)

hold on;

plot(S(1), S(2), '*b')
plot(P(1, 1), P(2, 1), '*g')
plot(P(1, end), P(2, end), '*m')
plot(P(1,:), P(2,:), '.r')

hR = fill(Rh(1,:), Rh(2,:), 'y');
axis equal; grid on; hold on;


for n=1:width(P)-1
    T = transl(P(:,n))*rotat(allangle(n));
    nR = T*Rh; hR.XData = nR(1,:); hR.YData = nR(2,:);
    pause(0.05)
end

%% Ex10


close all; clear

R = [0 0   0.5 0 2  0  0    0.5  0
     1 1.1 1.1 1 0 -1 -1.1 -1.1 -1
     ];
L = 2;
th = 0;
S = [10 5]';

Rh=R; Rh(3,:)=1;

TS1 = [1 0 0    
       0 1 1
       0 0 1];

TS2 = [1 0  0
       0 1 -1
       0 0  1];

Sn1 = [0  1 1]';
Sn2 = [0 -1 1]';


S = [10 5]';
% k = 0.03; %sensitividade a fonte
k = 0.1;
Its = 100; % Iterations
Dt = 1;

vR = 0;
vL = 0;

PI = [0 0]';

allv = zeros(1,Its);
allw = zeros(1,Its);
allangle = zeros(1,Its+1);
aP = zeros(2,Its+1);
aP(:,1) = PI;
P = PI;
O = "inicio";


for n=2:Its+1
    Sn1c = transl(P)*rotat(th)*TS1*Sn1;
    Sn2c = transl(P)*rotat(th)*TS2*Sn2;
    

    d1 = norm(Sn1c(1:2)-S);
    d2 = norm(Sn2c(1:2)-S);
    d = norm(P-S);


    vL = 1e-2*k*d1;
    vL = max(vL,0.2);
    vL = min(vL, 12);

    vR = 1e-2*k*d2;
    vR = max(vR,0.2);
    vR = min(vR, 12);

    vT = vL;
    vL = vR;
    vR = vT;

    w = (vR - vL) / L;
    v = (vR + vL) / 2;

    Dl = v*Dt;
    Dth = w*Dt;
    th=th+Dth;
    P= P+Dl*[cos(th); sin(th)];

    aP(:,n) = P;
    allangle(n) = th;
    allv(n) = v;
    allw(n) = w;
end

% subplot(1,3,3)
% 
% plot(allw)
% 
% subplot(1,3,2)
% 
% plot(allv)
% 
% subplot(1,3,1)
aP
hold on;

plot(S(1), S(2), '*b')
plot(aP(1, 1), aP(2, 1), '*g')
plot(aP(1, end), aP(2, end), '*m')
plot(aP(1,:), aP(2,:), '.r')

hR = fill(Rh(1,:), Rh(2,:), 'y');
% axis([-6 12 -2 8]); 
grid on; hold on; 
for n=1:width(aP)-1
    % aP(:,n)
    T = transl(aP(:,n))*rotat(allangle(n));
    nR = T*Rh; hR.XData = nR(1,:); hR.YData = nR(2,:);
    pause(0.05)
end



%-------