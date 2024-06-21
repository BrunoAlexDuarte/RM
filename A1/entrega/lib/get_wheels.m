function [W1,W2] = get_wheels(Vn,Wn,L,r,type)

%W1 e WR em DD e WT em TRI
%W2 e WL em DD e alpha em TRI

if type == 1
    W1 = Vn + Wn * L / 2;
    W1 = W1 / r;
    W2 = (2 * Vn - Wn * L) / 2; 
    W2 = W2 / r;
    return
end

W2 = atan2(Wn*L, Vn);
W1 = Vn / cos(W2);
W1 = W1 / r;
end

