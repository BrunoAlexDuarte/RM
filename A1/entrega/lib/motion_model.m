function [xstate1] = motion_model(xstate,Vin,Dn,t)

%Recebemos o estado atual, a velocidade linear e angular(Vn), os Ruidos
%associados(Dn)
% e o Dt
%Por fim devolvemos o proximo estado

% xstate1(1) = xstate(1) + Vin(1) * t * cos(xstate(3));
% xstate1(2) = xstate(2) + Vin(1) * t * sin(xstate(3));
% xstate1(3) = xstate(3) + Vin(2) * t;

xstate1(1) = xstate(1) + (Vin(1) + Dn(1)) * t * cos(xstate(3));
xstate1(2) = xstate(2) + (Vin(1) + Dn(1)) * t * sin(xstate(3));
xstate1(3) = xstate(3) + (Vin(2) + Dn(2)) * t;


end

