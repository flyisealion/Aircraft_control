%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Flight simulation2
%   Oct.31 2021 Atsumi Toda
%
%   フライトシミュレーションの下地2
%   
%   安定微係数は、飛行機力学入門（加藤寬一郎　著）のp109から引用
%   各運動モードにおける固有振動数、減衰率や根を求める。
%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
clear all;
close all;
clc;

global U0;

%% 安定微係数
%有次元安定微係数p109
Xu = -0.0215;Zu = -0.227; Mu = 0.000;
Xa = 14.7; Za = -236; Ma = -3.76;
Ma_dot = -0.280;
Xq = 0.0; Zq = -5.76; Mq = -0.992;
Yb = -45.4; Lb_ = -1.67; Nb_ = 0.943;
Yp = 0.716; Lp_ = -0.965; Np_ = -0.0876;
Yr = 2.66; Lr_ = 0.262; Nr_ = -0.208;

Xd_t = 0.0; Zd_e = -12.9; Zd_t = 0.0;
Md_e=-2.48;Md_t=0.0;
Yd_r = 9.17;Ld_a = 1.72; Ld_r = 0.216;
Nd_a = 0.0;Nd_r = -0.666;

%% 釣り合い速度や重力加速度など
W0 = 0;%[ft/s]%機体軸z軸速度
U0=293.8;%[ft/s]%機体軸x軸速度
%theta0 = 0.05;%釣り合い時の定常pitch角度[rad]
theta0 = 0.00;%釣り合い時の定常pitch角度[rad]

alpha_zero = 0.05;%釣り合い時の迎え角[rad]

%重力加速度
%g = 9.8065;%[m/s^2]
g = 32.168635;%[ft/s^2]

%% 縦運動

%縦の短周期モード p117
%短周期モードの固有角振動数omega_nsp[1/s]（近似）を求める。
omega_nsp = sqrt( -Ma+(Za/U0)*Mq )
%短周期モードの減衰率zeta_sp（近似）を求める。
zeta_sp = (-(Za/U0)-Mq-Ma_dot)/(2*omega_nsp)

%縦の長周期モード p119
%長周期モードの固有角振動数omega_nlp[1/s]（近似）を求める。
omega_nlp =  sqrt(2)*g/U0
%短周期モードの減衰率zeta_sp（近似）を求める。
zeta_lp = -Xu/(2*omega_nlp)

%% 横運動
%ロールモード
%ロールモードの根 lamda_Rの近似を求める
lamda_R = (-1)*Lp_

%スパイラルモード
%スパイラルモードの根 lamda_Sの近似を求める
D = -Nb_*Lp_+Lb_*( Np_-g/U0+ Nr_*alpha_zero);
E = (Lb_*Nr_ - Nb_*(Lr_-Lp_ *theta0))*(g/U0);
lamda_S = E/D

%ダッチロールモード p125
%ダッチロールモードの固有角振動数omega_nd[1/s]（近似）を求める。p132
omega_nd = sqrt(Nb_-(Np_/Lp_)*Lb_) 
%ダッチロールモードの減衰率zeta_d（近似）を求める。p132
zeta_d = -(Yb/U0-Nr_-(Lb_/Nb_)*(Np_-(g/U0)))/(2*omega_nd)%式5.60
%zeta_d = (Yb/U0-Nr_)/(2*omega_nd)
%zeta_d = -(Nr_-(Np_/Lp_)*Lr_+(Np_/(Lp_*Lp_))*Lb_)/(2*omega_nd)%式5.59(c)

