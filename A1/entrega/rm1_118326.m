
main_project(4)

% addpath('../p/parte1/lib')

function main_project(N,Dt,r,L,Vn,Wn,V)

if exist( 'N', 'var' ) == 0
    N = 4;
end

if exist( 'Dt', 'var' ) == 0
    Dt = 1;
end

if exist( 'r', 'var' ) == 0
    r = 0.15;
end

if exist( 'L' , 'var') == 0
    L = 1;
end

if exist( 'Vn', 'var' ) == 0
    Vn = 0.1;
end

if exist( 'Wn', 'var' ) == 0
    Wn = 0.1;
end

if exist( 'V', 'var' ) == 0
    V = 50;
end

close all

addpath('lib/')

%sacar os farois
Farois = BeaconDetection(N,[0,0,0]);
obs_noise = [Farois(1).dn,Farois(1).an];
%obter a posicao dos mesmos
farois_pos = zeros(N,2);

for i=1:N
    farois_pos(i,:) = [Farois(i).X, Farois(i).Y];
end

%%% obtem trajetoria
traj = define_trajetoria(farois_pos, Dt, V);
size(traj)
hold on
grid on
plot(farois_pos(:,1), farois_pos(:,2), 'ko')
plot(traj(:,1), traj(:,2))

%%% obtem velocidades em cada ponto
DD_velocities = zeros(size(traj,1),2);
TRI_velocities = zeros(size(traj,1),2);
pos = traj(1,:);

input_noise = [Vn, 0; 0, Wn];
x_state = traj(1,:);
p_state = eye(3) * 0.01;
all_x_state = [];

for i=1:size(traj,1)-1

    [VX,W] = calculate_velocities(x_state, traj(i+1,:), Dt);
    control_inputs = [VX,W];
    obs_inputs = BeaconDetection(N, x_state,obs_noise);

    [x_state, p_state] = my_ekf(x_state, p_state, control_inputs, obs_inputs, input_noise, obs_noise, Dt,N);
    all_x_state = [all_x_state; x_state];
end

plot(all_x_state(:,1), all_x_state(:,2))
[VX2, W2] = calculate_velocities2(all_x_state, Dt);

fileID = fopen('loc_118326','w+');
formatSpec = '%d,%d,%d\n';
for row =1:size(all_x_state,1)
    fprintf(fileID,formatSpec,all_x_state(row,:));
end

fileID = fopen('TRI_118326','w+');
formatSpec = '%d,%d\n';
for row =1:size(VX2,2)
    [WT,A] = get_wheels(VX2(row), W2(row), L, r, 0);
    fprintf(fileID,formatSpec,[WT,A]);
end

fileID = fopen('DD_118326','w+');
formatSpec = '%d,%d\n';
for row =1:size(VX2,2)
    [WR,WL] = get_wheels(VX2(row), W2(row), L, r, 1);
    fprintf(fileID,formatSpec,[WR,WL]);
end

%%%PASSOS       
%Calcular trajetoria (x, y, theta)
%Calcular as velocidades a aplicar no robo a cada ponto da trajetoria
%Para cada posicao calcular o kalman filter
%Guardar as posicoes e no fim colocar os valores separados por virgula, 1 
%   pose por linha, e chamado loc_118326.txt
%Para cada um dos modelos cinematicos calcular as velocidades das rodas e a
%   direcao do triciclo e colocar nos ficheiros DD_118326.txt e
%   TRI_118326.txt
end


