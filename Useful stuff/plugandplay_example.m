
A = [0 1;
    4 -7];
B = [0;1];
C = [1 0];
D = 0;
L1 = [-10^(-13); -160];
L2 = [10.7 ; -5.68];
F1 = [-4.29 6];
F2 = [-8.12 -1.14];

m=1;
p = 1;
gamma = 0;

Utilde1 = ss(A + L1*C, -L1, F1, 0);
Vtilde1 = ss(A + L1*C, -B - L1*D, F1, eye(m));
Vtilde2 = ss(A + L2*C, -B - L2*D, F2, eye(m));
Vtilde2 = ss(A + L2*C, -B - L2*D, F2, eye(m));
U1 = ss(A+B*F1, -L1 , F1, 0);
V1 = ss(A + B*F1, -L1, C + D*F1, eye(p));
U2 = ss(A+B*F2, -L2 , F2, 0);
V2 = ss(A + B*F2, -L2, C + D*F2, eye(p));
M = [A+B*F2 B; 
    C+D*F2 eye(m)];
N = [A+ B*F2 B; C+D*F2 D];
K1 = U1 \V1;
K2 = U2 \V2;
Q = Vtilde2*(K2 - K1)*V1;
KQ = (U1 + M*gamma*Q)*inv(V1 + N*gamma*Q)


%% Transition from K0 to K1 via Youla parameter
% Utilde1 = ss(A + L1*C, -L1, F1, 0);
% Vtilde1 = ss(A + L1*C, -B - L1*D, F1, eye(m));
% U1 = ss(A + B*F1, -L1, F1, 0);
% V1 = ss(A + B*F1, -L1, C + D*F1, eye(p));
% tildeFactors = inv([M U1; N V1]);
% Vtilde1 = tildeFactors(1:m,1:m);
% Q = Vtilde1*(K1 - K0)*V;
% KQ = (U + M*Q)*inv(V + N*Q);