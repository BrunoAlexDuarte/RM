
addpath('../p/parte1/lib')
addpath('lib/')

% clc;
clear;
close all

%DATA

N = 4; %number of beacons
Dt = 1; %sensors sampling time interval
r = 0.15; %raio das rodas do robo
L = 1; %separacao das rodas dependendo do modelo
Vn = 0.1; %incertidao(sigma) da velocidade linear no robo
Wn = 0.1; %incertidao(sigma) da velocidade angular no robo
V = 5; %velocidade linear media desejada ao longo da trajetoria

%sacar os farois
Farois = BeaconDetection(N);

%obter a posicao dos mesmos
farois_pos = zeros(N,2);

for i=1:N
    farois_pos(i,:) = [Farois(i).X, Farois(i).Y];
end

%%% obtem trajetoria

traj = define_trajetoria(farois_pos, Dt, V);

hold on
grid on
plot(farois_pos(:,1), farois_pos(:,2), 'ko')
plot(traj(:,1), traj(:,2))

%%% obtem velocidades em cada ponto

[VX,W] = calculate_velocities(traj, Dt);


%Main loop, onde obtemos a trajetorioa que deviamos sguir e andamos
th = 0;
pos = [0,0];
size(W)
for i=1:size(VX,2)

    aw = W(i);
    av = VX(i);
    WL = (2 * av - aw * L) / 2; 
    WR = av + aw * L / 2;


    th = th+(WR-WL)/L;
    lin = (WR+WL)/2;
    pos = pos + [cos(th)*lin, sin(th)*lin];
end
pos
th
traj(end,:)





%%%PASSOS       

%Calcular trajetoria (x, y, theta)
%Calcular as velocidades a aplicar no robo a cada ponto da trajetoria
%Para cada posicao calcular o kalman filter
%Guardar as posicoes e no fim colocar os valores separados por virgula, 1 
%   pose por linha, e chamado loc_118326.txt
%Para cada um dos modelos cinematicos calcular as velocidades das rodas e a
%   direcao do triciclo e colocar nos ficheiros DD_118326.txt e
%   TRI_118326.txt