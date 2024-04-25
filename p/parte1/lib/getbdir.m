function alpha = getbdir(B,P,th)

%B e a posicao do beacon
%P e a nossa posicao no caminho, que e em linha reta
%th e o angulo do caminho

% pos = [P*cos(th), P*sin(th)]';
% alpha = pi - atan2(B(2)-pos(2), B(1)-pos(1))-th;
% 
% alpha = mod(alpha, pi);

DB = B - P;
alpha = pi + atan2(DB(2), DB(1)) - th + randn*0.0175;
alpha = mod(alpha,pi);

end

