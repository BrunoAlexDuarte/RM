%
%Aula 4 08-03-2024
%


addpath('lib')

close all; clear;


%Dados constantes robo
wheel_diameter = 0.20;
wheel_separation = 0.60;
pulses_turn = 2048;
gear_ratio = 1;

%Posicoes iniciais
th_i = 0;
P_i = [0, 0]';

th = th_i;
P = P_i;

%Valores de input
R = [0,223,446,669,892,1115,1338,1561,1784,2007,2230,2453,2676,2899,3122,3345,3568,3791,4014,4237,4460,4683];
L = [0,120,240,360,480, 600, 720, 840, 960, 810, 750, 690, 630, 570, 510, 450, 621, 873,1125,1377,1629,1881];

%Calcular o K
k = (pi*wheel_diameter) / (gear_ratio*pulses_turn);

allP = zeros(2,size(R,2));
allTh = zeros(size(R,2),1);

%Calcular posicoes
for i=2:size(R,2)
    
    %Obter NR e NL
    NR = R(i)-R(i-1);
    NL = L(i)-L(i-1);

    %Calcular deltas rodas
    delta_l = k * NL;
    delta_r = k * NR;

    %Calcular deltas angular e lineares
    delta_theta = (delta_r-delta_l) / wheel_separation;
    delta_linear = (delta_r + delta_l) / 2;

    %Calcular novo theta
    th = th + delta_theta;

    %Calcular novo P(x,y)
    P = P + [delta_linear*cos(th), delta_linear*sin(th)]';

    allP(:,i) = P;
    allTh(i) = th;
end

grid on; hold on
x=allP(1,:);
y=allP(2,:);

plot(x,y,'.-b')

ss=1;
dCR=diff(R);
dCL=diff(L);
text(x(2:ss:end),y(2:ss:end)-0.01,string(dCR(1:ss:end)), 'FontSize',8,'Color','r')
text(x(2:ss:end),y(2:ss:end)+0.01,string(dCL(1:ss:end)), 'FontSize',8,'Color','b', 'HorizontalAlignment','right')



%% Agora triciclo

close all; clear;


%Internal parameters
wheel_diameter = 0.20;
rear_wheels_separation = 0.80;
pulses_turn = 1024;
gear_ratio = 1;
steering_resolution = 1;%deg

%Posicoes iniciais
th_i = 0;
P_i = [0,0]';

th = th_i;
P = P_i;

%Input vectors
S = [0,219,442,674,875,1113,1350,1520,1744,2001,2214,2440,2723,2934,3127,3399,3594,3860,4080,4321,4533,4701];
alpha = [0,0,5,5,8,8,10,10,10,12,10,7,6,3,-4,-8, -10, -12, -14, -12, -10,-8]; % deg


%Calcular o K
k = (pi*wheel_diameter) / (gear_ratio*pulses_turn);

allP = zeros(2,size(S,2));
allTh = zeros(size(S,2),1);

%Calcular posicoes
for i=2:size(S,2)
    
    %Obter NS e NA
    NS = S(i)-S(i-1);
    NA = deg2rad(alpha(i));

    %Calcular delta velocidade
    delta_V = k*NS;
    delta_A = k*NA;
    
    %Calcular novo theta
    th = th + sin(delta_A)*delta_V/rear_wheels_separation;

    %Calcular novo P(x,y)
    P = P + [delta_V*cos(th)*cos(delta_A), delta_V*sin(th)*cos(delta_A)]';

    allP(:,i) = P;
    allTh(i) = th;
end

grid on; hold on

plot(allP(1,:),allP(2,:),'.-b')


%% Telemovel

close all; clear;
figure;
axis([-1 1 -1 1 -1 1]);
axis square;
xlabel('X');
ylabel('Y');
zlabel('Z');
grid on;
hold on;

STATUS = 'CONNECTING'

m = mobiledev('Xiaomi - Redmi Note 9 Pro(6199)')
% m = mobiledev

% Define the vertices of the smartphone
vertices = [0.5  0.5 -0.5 -0.5  0.5  0.5 -0.5 -0.5 % X
            0.8 -0.8 -0.8  0.8  0.8 -0.8 -0.8  0.8 % Y
            0.1  0.1  0.1  0.1 -0.1 -0.1 -0.1 -0.1]; % Z


% Define the faces of the smartphone
faces = [1 2 6 5 % front
4 3 7 8 % back
1 4 8 5 % left
2 3 7 6 % right
1 2 3 4 % top
5 6 7 8];% bottom

% Plot the initial orientation of the model
h=patch('Vertices', vertices', 'Faces', faces,'FaceColor', 'b');
view(3)
STATUS = 'BEGINNING'
while 1
    accel = m.Acceleration;
    
    g = accel/norm(accel);
    if numel(g) < 3
        continue;
    end
       
    % m.Acceleration
    g
    gx = g(1);
    gy = g(2);
    gz = g(3);

    pitch = atan2(-gx, sqrt(gy^2+gz^2));
    roll = atan2(gy,gz);
    
    R_pitch = [cos(pitch) 0 sin(pitch)
        0 1 0
        -sin(pitch) 0 cos(pitch)];

    R_roll = [1 0 0
            0 cos(roll)  -sin(roll)
            0 sin(roll) cos(roll)
            ];

    
    % Compute rotated vertices
    rotated_vertices= R_roll*R_pitch*vertices;
    % Update plot with rotated vertices
    h.Vertices=rotated_vertices';
    pause(0.1)

end


%% Telemovel 2

close all; clear;
figure;
axis([-1 1 -1 1 -1 1]);
axis square;
xlabel('X');
ylabel('Y');
zlabel('Z');
grid on;
hold on;

STATUS = 'CONNECTING'

m = mobiledev('Xiaomi - Redmi Note 9 Pro(6199)')
% m = mobiledev

% Define the vertices of the smartphone
vertices = [0.5  0.5 -0.5 -0.5  0.5  0.5 -0.5 -0.5 % X
            0.8 -0.8 -0.8  0.8  0.8 -0.8 -0.8  0.8 % Y
            0.1  0.1  0.1  0.1 -0.1 -0.1 -0.1 -0.1]; % Z


% Define the faces of the smartphone
faces = [1 2 6 5 % front
4 3 7 8 % back
1 4 8 5 % left
2 3 7 6 % right
1 2 3 4 % top
5 6 7 8];% bottom

% Plot the initial orientation of the model
h=patch('Vertices', vertices', 'Faces', faces,'FaceColor', 'b');
view(3)
STATUS = 'BEGINNING'

count = 0;
velocity = [0,0,0];
position = [0,0,0];
angs_big = [0,0,0];

delta_t = 0.1;

allP = zeros(100,3);
allAng = zeros(100,3);

for i=1:size(allP, 1)
    i
    accel = m.Acceleration;
    angs = m.AngularVelocity;
    
    g = accel/norm(accel)

    if numel(g) < 3
        continue;
    end
    if numel(angs) < 3
        continue
    end


    velocity = velocity + g * delta_t
    position= position+ velocity * delta_t

    angs_big = angs_big + angs * delta_t

    allAng(i,:) = angs_big;
    allP(i,:) = position;


       
    % m.Acceleration
    g
    gx = g(1);
    gy = g(2);
    gz = g(3);

    pitch = atan2(-gx, sqrt(gy^2+gz^2));
    roll = atan2(gy,gz);
    
    R_pitch = [cos(pitch) 0 sin(pitch)
        0 1 0
        -sin(pitch) 0 cos(pitch)];

    R_roll = [1 0 0
            0 cos(roll)  -sin(roll)
            0 sin(roll) cos(roll)
            ];

    
    % Compute rotated vertices
    rotated_vertices= R_roll*R_pitch*vertices;
    % Update plot with rotated vertices
    h.Vertices=rotated_vertices';
    pause(0.1)
    count = count + 1;

end

close all
hold on
allP
plot3(allP(:,1), allP(:,2), allP(:, 3), '.-g')


%//end of file