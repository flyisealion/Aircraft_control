function dx = dynamical_system(x,t)
%航空機の運動方程式
%x=x0 = [u,alpha,q,theta,beta,p,r,phi,psi];
global A;
global B;
global u_input;
global U0;

dx = A*x+B*u_input;

u = x(1)+U0;%速度
UVW = [u;u*x(5);u*x(2)];%速度ベクトル[U,V,W]
dX = (Rotation_Z(-x(9)) * Rotation_Y(-x(4)) * Rotation_X(-x(8))) * UVW;
%dX = (Rotation_X(-x(9)) * Rotation_Y(-x(4)) * Rotation_Z(-x(8))) * UVW;
dx(10) = dX(1);
dx(11) = dX(2);
dx(12) = dX(3);

end

