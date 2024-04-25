
%%%Aula 5 15/03/2024

addpath('lib')

close all; clear

%Initial State
B = [0, 5]';
P1 = [2, 0]';
th = 50 * pi / 180;
P = 0;

%Change state variables
V = 2; 
w = 0;
Dt = 0.2;
total_time = 5;

num_iters = total_time/Dt;

allP_Odom = zeros(2, num_iters);
allP_Tria = zeros(2, num_iters);

allP_Odom(:,1) = P1;
allP_Tria(:,1) = P1;

alpha = pi - th + atan2(B(2)-P1(2), B(1)-P1(1));

for i = 2:num_iters
    allP_Odom(:,i) = allP_Odom(:,i-1) + V * Dt * [cos(th), sin(th)]';
    
    P = allP_Odom(:,i);
    b = pi - getbdir(B,P,th);
    L2 = norm(P-P1)*sin(alpha) / sin(alpha+b);
    allP_Tria(1,i) = B(1) + L2 * cos(th - b);
    allP_Tria(2,i) = B(2) + L2 * sin(th - b);    
end

plot(B(1), B(2), 'r.', 'MarkerSize',20)
axis([0 10 0 10])
axis equal
grid on
hold on
plot(allP_Odom(1,:), allP_Odom(2,:), 'ob')
plot(allP_Tria(1,:), allP_Tria(2,:), 'xr', 'LineWidth',1.5)


%% Ex2
close all; clear

syms th1 th2 x y x1 y1 x2 y2 real

S1 = sin(th1);
S2 = sin(th2);
C1 = cos(th1);
C2 = cos(th2);

A = [-S1 C1
     -S2 C2];

B = [-x1 * S1 + y1 * C1
     -x2 * S2 + y2 * C2];

X = A\B;
X = simplify(X);

B1 = [10,6]';
B2 = [5, 5]';
Pt = [8,2]';

dP1 = B1-Pt;
dP2 = B2-Pt;

%simulate sensor measures
TH1 = atan2(dP1(2), dP1(1));
TH2 = atan2(dP2(2), dP2(1));

x1 = B1(1);
x2 = B2(1);
y1 = B1(2);
y2 = B2(2);
th1 = TH1;
th2 = TH2;

Xlocalised = subs(X);
vpa(Xlocalised,3)

%% Ex3

close all; clear;

syms th1 th2 x y x1 y1 x2 y2 real

S1 = sin(th1);
S2 = sin(th2);
C1 = cos(th1);
C2 = cos(th2);

M = [-S1 C1
     -S2 C2];

V = [-x1 * S1 + y1 * C1
     -x2 * S2 + y2 * C2];

P = M\V;
P = simplify(P);

x = P(1);
y = P(2);

J=simplify(jacobian([x y], [th1 th2]));

dth = [0.1, 0.1]';

dr = J * dth;

B1 = [10, 6]';
B2 = [5,5]';

Pt = [8,2]';
dP1 = B1-Pt;
dP2 = B2-Pt;
TH1 = atan2(dP1(2), dP1(1));
TH2 = atan2(dP2(2), dP2(1));



%%%end