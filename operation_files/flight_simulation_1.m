%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Flight simulation1
%   Oct.24 2021 Atsumi Toda
%
%   フライトシミュレーションの下地1
%   
%   https://butterfly-effect.hatenablog.com/entry/2014/11/18/184904
%   でのOctaveプログラムを移植したもの。運動方程式はode45で解く
%   安定微係数は、飛行機力学入門（加藤寬一郎　著）のp109から引用
%   後学の為の参考サイト
%   https://jp.mathworks.com/help/matlab/ref/ode45.html
%   http://www.ina111.org/archives/1057
%   https://kai-aeroastro.hatenablog.com/entry/2020/08/18/152905
%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
clear all;
close all;
clc;

addpath ../functions/

global A;
global B;
global u_input;
global U0;

%% 安定微係数
%有次元安定微係数p109
Xu = -0.0215;Zu = -0.227; Mu = 0.000;
Xa = 14.7; Za = -236; Ma = -3.76;
Xq = 0.0; Zq = -5.76; Mq = -0.992;
Yb = -45.4; Lb_ = -1.67; Nb_ = 0.943;
Yp = 0.716; Lp_ = -0.965; Np_ = -0.0876;
Yr = 2.66; Lr_ = 0.262; Nr_ = -0.208;

Xd_t = 0.0; Zd_e = -12.9; Zd_t = 0.0;
Md_e=-2.48;Md_t=0.0;
Yd_r = 9.17;Ld_a = 1.72; Ld_r = 0.216;
Nd_a = 0.0;Nd_t = 0.0;

%% 釣り合い速度や重力加速度など
W0 = 0;%[ft/s]%機体軸z軸速度
U0=293.8;%[ft/s]%機体軸x軸速度
theta0 = 0.05;%釣り合い時の定常pitch角度[rad]

%重力加速度
%g = 9.8065;%[m/s^2]
g = 32.168635;%[ft/s^2]
%% 係数行列
%縦の運動方程式の遷移行列
A_lat = [Xu,Xa,-W0,-g*cos(theta0);
         Zu/U0,Za/U0,(U0+Zq)/U0,-g*sin(theta0)/U0;
         Mu,Ma,Mq,0;
         0,0,1,0];

%横の運動方程式の遷移行列
A_lon  = [Yb,(W0+Yp),-(U0-Yr),g*cos(theta0),0;
          Lb_,Lp_,Lr_,0,0;
          Nb_,Np_,Nr_,0,0;
          0,1,tan(theta0),0,0;
          0,0,1/cos(theta0),0,0];

%縦の運動方程式の入力行列
B_lat = [0,Xd_t;
         Zd_e/U0,Zd_t/U0;
         Md_e,Md_t;
         0,0];

%横の運動方程式の入力行列
B_lon = [0,Yd_r;
         Ld_a,Ld_r;
         Nd_a,Nd_t;
         0,0;
         0,0];

%対角ブロックとしてシステムを結合する
A = blkdiag(A_lat,A_lon);
B = blkdiag(B_lat,B_lon);

%飛行軌跡の計算に用いるスペースを用意する
A = blkdiag(A,zeros(3));
B =  cat(1,B,zeros(3,4));

%% 飛行時間、状態量の初期値、入力ベクトル
duration_of_flight = 50;%飛行時間[s]
step = 10;%1sあたりの時間ステップ数
t = 0.0:1/step:duration_of_flight;

%初期値　x0 = [u,alpha,q,theta,beta,p,r,phi,psi];
x0_lat = [0.0;0.0;0.0;0.0];%縦の初期値[[u,alpha,q,theta]
%x0_lon = [0.0;0.6;0.4;0.2;0.2];%横の初期値
x0_lon = [0.0;0.0;0.0;0.0;0.0];%横の初期値[beta,p,r,phi,psi]
x0_pos = [0;0;1000];%機体の初期位置[ft]

x0 = vertcat(x0_lat,x0_lon,x0_pos);

%操舵入力
u_input = [0.1;0.0;0.0;0.0];%elevator[rad],throttle ,aileron[rad],rudder[rad]

%% 運動方程式を解く
[t,x] = ode45(@(t,x) dynamical_system(x,t), t, x0);

%% グラフの描画
%一枚目
figure(1);

plot(t,x(:,1),'-.');
hold on
legend("u[ft/s]")%機体x軸速度の釣り合い速度からの変化
xlabel("time[s]")

%2枚目
figure(2);

plot(t,x(:,2),'-.');
hold on
plot(t,x(:,5),'-.');
hold on
legend('alpha[rad]','beta[rad]')%迎え角と横滑り角の変化
xlabel("time[s]")

%3枚目
figure(3);
plot3(x(:,10),x(:,11),x(:,12))%位置の履歴[ft]
grid on
