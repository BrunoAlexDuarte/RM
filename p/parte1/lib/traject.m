function MM = traject(P1, P2, N)


% MM.xy - pontos da trajetoria
% MM.angle - orientacao nos pontos
% MM.T -transformacao geometrica para o ponto

M = [linspace(P1(1), P2(1), N)
     linspace(P1(2), P2(2), N)
    ];

dM = diff(M, 1, 2)
ang = atan2(dM(2,:), dM(1,:));
ang(end+1)=ang(end);

T = zeros(3,3,width(M));
for n=1:size(T,3)
    T(:,:,n) = transl(M(:,n))*rotat(ang(n));
end

MM.xy = M;
MM.angle = ang;
MM.T = T;
end

