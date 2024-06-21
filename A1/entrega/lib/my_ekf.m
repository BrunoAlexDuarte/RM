function [xstatet1, Pt1] = my_ekf(x_state, p_state, control_inputs, obs_inputs, input_noise, obs_noise, Dt,N)

% x_state: estado atual
% p_state: matriz das covariancias do estado atual
% control_inputs: inputs de controlo para o estado atual
% obs_inpus: observacoes dos sensores aos farois para o estado atual
% input_noise: noise associado aos inputs de controlo
% obs_noise: noise associado as medidas dos sensores aos farois
% Dt: delta_t, o tempo entre cada estado

%%% Prediction

pzero = [0,0];
x_state1_t = motion_model(x_state, control_inputs, pzero, Dt);

temp1 = -Dt * control_inputs(1) * sin(x_state(3));
temp2 =  Dt * control_inputs(1) * cos(x_state(3));

Jfx = [1 0 temp1
       0 1 temp2
       0 0 1];

temp3 = Dt * cos(x_state(3));
temp4 = Dt * sin(x_state(3));

Jfw = [temp3 0
       temp4 0
       0     Dt];

Q = input_noise;
Pt1_t= Jfx*p_state*Jfx'+Jfw*Q*Jfw';   

%%% Update
nzero = [0 0]; 
z_all = [];
z_pred = [];
obs_inputs = BeaconDetection(N,x_state1_t,obs_noise);
Jh = [];
count = 0;
for i=1:size(obs_inputs,2)
    if isnan(obs_inputs(i).a) || isnan(obs_inputs(i).d)
        continue
    end
    z_each(1) = obs_inputs(i).d;
    z_each(2) = obs_inputs(i).a;
    landmark = [obs_inputs(i).X, obs_inputs(i).Y];
    z_all = [z_all; z_each'];

    z_pred_each = sensormodel(landmark, x_state1_t, nzero);
    z_pred = [z_pred; z_pred_each'];

    jacob_each = jacobi(landmark, x_state1_t(1), x_state1_t(2));
    Jh = [Jh; jacob_each];
    
    count = count + 2;
end

if count == 0
    xstatet1 = x_state;
    Pt1      = p_state;
    return
end

innov = z_all-z_pred;
R = 0.01 * eye(count);
each = 0;

for i=1:size(R,1)
    R(i,i) = obs_noise(each+1);
    each = 1-each;
end

S = Jh*Pt1_t*Jh' + R;
K = Pt1_t*Jh'*inv(S);

xstatet1_t1 = x_state1_t'+K*innov;
Pt1_t1      = Pt1_t - K*Jh*Pt1_t;

xstatet1 = xstatet1_t1';
Pt1      = Pt1_t1;


end