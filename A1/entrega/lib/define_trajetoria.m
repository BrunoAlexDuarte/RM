function T = define_trajetoria(Pontos, Dt, V)

%Recebe os pontos, Dt  e V e retorna T com os pontos e as orientaçoes 
% em cada um desses pontos

Pontos = [0 , 0;
         Pontos];

N = size(Pontos,1); %Numero de farois

traj_x = 0;
Dt*V
for i=1:N-1
    divs = norm(Pontos(i,:)-Pontos(i+1,:)) / (Dt * V) + 1;
    traj_each = linspace(Pontos(i,1), Pontos(i+1, 1), divs);
    traj_x = [traj_x, traj_each(2:end)];
end

traj_y = pchip(Pontos(:,1), Pontos(:, 2), traj_x);

N = size(traj_y, 2);
Angs = zeros(1,N);

for i = 2:N
    Angs(i-1) = atan2(traj_y(i)-traj_y(i-1), traj_x(i)-traj_x(i-1)); 
end

T = [traj_x', traj_y' ,Angs'];

end

